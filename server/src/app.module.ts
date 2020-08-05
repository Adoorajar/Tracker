import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { IssuesModule } from './issues/issues.module';
import { IssuesController } from './issues/issues.controller';
import { ProjectsController } from './projects/projects.controller';
import { ProjectsService } from './projects/projects.service';
import { ProjectsModule } from './projects/projects.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://localhost/tracker'),
    IssuesModule,
    ProjectsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
