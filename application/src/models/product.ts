import { ObjectId } from 'mongodb';
export type Product = {
  id: ObjectId;
  name: string;
  updatedAt?: Date;
  createdAt: Date;
};
