import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';
import { Issue } from '../../issues/schemas/issue.schema';

@Schema()
export class Project extends Document {
    @Prop({ unique: true })
    name: string;

    @Prop({ unique: true, partialFilterExpression: { key: { $exists: true } } })
    key: string;

    @Prop()
    description: string;

    @Prop([{ type: MongooseSchema.Types.ObjectId, ref: Issue.name }])
    issues: Issue[];
}

export const ProjectSchema = SchemaFactory.createForClass(Project);