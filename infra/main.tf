provider "aws" {
  region = var.region
}
module "vpc" {
  source                   = "./modules/vpc"
  name_prefix              = var.name_prefix
  vpc_cidr                 = var.vpc_cidr
  azs                      = var.azs
  tags                     = var.tags
  private_subnet_cidrs     = var.private_subnet_cidrs
  public_subnet_cidrs      = var.public_subnet_cidrs
  allowed_ssh_cidr_bastion = var.allowed_ssh_cidr_bastion

}
module "bastion" {
  source           = "./modules/bastion"
  ami_id           = var.bastion_ami_id
  instance_type    = var.bastion_instance_type
  public_subnet_id = module.vpc.public_subnet_ids[0]
  key_name         = var.bastion_key_name
  sg_bastion_id    = module.vpc.bastion_sg_id
  name_prefix      = var.name_prefix
  depends_on       = [module.vpc]

}

module "zookeeper" {
  source          = "./modules/zookeeper"
  zookeeper_count = var.zookeeper_count
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_ids      = module.vpc.private_subnet_ids
  key_name        = var.key_name
  sg_id           = module.vpc.zookeeper_sg_id
  tags            = var.tags
  environment     = var.environment
  depends_on      = [module.vpc]
}

module "kafka_brokers" {
  source        = "./modules/kafka_brokers"
  broker_count  = var.broker_count
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_ids    = module.vpc.private_subnet_ids
  key_name      = var.key_name
  sg_id         = module.vpc.kafka_sg_id
  tags          = var.tags
  name_prefix   = var.name_prefix
  zookeeper_connection_string = module.zookeeper.zookeeper_connection_string
  environment                 = var.environment
  depends_on                  = [module.vpc]

}

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
}
 */
/* module "lambda_producer" {
  source             = "./modules/lambda_producer"
  function_name      = var.lambda_function_name
  environment        = var.environment
  sasl_secret_arn    = var.sasl_secret_arn
  tls_secret_arn     = var.tls_secret_arn
  sg_lambda          = [module.vpc.lambda_sg_id]
  private_subnet_ids = module.vpc.private_subnet_ids
  depends_on         = [module.vpc]
}

module "apigateway" {
  source                   = "./modules/apigateway"
  environment              = var.environment
  audience                 = var.auth0_audience
  issuer                   = var.auth0_issuer
  tags                     = "${var.name_prefix}-${var.environment}-api-gateway"
  lambda_function_name_arn = module.lambda_producer.lambda_function_arn
  lambda_invoke_arn        = module.lambda_producer.lambda_invoke_arn
  funtion_name             = module.lambda_producer.lambda_function_name
  depends_on               = [module.lambda_producer]
} */
/* module "secretsmanager" {
  source                     = "./modules/secretsmanager"
  zk_instance_count          = var.zookeeper_count
  broker_instance_count      = var.broker_count
  name_prefix                = var.name_prefix
  environment                = var.environment
  certs_path_zookeeper       = var.certs_path_zoopkeeper
  certs_path_broker          = var.certs_path_broker
} */
module "route53" {
  source                 = "./modules/route53"
  name_perfix            = var.name_prefix
  zookeeper_private_ips = module.zookeeper.zookeeper_private_ips
  zookeeper_count        = var.zookeeper_count
  kafka_private_ips      = module.kafka_brokers.broker_private_ips
  kafka_count            = var.broker_count
  vpc_id                 = module.vpc.vpc_id
  environment            = var.environment
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
