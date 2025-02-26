export const schema = {
  $id: 'https://example.com/productDTO.json',
  type: 'object',
  required: ['name', 'createdAt'],
  maxProperties: 10, // TODO - amend base schema
  minProperties: 0,
  properties: {
    name: {
      type: 'string',
    },
    createdAt: {
      instanceof: 'Date',
    },
  },
};
