import { Controller, Get } from '@nestjs/common';

@Controller('issues')
export class IssuesController {
    @Get()
    findAll(): string {
        return 'this issue returns all issues';
    }
}
