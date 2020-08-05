import { Controller, Get, Post, Param, Body, Put, Delete, Query } from '@nestjs/common';
import { ProjectsService } from './projects.service';
import { ProjectDto } from './dto/project.dto';
import { Project } from './schemas/project.schema';

@Controller('projects')
export class ProjectsController {
    constructor(private readonly projectsService: ProjectsService) {}

    @Post()
    async create(@Body() projectDto: ProjectDto) {
        await this.projectsService.create(projectDto);
    }

    @Get()
    async findAll(@Query() query: ProjectDto) {
        return this.projectsService.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        console.log(id);
        return `This action returns the project with id: ${id}`;
    }

    @Put(':id')
    update(@Param('id') id: string, @Body() projectDto: ProjectDto) {
        return `This action updates a #${id} project`;
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return `This action remove a #${id} project`;
    }
}
