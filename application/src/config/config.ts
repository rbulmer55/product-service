const convict = require('convict');

export const config = convict({
  // shared config
  stage: {
    doc: 'The stage being deployed',
    format: String,
    default: '',
    env: 'STAGE',
  },
  dbConnectionSecret: {
    doc: 'The secret name for the database',
    format: String,
    default: 'dbConnectionSecret',
    env: 'MONGO_DB_SECRET',
  },
}).validate({ allowed: 'strict' });
