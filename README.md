# Product Service

This test application uses MongoDB Atlas and AWS Lambda to create a product into the database.

Connection is whitelisted using the ENI EIP attached to Lambda and NAT Gateway.

## ESBUILD

The lambda funcitons are bundled with esbuild. Application/entry-points define the location of each top level function.

## Terraform

The terrform script takes the output dist files from ESBUILD, zips them up and deploys into AWS.

### Todo

- Tidy up terraform setup and variables
- Reduce Lambda IAM permissions
- Reconfig with private connectivity to Atlas using Private Endpoints or Peering.
- Remove Mongoose and use native MongoDB driver
- Add API gateway proxy (tested through proxy lambda GUI)
