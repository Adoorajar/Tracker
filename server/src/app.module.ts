import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { IssuesController } from './issues/issues.controller';

@Module({
  imports: [],
  controllers: [AppController, IssuesController],
  providers: [AppService],
})
export class AppModule {}
