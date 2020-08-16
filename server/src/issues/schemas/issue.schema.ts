import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema()
export class Issue extends Document {
    @Prop() 
    project: string;

    @Prop()
    summary: string;

    @Prop()
    description: string;

    @Prop()
    status: string;
}

export const IssueSchema = SchemaFactory.createForClass(Issue);