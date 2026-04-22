import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Post,
  RawBodyRequest,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Request } from 'express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { PaymentsService } from './payments.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { VerifyPaymentDto } from './dto/verify-payment.dto';

interface AuthUser {
  id: string;
}

@ApiTags('payments')
@Controller('payments')
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @Post('orders')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a Razorpay order before initiating payment' })
  @ApiResponse({ status: 201, description: 'Order created — use orderId in Razorpay SDK' })
  @ApiResponse({ status: 409, description: 'Product already unlocked (one_time)' })
  createOrder(@CurrentUser() user: AuthUser, @Body() dto: CreateOrderDto) {
    return this.paymentsService.createOrder(user.id, dto);
  }

  @Post('verify')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Verify payment signature and grant entitlement' })
  @ApiResponse({ status: 200, description: 'Payment verified, entitlement granted' })
  @ApiResponse({ status: 401, description: 'Invalid signature' })
  verifyPayment(@CurrentUser() user: AuthUser, @Body() dto: VerifyPaymentDto) {
    return this.paymentsService.verifyPayment(user.id, dto);
  }

  @Post('webhook')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Razorpay webhook receiver (HMAC-verified)' })
  @ApiResponse({ status: 200, description: 'Event processed' })
  async webhook(
    @Req() req: RawBodyRequest<Request>,
    @Headers('x-razorpay-signature') signature: string,
  ) {
    await this.paymentsService.handleWebhook(req.rawBody!, signature);
    return { received: true };
  }

  @Get('entitlements')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Get authenticated user's entitlements" })
  @ApiResponse({ status: 200, description: 'List of active entitlements' })
  getEntitlements(@CurrentUser() user: AuthUser) {
    return this.paymentsService.getEntitlements(user.id);
  }
}
