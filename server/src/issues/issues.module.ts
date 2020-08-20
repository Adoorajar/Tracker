import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { IssuesController } from './issues.controller';
import { IssuesService } from './issues.service';
import { Issue, IssueSchema } from './schemas/issue.schema';
import { Project, ProjectSchema } from '../projects/schemas/project.schema';
import { ProjectsService } from '../projects/projects.service';

@Module({
    imports: [MongooseModule.forFeature([
        { name: Issue.name, schema: IssueSchema},
        { name: Project.name, schema: ProjectSchema }
    ])],
    controllers: [IssuesController],
    providers: [IssuesService, ProjectsService],
})

export class IssuesModule {}