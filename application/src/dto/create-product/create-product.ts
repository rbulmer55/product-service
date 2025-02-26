import { ObjectId } from 'mongodb';
export type CreateProductDto = {
  id?: ObjectId;
  name: string;
  createdAt?: Date;
};
