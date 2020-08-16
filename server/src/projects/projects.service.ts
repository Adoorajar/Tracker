import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Project } from './schemas/project.schema';
import { ProjectDto } from './dto/project.dto';

@Injectable()
export class ProjectsService {
    constructor(@InjectModel(Project.name) private projectModel: Model<Project>) {}

    async create(projectDto: ProjectDto): Promise<Project> {
        const createdProject = new this.projectModel(projectDto);
        return createdProject.save();
    }

    async findAll(): Promise<Project[]> {
        return this.projectModel.find().exec();
    }

    async findOne(name: string): Promise<Project> {
        return this.projectModel.findOne({ name: name }).exec();
    }
}
