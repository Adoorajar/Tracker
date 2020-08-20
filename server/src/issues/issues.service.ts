import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Issue } from './schemas/issue.schema';
import { IssueDto } from './dto/issue.dto';
import { Project } from '../projects/schemas/project.schema';
import { ProjectDto } from '../projects/dto/project.dto';
import { ProjectsService } from '../projects/projects.service';
import { create } from 'domain';

@Injectable()
export class IssuesService implements IssuesServiceResponse {
    constructor(
        @InjectModel(Issue.name) private issueModel: Model<Issue>,
        //@InjectModel(Project.name) private projectModel: Model<Project>
        private readonly projectsService: ProjectsService
        ) {} 

    async create(issueDto: IssueDto): Promise<CreateIssueResponse> {
        console.log(`incoming issue is: ${JSON.stringify(issueDto)}`);
        
        const projectResponse = await this.projectsService.findOne(issueDto.project);
        switch (projectResponse.status) {
            case "success":
                const project = projectResponse.project;
                console.log(`found project is: ${JSON.stringify(project)}`);

                const issueKey = `${project.name}-${project.issues.length + 1}`
                const issueObject = {
                    key: issueKey,
                    ...issueDto
                }
                console.log(`issueObject is: ${JSON.stringify(issueObject)}`);
                
                console.log(`issues count is: ${JSON.stringify(project.issues.length)}`);
                const createdIssue = new this.issueModel(issueObject);
                project.issues.push(createdIssue);
                project.save();
                const issue = await createdIssue.save();
                const createIssueSuccess = {
                    status: "success",
                    issue: issue
                }
                return createIssueSuccess;
            case "failed":
                const createIssueFailure = {
                    status: "failed",
                    message: `Unable to create issue with project name ${issueDto.project} because that project doesn't exist`
                }
                return createIssueFailure;
        }
        
    }

    async findAll(): Promise<Issue[]> {
        return this.issueModel.find().exec();
    }
}

interface IssuesServiceResponse {
    create(s: IssueDto): Promise<CreateIssueResponse>;
}

type CreateIssueResponse = {
    status: string,
    message?: string,
    issue?: Issue
}


