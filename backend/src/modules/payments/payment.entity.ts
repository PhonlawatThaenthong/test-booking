import {
  Column, CreateDateColumn, Entity, Index, JoinColumn, ManyToOne,
  PrimaryGeneratedColumn, UpdateDateColumn,
} from 'typeorm';
import { numericTransformer } from '../../common/numeric.transformer';
import { Booking } from '../bookings/booking.entity';

export enum PaymentMethod {
  CARD = 'card',
  PROMPTPAY = 'promptpay',
}

export enum PaymentGatewayStatus {
  PENDING = 'pending',
  SUCCEEDED = 'succeeded',
  FAILED = 'failed',
  REFUNDED = 'refunded',
}

/**
 * One row per booking (1:1 — see the unique index on booking_id). No card
 * number, CVV, or any cardholder data is ever stored here; a real gateway
 * integration would only add `gatewayRef`. See docs/database-schema.md
 * section 3.5 and section 10 of the design doc for why.
 */
@Entity('payments')
export class Payment {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Index({ unique: true })
  @Column({ name: 'booking_id', type: 'uuid' })
  bookingId!: string;

  @ManyToOne(() => Booking, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'booking_id' })
  booking!: Booking;

  @Column({ type: 'enum', enum: PaymentMethod })
  method!: PaymentMethod;

  @Column({
    type: 'numeric', precision: 10, scale: 2, transformer: numericTransformer,
  })
  amount!: number;

  @Column({ name: 'gateway_ref', type: 'varchar', length: 100, nullable: true })
  gatewayRef!: string | null;

  @Index({ unique: true })
  @Column({ name: 'idempotency_key', length: 100 })
  idempotencyKey!: string;

  @Column({ type: 'enum', enum: PaymentGatewayStatus, default: PaymentGatewayStatus.PENDING })
  status!: PaymentGatewayStatus;

  @Column({ name: 'paid_at', type: 'timestamptz', nullable: true })
  paidAt!: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt!: Date;
}
