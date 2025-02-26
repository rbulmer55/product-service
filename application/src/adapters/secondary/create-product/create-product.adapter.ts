import { CreateProductDto } from '@dto/create-product';
import { Product } from '@models/product';
import { connect } from '@shared/databases-services/product-service/connection';
import { productService } from '@shared/databases-services/product-service/product/services';

export const createProductAdapter = async (product: Product) => {
  console.log('Secondary Adapter: Connecting to database');
  await connect();

  console.log('Secondary Adapter: Creating Product');
  const createdProduct = await productService.createProduct(
    product.name,
    product.createdAt,
  );
  console.log('Product created', product);
  return createdProduct as Product;
};
