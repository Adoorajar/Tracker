import { Module } from '@nestjs/common';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { IssuesModule } from './issues/issues.module';
import { ProjectsModule } from './projects/projects.module';

const mdb_uri = 'mongodb://localhost/tracker';
const mdb_options = {
  useCreateIndex: true,
  useFindAndModify: false
};

@Module({
  imports: [
    MongooseModule.forRoot(mdb_uri, mdb_options),
    ServeStaticModule.forRoot({
      rootPath : join(__dirname, '..', 'public'),
    }),
    IssuesModule,
    ProjectsModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
