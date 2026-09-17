import { Controller, Get, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/user.entity';

/** Payment audit trail for the back office. No customer-facing routes: the
 * customer's own payment state is already part of the booking response. */
@Controller('staff/payments')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.STAFF, UserRole.ADMIN)
export class StaffPaymentsController {
  constructor(private readonly payments: PaymentsService) {}

  @Get()
  findAll() {
    return this.payments.findAll();
  }
}
