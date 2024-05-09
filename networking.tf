
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-2a", "us-east-2b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_vpn_gateway   = true
  enable_dns_hostnames = true 
  enable_dns_support   = true 

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "terraform-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "https rule"
  description         = "Sg estefani"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["https-443-tcp"]
}