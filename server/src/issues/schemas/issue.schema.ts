import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema()
export class Issue extends Document {
    @Prop()
    name: string;

    @Prop()
    summary: string;

    @Prop()
    description: string;
}

export const IssueSchema = SchemaFactory.createForClass(Issue);