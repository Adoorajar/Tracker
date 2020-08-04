import { Controller, Get, Post, Param, Body, Put, Delete, Query } from '@nestjs/common';
import { IssuesService } from './issues.service';
import { IssueDto } from './dto/issue.dto';
import { Issue } from './schemas/issue.schema';

@Controller('issues')
export class IssuesController {
    constructor(private readonly issuesService: IssuesService) {}

    @Post()
    async create(@Body() issueDto: IssueDto) {
        await this.issuesService.create(issueDto);
    }

    @Get()
    async findAll(@Query() query: IssueDto) {
        return this.issuesService.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        console.log(id);
        return `This action returns the issue with id: ${id}`;
    }

    @Put(':id')
    update(@Param('id') id: string, @Body() updateIssueDto: IssueDto) {
        return `This action updates a #${id} issue`;
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return `This action remove a #${id} issue`;
    }
}
