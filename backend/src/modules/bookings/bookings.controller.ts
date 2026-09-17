import {
  Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, UseGuards,
} from '@nestjs/common';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { PayBookingDto } from './dto/pay-booking.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser, JwtPayload } from '../../common/decorators/current-user.decorator';

/** Customer-facing bookings. The customer is always taken from the JWT. */
@Controller('bookings')
@UseGuards(JwtAuthGuard)
export class BookingsController {
  constructor(private readonly bookings: BookingsService) {}

  @Post()
  create(@CurrentUser() user: JwtPayload, @Body() dto: CreateBookingDto) {
    return this.bookings.create(user.sub, dto);
  }

  @Get('me')
  mine(@CurrentUser() user: JwtPayload) {
    return this.bookings.findForCustomer(user.sub);
  }

  /** The charge itself is still a stub — see BookingsService.markPaid. */
  @Post(':id/pay')
  @HttpCode(200)
  pay(
    @CurrentUser() user: JwtPayload,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: PayBookingDto,
  ) {
    return this.bookings.markPaid(id, user.sub, user.role, dto);
  }

  @Post(':id/cancel')
  @HttpCode(200)
  cancel(@CurrentUser() user: JwtPayload, @Param('id', ParseUUIDPipe) id: string) {
    return this.bookings.cancel(id, user.sub, user.role);
  }
}
