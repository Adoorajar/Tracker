import { Controller, Get, Post, Param, Body, Put, Delete, Query } from '@nestjs/common';
import { ProjectsService } from './projects.service';
import { ProjectDto } from './dto/project.dto';
import { Project } from './schemas/project.schema';

@Controller('projects')
export class ProjectsController {
    constructor(private readonly projectsService: ProjectsService) {}

    @Post()
    async create(@Body() projectDto: ProjectDto) {
        return this.projectsService.create(projectDto);
    }

    @Get()
    async findAll(@Query() query: ProjectDto) {
        return this.projectsService.findAll();
    }

    @Get(':name')
    findOne(@Param('name') name: string) {
        console.log(name);
        return this.projectsService.findOne(name);
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
