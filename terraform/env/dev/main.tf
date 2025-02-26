provider "aws" {
  region = "eu-west-2"
}

provider "mongodbatlas" {
  public_key  = var.MDB_ATLAS_PUBLIC_KEY
  private_key = var.MDB_ATLAS_PRIVATE_KEY
}
module "application_vpc_module" {
  source      = "../../modules/vpc"
  environment = "Dev"
  vpcName     = "KafkaAtlasVpc"
}

module "mongodb_atlas_module" {
  providers = {
    mongodbatlas = mongodbatlas
  }
  source                  = "../../modules/atlas"
  environment             = "Dev"
  mongodbatlas_project_id = var.MDB_ATLAS_PROJECT_ID
  application_ip_address  = module.application_vpc_module.vpc_eip_address
  depends_on              = [module.application_vpc_module]
}

module "application_secrets" {
  source      = "../../modules/secrets"
  environment = "Dev"
  project     = "kafka-atlas"
}

module "create_product_lambda_module" {
  source                 = "../../modules/functions/product/create-product"
  environment            = "Dev"
  vpcCidr                = module.application_vpc_module.vpcCidr
  vpcId                  = module.application_vpc_module.vpcId
  privateSubnetId        = module.application_vpc_module.vpc_prv_subnet_id
  dbConnectionSecretName = module.application_secrets.db_connection_secret
  dbConnectionSecretArn  = module.application_secrets.db_connection_secret_arn
  depends_on             = [module.application_vpc_module, module.mongodb_atlas_module, module.application_secrets]
}


