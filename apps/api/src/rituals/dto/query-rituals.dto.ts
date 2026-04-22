import { IsBoolean, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';

export class QueryRitualsDto {
  @ApiPropertyOptional({ example: 'festival', description: 'festival | lifecycle | monthly | seasonal' })
  @IsOptional()
  @IsString()
  category?: string;

  @ApiPropertyOptional({ example: 'north', description: 'north | south | east | west | jain | sikh | buddhist' })
  @IsOptional()
  @IsString()
  tradition?: string;

  @ApiPropertyOptional({ example: 'hi', description: 'Language code filter' })
  @IsOptional()
  @IsString()
  language?: string;

  @ApiPropertyOptional({ example: true, description: 'Filter free-only rituals' })
  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  @IsBoolean()
  free?: boolean;

  @ApiPropertyOptional({ example: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ example: 20, default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize?: number = 20;
}
