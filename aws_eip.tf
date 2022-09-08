# # Resource: aws_eip (provides an elastic IP resource)
# # EIPs will be used as the IP addresses in your DNS 
# # and attached as the public IP address to each Redis Cluster EC2.

resource "aws_eip" "nginx_eip" {
  count = var.data-node-count
  network_border_group = var.region
  vpc      = true

  tags = {
      Name = format("%s-%s-eip-%s", var.base_name, var.region, count.index+1),
      Owner = var.owner
  }

}

# Elastic IP association

#associate aws eips created in "aws_eip.tf" to each instance
resource "aws_eip_association" "eip-assoc" {
  count         = var.data-node-count
  instance_id   = element(aws_instance.nginx.*.id, count.index)
  allocation_id = element(aws_eip.nginx_eip.*.id, count.index)

  depends_on    = [aws_instance.nginx, aws_eip.nginx_eip]
}
