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
        console.log(`incoming issue is: ${JSON.stringify(issueDto)}`);
        
        const foundProject = await this.findProject(issueDto.project);
        const issueKey = `${foundProject.key}-${foundProject.issues.length + 1}`
        const issueObject = {
            key: issueKey,
            ...issueDto
        }
        console.log(`issueObject is: ${JSON.stringify(issueObject)}`);
        console.log(`found project is: ${JSON.stringify(foundProject)}`);
        console.log(`issues count is: ${JSON.stringify(foundProject.issues.length)}`);
        const createdIssue = new this.issueModel(issueObject);
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