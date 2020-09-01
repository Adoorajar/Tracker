import { Controller, Get, Res, Req } from '@nestjs/common';
import { Response, Request } from 'express';
import { join } from 'path';

@Controller()
export class AppController {

  @Get('/')
  getTracker(
    @Res() res: Response,
    @Req() Req: Request,
  ) {
    //return this.appService.getTracker();
    res.sendFile(join(__dirname, '..', 'public/index.html'));
  }
}
