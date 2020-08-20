import { Issue } from '../../issues/schemas/issue.schema';

export class ProjectDto {
    name: string;
    description: string;
    issues: Issue[];
}