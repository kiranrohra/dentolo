resource "aws_key_pair" "key-tf" {
  key_name   = "key-tf"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "security-tf" {
  name        = "security-tf"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = [22, 80, 443, 3306, 5432]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db" {
  engine            = "${var.rds_engine}"
  engine_version    = "${var.rds_engine_version}"
  identifier        = "${var.rds_identifier}"
  instance_class    = "${var.rds_instance_type}"
  allocated_storage = "${var.rds_storage_size}"
  db_name              = "${var.rds_db_name}"
  username          = "${var.rds_admin_user}"
  password          = "${var.rds_admin_password}"
  publicly_accessible    = "${var.rds_publicly_accessible}"
  vpc_security_group_ids = ["${aws_security_group.security-tf.id}"]
  skip_final_snapshot = true
  apply_immediately                     = true
}

# resource "aws_instance" "web" {
#   ami             = "ami-0d1ddd83282187d18"
#   instance_type   = "t2.micro"
#   key_name        = aws_key_pair.key-tf.key_name
#   vpc_security_group_ids = ["${aws_security_group.security-tf.id}"]
#   tags = {
#     Name = "first-tf-instance"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y docker.io",
#       "sudo usermod -aG docker ubuntu",
#       "sudo systemctl enable docker",
#       "sudo systemctl start docker",
#       "sudo docker pull airbyte/airbyte:latest",
#       "sudo docker run -it -p 8000:8000 airbyte/airbyte:latest",
#     ]
#   }
# }
