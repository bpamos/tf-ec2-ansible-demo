locals {
    ssh_user         = "ubuntu"
    private_key_path = "~/desktop/keys/bamos-west2-ssh-aws.pem"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# AWS region and AWS key pair
provider "aws" {
  region = var.region
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}

resource "aws_security_group" "nginx" {
    name = "nginx_access"
    vpc_id = aws_vpc.redis_cluster_vpc.id

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "nginx" {
    ami = data.aws_ami.re-ami.id
    subnet_id = aws_subnet.re_subnet1.id
    instance_type = var.re_instance_type
    associate_public_ip_address = true
    security_groups = [aws_security_group.nginx.id]
    key_name = var.ssh_key_name

  tags = {
    Name = format("%s-%s-node", var.base_name, var.region),
    Owner = var.owner
  }
}


############################
# instead of running this inside aws_instance, run it outside with null resource
# ensure we can get to the node first
resource "null_resource" "remote-config" {
  ##count = var.data-node-count
  provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

        connection {
            type = "ssh"
            user = local.ssh_user
            private_key = file(local.private_key_path)
            host = aws_instance.nginx.public_ip 
        }
    }
  depends_on = [aws_instance.nginx]
  ##depends_on = [aws_instance.re, aws_eip_association.re-eip-assoc, null_resource.inventory-setup, null_resource.ssh-setup]
}


######################
# Run some ansible
resource "null_resource" "ansible-run" {
  ###count = var.data-node-count
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
    }
  depends_on = [null_resource.remote-config]
}



output "nginx_ip" {
    value = aws_instance.nginx.public_ip
}
