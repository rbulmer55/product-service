export const schema = {
  $id: 'https://example.com/productAPI.json',
  type: 'object',
  required: ['name'],
  maxProperties: 10, // TODO - amend base schema
  minProperties: 0,
  properties: {
    name: {
      type: 'string',
    },
  },
};
