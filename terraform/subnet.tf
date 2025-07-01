resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.lambda_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = false

    tags = {
        name = "${var.funtion_name}-private-subnet"
    }
}