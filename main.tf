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

  tags = {
    Name = "Blog"
  }
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
