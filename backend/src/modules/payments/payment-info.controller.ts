import {
  Controller, Get, NotFoundException, StreamableFile,
} from '@nestjs/common';
import { createReadStream, existsSync } from 'fs';
import { getPaymentConfig } from '../../config/payment.config';

/**
 * Public payment information: the resort's static PromptPay QR and account
 * details. No auth — the QR is the same for everyone and contains no secret;
 * the amount is not embedded (the app already knows the booking total).
 */
@Controller('payment')
export class PaymentInfoController {
  private readonly cfg = getPaymentConfig();

  @Get('info')
  info() {
    return {
      accountName: this.cfg.accountName,
      promptPayId: this.cfg.promptPayId,
      note: this.cfg.note,
      qrImageUrl: '/api/payment/qr-image',
    };
  }

  @Get('qr-image')
  qrImage(): StreamableFile {
    if (!existsSync(this.cfg.qrImagePath)) {
      throw new NotFoundException('ยังไม่ได้ตั้งค่ารูป QR สำหรับการชำระเงิน');
    }
    return new StreamableFile(createReadStream(this.cfg.qrImagePath), { type: 'image/png' });
  }
}
