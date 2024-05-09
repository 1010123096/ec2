terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" #parametros  y configuracion basica de terraform
      
    }
  }
}

provider "aws" {
  region    = "us-east-2" # Cambia esto a tu región preferida
  access_key = var.access_key  # llave de acceso
  secret_key = var.secret_key # llave secreta
}
locals{
  extra_tag="extra-tag"

}
resource "aws_instance" "ec2_iac" { #es lo que me crea las instancias
  for_each      = var.service_name # traer los nombres de la instancia

  ami           = "ami-0ddda618e961f2270" # AMI de la región y tipo de instancia
  instance_type = "t2.micro"              # Tipo de instancia
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.terraform-sg.security_group_id] 
  associate_public_ip_address = true 

     tags = { # asigna un nombre complemento, solo para las instancias 
    ExtraTag = local.extra_tag
    Name     = "EC2-${each.key}"
  }

  
}
resource "aws_cloudwatch_log_group" "ec2_log_group" { 
  for_each = var.service_name


  tags = {
    Environment = "test"
    Service     = each.key
  }
  lifecycle {
    create_before_destroy = true
  }
}