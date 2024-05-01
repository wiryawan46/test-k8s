provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "k8s_cluster" {
  name        = "rke-group"
  description = "Allow SSH, RKE, and Kubernetes traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10255
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3100
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9100
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource"aws_instance" "rke_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  vpc_security_group_ids = [aws_security_group.k8s_cluster.id]

  tags = {
    Name = "rke-master"
  }
}

resource "aws_instance" "rke_workers" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  vpc_security_group_ids = [aws_security_group.k8s_cluster.id]

  tags = {
    Name = "rke-worker-${count.index}"
  }
}

output "master_ip" {
  value = aws_instance.rke_master.public_ip
}

output "worker_ips" {
  value = aws_instance.rke_workers.*.public_ip
}