import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { IssuesController } from './issues/issues.controller';

@Module({
  imports: [MongooseModule.forRoot('mongodb://localhost/tracker')],
  controllers: [AppController, IssuesController],
  providers: [AppService],
})
export class AppModule {}
