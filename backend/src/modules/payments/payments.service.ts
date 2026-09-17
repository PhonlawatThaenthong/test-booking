import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { randomUUID } from 'crypto';
import { Payment, PaymentGatewayStatus, PaymentMethod } from './payment.entity';

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment) private readonly repo: Repository<Payment>,
  ) {}

  /** `GET /api/staff/payments` */
  findAll(): Promise<Payment[]> {
    return this.repo.find({ relations: { booking: true }, order: { createdAt: 'DESC' } });
  }

  /**
   * Records a successful charge for a booking. `booking_id` is unique, so a
   * booking can only ever have one payment row — calling this again for a
   * booking that already succeeded is a no-op that returns the existing row,
   * which is what makes `BookingsService.markPaid` safe to call twice.
   *
   * There is no real gateway behind this yet (Sprint 4 stub, same as the
   * `pay` endpoint it backs) — it "succeeds" immediately instead of waiting
   * on an async webhook, so `gatewayRef` stays null and `idempotencyKey` is
   * generated here rather than supplied by a gateway.
   */
  async recordSuccess(
    bookingId: string,
    amount: number,
    method: PaymentMethod = PaymentMethod.CARD,
  ): Promise<Payment> {
    const existing = await this.repo.findOne({ where: { bookingId } });
    if (existing && existing.status === PaymentGatewayStatus.SUCCEEDED) {
      return existing;
    }

    const payment = existing ?? this.repo.create({
      bookingId,
      idempotencyKey: randomUUID(),
    });
    payment.method = method;
    payment.amount = amount;
    payment.status = PaymentGatewayStatus.SUCCEEDED;
    payment.paidAt = new Date();
    return this.repo.save(payment);
  }

  /** Marks the booking's payment refunded when a paid booking is cancelled. */
  async recordRefund(bookingId: string): Promise<void> {
    const payment = await this.repo.findOne({ where: { bookingId } });
    if (!payment || payment.status !== PaymentGatewayStatus.SUCCEEDED) return;
    payment.status = PaymentGatewayStatus.REFUNDED;
    await this.repo.save(payment);
  }
}
