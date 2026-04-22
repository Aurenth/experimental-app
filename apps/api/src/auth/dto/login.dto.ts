import { IsString, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({
    example: 'user@example.com',
    description: 'Email address or phone number (E.164 format)',
  })
  @IsString()
  identifier: string;

  @ApiProperty()
  @IsString()
  @MinLength(8)
  password: string;
}
