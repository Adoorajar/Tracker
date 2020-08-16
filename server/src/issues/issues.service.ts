import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Issue } from './schemas/issue.schema';
import { IssueDto } from './dto/issue.dto';
import { Project } from '../projects/schemas/project.schema';
import { ProjectDto } from '../projects/dto/project.dto';

@Injectable()
export class IssuesService {
    constructor(
        @InjectModel(Issue.name) private issueModel: Model<Issue>,
        @InjectModel(Project.name) private projectModel: Model<Project>
        ) {} 

    async create(issueDto: IssueDto): Promise<Issue> {
        
        const createdIssue = new this.issueModel(issueDto);
        const foundProject = await this.findProject(issueDto.project);
        foundProject.issues.push(createdIssue);
        //foundProject.issues.push(createdIssue);
        foundProject.save();
        return createdIssue.save();
    }

    async findAll(): Promise<Issue[]> {
        return this.issueModel.find().exec();
    }

    async findProject(name: string): Promise<Project> {
        return this.projectModel.findOne({ name: name }).exec();
    }
}