import { CreateProductDto } from '@dto/create-product';
import { ProductDto } from '@dto/product';
import { getISOString, logger, schemaValidator } from '@shared';
import { schema } from '@schemas/product';
import { v4 as uuid } from 'uuid';
import { createProductAdapter } from '@adapters/secondary/create-product/create-product.adapter';
import { Product } from '@models/product';

export async function createProductUseCase(
  product: CreateProductDto,
): Promise<ProductDto> {
  const createdDate = new Date();

  const productDto: CreateProductDto = {
    createdAt: createdDate,
    ...product,
  };

  schemaValidator(schema, productDto);

  // TODO - use a secondary adapter to persist the item in a store
  const created = await createProductAdapter(productDto as Product);

  logger.info(`product created`);

  return created;
}
