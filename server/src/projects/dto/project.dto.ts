import { Issue } from '../../issues/schemas/issue.schema';

export class ProjectDto {
    name: string;
    key: string;
    description: string;
    issues: Issue[];
}