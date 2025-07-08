provider "aws" {
  region = var.region
}
module "vpc" {
source = "./modules/vpc"
name_prefix = var.name_prefix
vpc_cidr =   var.vpc_cidr
azs = var.azs
tags = var.tags
private_subnet_cidrs = var.private_subnet_cidrs
public_subnet_cidrs = var.public_subnet_cidrs
  
}

/* module "zookeeper" {
  source               = "./modules/zookeeper"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_ids          = module.vpc.private_subnet_ids
  key_name            = var.key_name
  sg_id               = var.sg_zookeeper
  zookeeper_count     = var.zookeeper_count
  keystore_password   = var.keystore_password
  truststore_password = var.truststore_password
  tags                = var.tags
} */

/* module "kafka_brokers" {
  source               = "./modules/kafka_brokers"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_ids          = module.vpc.private_subnet_ids
  key_name            = var.key_name
  sg_id               = var.sg_kafka
  broker_count        = var.broker_count
  zookeeper_connect   = module.zookeeper.zookeeper_connection_string
  keystore_password   = var.keystore_password
  truststore_password = var.truststore_password
  min_insync_replicas = var.min_insync_replicas
  name_prefix         = var.name_prefix
  tags                = var.tags
} */

/* module "schema_registry" {
  source               = "./modules/schema_registry"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.private_subnet_ids[0]
  key_name            = var.key_name
  sg_id               = var.sg_schema_registry
  bootstrap_servers   = module.kafka_brokers.bootstrap_servers
  keystore_password   = var.keystore_password
  truststore_password = var.truststore_password
  tags                = var.tags
} */

module "lambda_producer" {
  source            = "./modules/lambda_producer"
  function_name     = var.lambda_function_name
  environment       = var.environment
  sasl_secret_arn   = var.sasl_secret_arn
  tls_secret_arn    = var.tls_secret_arn
  sg_lambda = [module.vpc.lambda_sg_id]
  private_subnet_ids = module.vpc.private_subnet_ids
  depends_on = [ module.vpc ]
}

module "apigateway" {
  source           = "./modules/apigateway"
  environment      = var.environment
  audience         = var.auth0_audience
  issuer           = var.auth0_issuer
  tags = "${var.name_prefix}-${var.environment}-api-gateway"
  lambda_function_name_arn = module.lambda_producer.lambda_function_arn
  lambda_invoke_arn = module.lambda_producer.lambda_invoke_arn
  funtion_name = module.lambda_producer.lambda_function_name
  depends_on = [ module.lambda_producer ]
}
module "secretsmanager" {
  source = "./modules/secretsmanager"
  zk_instance_count = var.zookeeper_count
  name_prefix = var.name_prefix
  zookeer_secret_name_prefix = var.zookeer_secret_name_prefix
  environment = var.environment
  certs_path = var.certs_path_zoopkeeper
}

/*  module "monitoring" {
  source            = "./modules/monitoring"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_ids[0]
  key_name          = var.key_name
  sg_id             = var.sg_monitoring
  bootstrap_servers = module.kafka_brokers.bootstrap_servers
  tags              = var.tags
}

 */