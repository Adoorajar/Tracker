import { Controller, Get, Post, Param, Body, Put, Delete, Query } from '@nestjs/common';
import { IssuesService } from './issues.service';
import { IssueDto } from './dto/issue.dto';
import { Issue } from './schemas/issue.schema';

@Controller('issues')
export class IssuesController {
    constructor(private readonly issuesService: IssuesService) {}

    @Post()
    async create(@Body() issueDto: IssueDto) {
        return this.issuesService.create(issueDto);
    }

    @Get()
    async findAll(@Query() query: IssueDto): Promise<Issue[]> {
        return this.issuesService.findAll();
    }

    @Get(':key')
    findOne(@Param('key') key: string) {
        return this.issuesService.findOne(key);
    }

    @Put(':id')
    update(@Param('id') id: string, @Body() issueDto: IssueDto): string {
        return `This action updates a #${id} issue`;
    }

    @Delete(':id')
    remove(@Param('id') id: string): string {
        return `This action remove a #${id} issue`;
    }
}
