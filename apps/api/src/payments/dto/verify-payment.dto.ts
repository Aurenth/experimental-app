import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class VerifyPaymentDto {
  @ApiProperty({ description: 'Razorpay order ID (rzp_order_xxx)' })
  @IsString()
  razorpayOrderId: string;

  @ApiProperty({ description: 'Razorpay payment ID (pay_xxx)' })
  @IsString()
  razorpayPaymentId: string;

  @ApiProperty({ description: 'HMAC-SHA256 signature from Razorpay' })
  @IsString()
  razorpaySignature: string;
}
