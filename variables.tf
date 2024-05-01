variable "aws_region" {
  default = "ap-southeast-1"
}

variable "cluster_name" {
  type    = string
  default = "example-cluster"
}


variable "aws_key_name" {
  default = "rke"  # Change to your key pair name
}

variable "instance_type" {
  default = "t2.micro"  # Change to your desired instance type
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa.pub"  # Change to your SSH public key file path
}

variable "protocol" {
  default = "tcp"
}
