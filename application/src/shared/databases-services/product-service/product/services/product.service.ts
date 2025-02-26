import { Product as Model, ProductModel } from '../model';
import { putEntity, getEntity } from '../../base-services';
import { Types } from 'mongoose';

async function createProduct(
  name: string,
  createdAt: Date,
): Promise<ProductModel> {
  try {
    const id = new Types.ObjectId();

    //upsert allows for put
    console.log('Product Service: Create Product', id);
    return await putEntity(Model, { $set: { name, createdAt } }, id, {
      upsert: true,
    });
  } catch (error) {
    console.log(error);
    throw error;
  }
}

async function getLatestProduct(): Promise<ProductModel> {
  try {
    // sort -1 gets latest record
    return await getEntity(Model, {}, {}, { sort: { updatedAt: -1 } });
  } catch (error) {
    console.log(error);
    throw error;
  }
}

export const productService = {
  createProduct,
  getLatestProduct,
};
