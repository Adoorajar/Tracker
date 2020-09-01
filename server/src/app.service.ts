import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getTracker(): string {
    return 'Hello World!';
  }
}
