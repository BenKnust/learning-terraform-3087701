output "instance_ami" {
  value = aws_instance.Blog.ami
}

output "instance_arn" {
  value = aws_instance.Blog.arn
}


#IP of aws instance retrieved
output "op1"{
value = aws_instance.jumphost.public_ip
}