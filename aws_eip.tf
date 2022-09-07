# # Resource: aws_eip (provides an elastic IP resource)
# # EIPs will be used as the IP addresses in your DNS 
# # and attached as the public IP address to each Redis Cluster EC2.

resource "aws_eip" "nginx_eip" {
  network_border_group = var.region
  vpc      = true

  tags = {
      Name = format("%s-%s-eip", var.base_name, var.region),
      Owner = var.owner
  }

}

# Elastic IP association

#associate aws eips created in "aws_eip.tf" to each instance
resource "aws_eip_association" "eip-assoc" {
  instance_id   = aws_instance.nginx.id
  allocation_id = aws_eip.nginx_eip.id
  depends_on    = [aws_instance.nginx, aws_eip.nginx_eip]
}
