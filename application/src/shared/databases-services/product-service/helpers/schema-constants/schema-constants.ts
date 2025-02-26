import { v4 as uuid } from 'uuid';
import { regexes } from '../../../../regex-validation';
import { Types, Schema } from 'mongoose';

export function idVirtual(this: any) {
  return this._id;
}

export const _id = {
  required: false,
  type: Schema.Types.ObjectId,
};

export const identifier = {
  required: true,
  type: String,
  validate: new RegExp(regexes.shared.uuid),
  public: true,
};
