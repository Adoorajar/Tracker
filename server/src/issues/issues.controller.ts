import { Controller, Get, Post, Param, Body, Put, Delete, Query } from '@nestjs/common';
import { IssueDto } from './dto/issue.dto';

@Controller('issues')
export class IssuesController {
    @Post()
    async create(@Body() createIssueDto: IssueDto) {
        return 'This action creates a new issue';
    }

    @Get()
    findAll(@Query() query: IssueDto) {
        return 'This action returns all issues';
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
