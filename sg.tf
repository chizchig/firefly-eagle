resource "aws_security_group" "sg" {
  for_each = var.vpcs

  name_prefix = "My-Security-Group-${each.key}"

  vpc_id = aws_vpc.network[each.key].id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security-Group-${each.key}"
  }
}

# Create Security Group for RDS instances in VPC1
resource "aws_security_group" "rds_sg_vpc1" {
  for_each = var.vpcs

  name_prefix = "rds-sg-vpc1-${each.key}"
  description = "Security Group for RDS instances in VPC1"

  vpc_id = aws_vpc.network[each.key].id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.network[each.key].cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for RDS instances in VPC2 (replicating VPC1)
resource "aws_security_group" "rds_sg_vpc2" {
  for_each = var.vpcs

  name_prefix = "rds-sg-vpc2-${each.key}"
  description = "Security Group for RDS instances in VPC2"

  vpc_id = aws_vpc.network[each.key].id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.network[each.key].cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
