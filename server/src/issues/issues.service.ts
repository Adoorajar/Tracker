import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Issue } from './schemas/issue.schema';
import { IssueDto } from './dto/issue.dto';

@Injectable()
export class IssuesService {
    constructor(@InjectModel(Issue.name) private issueModel: Model<Issue>) {} 

    async create(issueDto: IssueDto): Promise<Issue> {
        const createdIssue = new this.issueModel(issueDto);
        return createdIssue.save();
    }

    async findAll(): Promise<Issue[]> {
        return this.issueModel.find().exec();
    }
}