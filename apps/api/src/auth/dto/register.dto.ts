import {
  IsEmail,
  IsOptional,
  IsString,
  Matches,
  MinLength,
  ValidateIf,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiPropertyOptional({ example: 'user@example.com' })
  @ValidateIf((o: RegisterDto) => !o.phone)
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ example: '+919876543210' })
  @ValidateIf((o: RegisterDto) => !o.email)
  @Matches(/^\+[1-9]\d{6,14}$/, {
    message: 'phone must be in E.164 format (e.g. +919876543210)',
  })
  phone?: string;

  @IsString()
  @MinLength(8, { message: 'password must be at least 8 characters' })
  password: string;

  @IsOptional()
  @IsString()
  name?: string;
}
