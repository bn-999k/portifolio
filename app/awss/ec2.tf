terraform {
  required_version = ">=1.0.0" # Versão do Terraform

  # Provedores Utilizados
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0" # Versão do AWS no Terraform
    }
  }
}

provider "aws" {
  region           = "us-east-1"
  access_key       = var.AWS_ACCESS_KEY_ID
  secret_key       = var.AWS_SECRET_ACCESS_KEY
  token            = var.AWS_SESSION_TOKEN
}

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
}

variable "AWS_SESSION_TOKEN" {
  description = "The AWS session token"
}

resource "aws_security_group" "grupoapi" {
  name        = "grupoapi"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "linux" {
  ami                         = "ami-058bd2d568351da34" # Debian
  instance_type               = "t2.micro"
  key_name                    = "vockey" # Estamos ultilizando a chave padão da aws
  vpc_security_group_ids      = [aws_security_group.grupoapi.id]  # ID do grupo de segurança específico
  subnet_id                   = "subnet-0d823ddb2dcf69349" # Não se esqueca se subistituir para a sua subrede
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                # Atualizar os pacotes de instalação
                sudo apt update -y
                # Instalar o Docker
                sudo apt install docker.io -y
                # Iniciar o Docker
                sudo systemctl start docker
                # Adicionar o usuário ec2-user ao grupo docker para executar comandos docker sem sudo
                sudo usermod -aG docker ec2-user
                # Baixar a imagem do Docker Hub
                sudo docker pull euumarceloo/portifolio:latest 
                # Iniciar o contêiner
                sudo docker run -d -p 8080:8080 --name apicontainer euumarceloo/portifolio
                EOF

  tags = {
    Name = "EC2 CI/CD"
  }
}
