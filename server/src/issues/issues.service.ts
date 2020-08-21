import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Issue } from './schemas/issue.schema';
import { IssueDto } from './dto/issue.dto';
import { ProjectsService } from '../projects/projects.service';

@Injectable()
export class IssuesService implements IssuesServiceResponse {
    constructor(
        @InjectModel(Issue.name) private issueModel: Model<Issue>,
        private readonly projectsService: ProjectsService
        ) {} 

    async create(issueDto: IssueDto): Promise<CreateIssueResponse> {
        const projectResponse = await this.projectsService.findOne(issueDto.project);
        switch (projectResponse.status) {
            case "success":
                const project = projectResponse.project;
                const issueKey = `${project.name}-${project.issues.length + 1}`
                const issueObject = {
                    key: issueKey,
                    ...issueDto
                }
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

    async findOne(key: string): Promise<FindIssueResponse> {
        const issue = await this.issueModel.findOne({ key: key }).exec();
        switch (issue) {
            case null:
                const findIssueFailure = {
                    status: "failed"
                }
                return findIssueFailure;
            default:
                const findIssueSuccess = {
                    status: "success",
                    issue: issue
                }
                return findIssueSuccess;
        }
    }

    async updateStatus(id: string, status: string): Promise<UpdateIssueResponse> {
        const query = { _id: id };
        const updateStatusResult = await this.issueModel.findOneAndUpdate(query, { status: status }).exec();
        switch (updateStatusResult) {
            case null:
                const updateStatusFailure = {
                    status: "failed"
                }
                return updateStatusFailure;
            default:
                const updateStatusSuccess = {
                    status: "success"
                }
                return updateStatusSuccess;
        }
    }

    async findAll(): Promise<Issue[]> {
        return this.issueModel.find().exec();
    }
}

interface IssuesServiceResponse {
    create(s: IssueDto): Promise<CreateIssueResponse>;
    findOne(s: string): Promise<FindIssueResponse>;
    updateStatus(s: string, t: string): Promise<UpdateIssueResponse>;
}

type CreateIssueResponse = {
    status: string,
    message?: string,
    issue?: Issue
}

type FindIssueResponse = {
    status: string,
    issue?: Issue
}

type UpdateIssueResponse = {
    status: string
}


