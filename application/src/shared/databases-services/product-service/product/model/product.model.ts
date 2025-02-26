import { Schema, model, Document } from 'mongoose';
import { _id, idVirtual } from '../../helpers/schema-constants';

const options = {
  strict: true,
  timestamps: true,
  toJson: {
    virtuals: true,
  },
};

export interface ProductModel extends Document {
  _id: Schema.Types.ObjectId;
  name: string;
  createdAt: Date;
}

const name = 'Products';
const productProperties = {
  _id,
  name: {
    type: String,
    required: true,
    public: true,
  },
  createdAt: {
    type: Date,
    required: true,
    public: true,
  },
};

const schema = new Schema(productProperties, options);

schema.virtual('id').get(idVirtual);

export const Product = model<ProductModel>(name, schema);
