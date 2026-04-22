import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsPositive,
  IsString,
  Min,
} from 'class-validator';

export class CreateOrderDto {
  @ApiProperty({ description: 'Product identifier', example: 'app_unlock' })
  @IsString()
  productId: string;

  @ApiProperty({
    description: 'Product type',
    enum: ['one_time', 'consumable'],
  })
  @IsIn(['one_time', 'consumable'])
  productType: 'one_time' | 'consumable';

  @ApiProperty({ description: 'Amount in paise (INR × 100)', example: 29900 })
  @IsInt()
  @IsPositive()
  amount: number;

  @ApiPropertyOptional({
    description: 'Credits to grant for consumable products',
    example: 100,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  creditAmount?: number;
}
