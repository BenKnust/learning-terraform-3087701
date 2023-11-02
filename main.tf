data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

/*data "aws_db_snapshot" "db_snapshot" {
    #most_recent = true
    db_snapshot_identifier = snappi
    db_instance_identifier = "example"
}
*/

resource "aws_instance" "Blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.blog.id]

  tags = {
    Name = "Blog"
  }
}

resource "aws_s3_bucket" "blog" {
  bucket = "blog-bucket-dev"
  acl    = "private"
}

data "aws_vpc" "default" {
  default = true
}


resource "aws_db_instance" "example" {
  engine                 = "mysql"
  db_name                = "example"
  identifier             = "example"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  publicly_accessible    = false
  username               = var.db-username
  password               = var.db-password
  #snapshot_identifier    = "${data.aws_db_snapshot.db_snapshot.id}"
  snapshot_identifier    = "arn:aws:rds:us-west-2:494106478319:snapshot:snappi"
  #vpc_security_group_ids = [aws_security_group.example.id]
  skip_final_snapshot    = true

  tags = {
    Name = "example-db"
  }
}


resource "aws_security_group" "blog" {
  name        = "blog"
  description = " Allow http and https in. Allow everything out"
  tags        = {
    Terraform = "true"
  }
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}


resource "aws_security_group_rule" "blog_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}


resource "aws_security_group_rule" "blog_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}

