import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createHmac, timingSafeEqual } from 'crypto';
import Razorpay from 'razorpay';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { VerifyPaymentDto } from './dto/verify-payment.dto';

@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);
  private readonly razorpay: Razorpay;
  private readonly webhookSecret: string;

  constructor(
    private prisma: PrismaService,
    private config: ConfigService,
  ) {
    this.razorpay = new Razorpay({
      key_id: this.config.getOrThrow<string>('RAZORPAY_KEY_ID'),
      key_secret: this.config.getOrThrow<string>('RAZORPAY_KEY_SECRET'),
    });
    this.webhookSecret = this.config.getOrThrow<string>(
      'RAZORPAY_WEBHOOK_SECRET',
    );
  }

  async createOrder(userId: string, dto: CreateOrderDto) {
    // For one_time products, block duplicate purchases
    if (dto.productType === 'one_time') {
      const existing = await this.prisma.entitlement.findUnique({
        where: { userId_productId: { userId, productId: dto.productId } },
      });
      if (existing?.granted) {
        throw new ConflictException(
          `Product ${dto.productId} already unlocked`,
        );
      }
    }

    const receipt = `rcpt_${userId.slice(-8)}_${Date.now()}`;

    const rzpOrder = await this.razorpay.orders.create({
      amount: dto.amount,
      currency: 'INR',
      receipt,
      notes: { userId, productId: dto.productId },
    });

    const order = await this.prisma.razorpayOrder.create({
      data: {
        razorpayId: rzpOrder.id,
        userId,
        amount: dto.amount,
        currency: 'INR',
        receipt,
        productId: dto.productId,
        productType: dto.productType,
        creditAmount: dto.creditAmount,
        notes: rzpOrder.notes as object,
      },
    });

    return {
      orderId: order.razorpayId,
      amount: order.amount,
      currency: order.currency,
      receipt: order.receipt,
    };
  }

  async verifyPayment(userId: string, dto: VerifyPaymentDto) {
    const order = await this.prisma.razorpayOrder.findUnique({
      where: { razorpayId: dto.razorpayOrderId },
    });

    if (!order || order.userId !== userId) {
      throw new UnauthorizedException('order not found');
    }

    if (order.status === 'PAID') {
      throw new ConflictException('payment already verified');
    }

    this.verifySignature(
      `${dto.razorpayOrderId}|${dto.razorpayPaymentId}`,
      dto.razorpaySignature,
      this.config.getOrThrow<string>('RAZORPAY_KEY_SECRET'),
    );

    const [payment] = await this.prisma.$transaction([
      this.prisma.payment.create({
        data: {
          razorpayPaymentId: dto.razorpayPaymentId,
          razorpayOrderId: dto.razorpayOrderId,
          razorpaySignature: dto.razorpaySignature,
          status: 'VERIFIED',
          verifiedAt: new Date(),
        },
      }),
      this.prisma.razorpayOrder.update({
        where: { razorpayId: dto.razorpayOrderId },
        data: { status: 'PAID' },
      }),
    ]);

    await this.grantEntitlement(order, payment.razorpayPaymentId);

    return { success: true, paymentId: payment.razorpayPaymentId };
  }

  async handleWebhook(rawBody: Buffer, signature: string): Promise<void> {
    this.verifySignature(rawBody.toString(), signature, this.webhookSecret);

    const event = JSON.parse(rawBody.toString()) as {
      event: string;
      payload: {
        payment?: { entity: { id: string; order_id: string } };
        order?: { entity: { id: string; status: string } };
      };
    };

    this.logger.log(`Razorpay webhook: ${event.event}`);

    switch (event.event) {
      case 'payment.captured':
        await this.handlePaymentCaptured(event.payload.payment!.entity);
        break;
      case 'payment.failed':
        await this.handlePaymentFailed(event.payload.payment!.entity);
        break;
      default:
        // Unhandled events are silently acknowledged
        break;
    }
  }

  async getEntitlements(userId: string) {
    return this.prisma.entitlement.findMany({
      where: { userId, granted: true },
      select: {
        productId: true,
        credits: true,
        expiresAt: true,
        createdAt: true,
      },
    });
  }

  // ─── Private helpers ────────────────────────────────────────────────────────

  private verifySignature(
    payload: string,
    signature: string,
    secret: string,
  ): void {
    const expected = createHmac('sha256', secret)
      .update(payload)
      .digest('hex');

    const expectedBuf = Buffer.from(expected, 'utf8');
    const receivedBuf = Buffer.from(signature, 'utf8');

    // Constant-time comparison to prevent timing attacks
    if (
      expectedBuf.length !== receivedBuf.length ||
      !timingSafeEqual(expectedBuf, receivedBuf)
    ) {
      throw new UnauthorizedException('invalid signature');
    }
  }

  private async grantEntitlement(
    order: { userId: string; productId: string; productType: string; creditAmount: number | null },
    paymentId: string,
  ): Promise<void> {
    if (order.productType === 'one_time') {
      await this.prisma.entitlement.upsert({
        where: {
          userId_productId: {
            userId: order.userId,
            productId: order.productId,
          },
        },
        create: {
          userId: order.userId,
          productId: order.productId,
          granted: true,
          paymentId,
        },
        update: { granted: true, paymentId },
      });
    } else if (order.productType === 'consumable' && order.creditAmount) {
      await this.prisma.entitlement.upsert({
        where: {
          userId_productId: {
            userId: order.userId,
            productId: order.productId,
          },
        },
        create: {
          userId: order.userId,
          productId: order.productId,
          granted: true,
          credits: order.creditAmount,
          paymentId,
        },
        update: {
          credits: { increment: order.creditAmount },
          paymentId,
        },
      });
    }
  }

  private async handlePaymentCaptured(entity: {
    id: string;
    order_id: string;
  }): Promise<void> {
    const order = await this.prisma.razorpayOrder.findUnique({
      where: { razorpayId: entity.order_id },
    });

    if (!order) {
      this.logger.warn(
        `Webhook: order ${entity.order_id} not found in DB — ignoring`,
      );
      return;
    }

    if (order.status === 'PAID') return; // already processed via verify endpoint

    await this.prisma.razorpayOrder.update({
      where: { razorpayId: entity.order_id },
      data: { status: 'PAID' },
    });

    const existing = await this.prisma.payment.findUnique({
      where: { razorpayPaymentId: entity.id },
    });

    if (!existing) {
      await this.prisma.payment.create({
        data: {
          razorpayPaymentId: entity.id,
          razorpayOrderId: entity.order_id,
          razorpaySignature: '',
          status: 'VERIFIED',
          verifiedAt: new Date(),
        },
      });
    }

    await this.grantEntitlement(order, entity.id);
  }

  private async handlePaymentFailed(entity: {
    id: string;
    order_id: string;
  }): Promise<void> {
    await this.prisma.razorpayOrder.updateMany({
      where: { razorpayId: entity.order_id, status: { not: 'PAID' } },
      data: { status: 'FAILED' },
    });
  }
}
