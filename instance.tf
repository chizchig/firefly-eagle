resource "aws_instance" "server1" {
  for_each = var.vpcs

  ami           = var.ami_id 
  instance_type = "t2.micro"               
  subnet_id     = aws_subnet.external_subnet[each.key].id
  iam_instance_profile = aws_iam_instance_profile.instance_profile[each.key]  
  user_data = file("${firefly}/deployment.sh")

  tags = {
    Name = "EC2-Instance-${each.key}"
  }
}
