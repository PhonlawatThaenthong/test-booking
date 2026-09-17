import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Payment } from './payment.entity';
import { PaymentsService } from './payments.service';
import { StaffPaymentsController } from './staff-payments.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Payment])],
  controllers: [StaffPaymentsController],
  providers: [PaymentsService],
  exports: [PaymentsService],
})
export class PaymentsModule {}
