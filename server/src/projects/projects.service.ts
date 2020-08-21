import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Project } from './schemas/project.schema';
import { ProjectDto } from './dto/project.dto';

@Injectable()
export class ProjectsService implements ProjectsServiceResponse {

    constructor(
        @InjectModel(Project.name) private projectModel: Model<Project>
    ) {}

    async create(projectDto: ProjectDto): Promise<CreateProjectResponse> {
        const findProjectResult = await this.findOne(projectDto.name);
        switch (findProjectResult.status) {
            case "failed":
                const createdProject = new this.projectModel(projectDto);
                const project = await createdProject.save();
                switch (project) {
                    case null:
                        const createProjectFailure = {
                            status: "failed"
                        }
                        return createProjectFailure;
                    default:
                        const createProjectSuccess = {
                            status: "success",
                            project: project
                        }
                        return createProjectSuccess;
                }
            case "success":
                const createProjectFailure = {
                    status: "failed",
                    message: `Couldn't create project with name ${projectDto.name} because it already exists`
                }
                return createProjectFailure;
        }
        
        
    }

    async findAll(): Promise<Project[]> {
        return this.projectModel.find().exec();
    }

    async findOne(name: string): Promise<FindProjectResponse> {
        const project = await this.projectModel.findOne({ name: name }).exec();
        switch (project) {
            case null:
                const findProjectFailure = {
                    status: "failed"
                }
                return findProjectFailure;
            default:
                const findProjectSuccess = {
                    status: "success",
                    project: project
                }
                return findProjectSuccess;
        }
    }
}

interface ProjectsServiceResponse {
    create(s: ProjectDto): Promise<CreateProjectResponse>;
    findOne(s: string): Promise<FindProjectResponse>;
}

type CreateProjectResponse = {
    status: string,
    message?: string,
    project?: Project
}

type FindProjectResponse = {
    status: string,
    project?: Project
}
