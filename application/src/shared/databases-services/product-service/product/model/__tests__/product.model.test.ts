import { Product } from '../product.model';

jest.unmock('mongoose');

let productModel: any;

describe('Product model', () => {
  beforeEach(() => {
    productModel = {
      _id: '851e52e0-9444-4436-8f3d-6ffe47580458',
      count: 3,
    };
  });

  test('should default the properties', () => {
    const product = new Product();
    expect(product).toMatchSnapshot();
  });

  test('should create when supplied properties', () => {
    const product = new Product(productModel);
    expect(product).toMatchSnapshot();
  });

  describe('validate', () => {
    test('should validate id', () => {
      productModel._id = 'invalid-not-a-uuid';
      const product = new Product(productModel);
      const error = product.validateSync();
      expect(error?.errors).toMatchSnapshot();
    });

    test('should create id', () => {
      delete productModel._id;
      const product = new Product(productModel);
      expect(product.id).not.toEqual(productModel._id);
      expect(product).toMatchSnapshot();
    });
  });
});
