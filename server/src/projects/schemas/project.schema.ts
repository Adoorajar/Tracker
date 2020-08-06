import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema()
export class Project extends Document {
    @Prop({ unique: true })
    name: string;

    @Prop({ unique: true, partialFilterExpression: { key: { $exists: true } } })
    key: string;

    @Prop()
    description: string;
}

export const ProjectSchema = SchemaFactory.createForClass(Project);