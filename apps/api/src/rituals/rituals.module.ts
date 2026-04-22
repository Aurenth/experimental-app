import { Module } from '@nestjs/common';
import { RitualsController } from './rituals.controller';
import { RitualsService } from './rituals.service';

@Module({
  controllers: [RitualsController],
  providers: [RitualsService],
  exports: [RitualsService],
})
export class RitualsModule {}
