variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "aws_creds" {
    description = "Access key and Secret key for AWS [Access Keys, Secret Key]"
}

variable "ssh_key_name" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

variable "owner" {
    description = "owner tag name"
}

# VPC
variable "vpc_cidr" {
    description = "vpc-cidr"
}

variable "base_name" {
    description = "base name for resources"
    default = "redisuser1-tf"
}

variable "subnet_cidr_blocks" {
    type = list(any)
    description = "subnet_cidr_block"
    default = ["10.0.0.0/24"]
}

variable "subnet_azs" {
    type = list(any)
    description = "subnet availability zone"
    default = ["us-east-1a"]
}

variable "instance_type" {
    description = "instance type to use. Default: t3.micro"
    default = "t3.micro"
}

# Redis Enterprise Cluster Variables
# redis enterpise software instance ami
# you need to search aws marketplace, select the region, and grab ami id.
# https://aws.amazon.com/marketplace/server/configuration?productId=412acaa0-2074-4156-93a4-576366bbf396&ref_=psb_cfg_continue

variable "data-node-count" {
  description = "number of data nodes"
  default     = 3
}

variable "ena-support" {
  description = "choose AMIs that have ENA support enabled"
  default     = true
}

variable "re_instance_type" {
    description = "re instance type"
    default     = "t2.xlarge"
}

variable "node-root-size" {
  description = "The size of the root volume"
  default     = "50"
}

# EBS volume for persistent and ephemeral storage

### must import "local variable to use this"
variable "enable-volumes" {
  description = "Enable EBS Devices for Ephemeral and Persistent storage"
  default     = true
}

variable "re-volume-size" {
  description = "The size of the ephemeral and persistent volumes to attach"
  default     = "150"
}