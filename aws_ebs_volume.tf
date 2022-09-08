# # AWS EC2 instances are ephemeral, but your presistent database storage should not be.
# # For each node in the cluste configure both persistent and ephemeral storage.
# # TODO: create directories for both persistent and ephemeral storage in each node.


# Attach Ephemeral Volumes
# Instance 1
resource "aws_ebs_volume" "ephemeral_re_cluster_instance" {
  count             = var.data-node-count
  availability_zone = element(var.subnet_azs, count.index)
  size              = var.re-volume-size

  tags = {
    Name = format("%s-%s-ec2-%s-ephemeral", var.base_name, var.region, count.index+1),
    Owner = var.owner
  }
}

resource "aws_volume_attachment" "ephemeral_re_cluster_instance" {
  count       = var.data-node-count
  device_name = "/dev/sdh"
  volume_id   = element(aws_ebs_volume.ephemeral_re_cluster_instance.*.id, count.index)
  instance_id = element(aws_instance.nginx.*.id, count.index)
}

# Attach Persistent Volumes
# Instance 1
resource "aws_ebs_volume" "persistent_re_cluster_instance" {
  count             = var.data-node-count
  availability_zone = element(var.subnet_azs, count.index)
  size              = var.re-volume-size

  tags = {
    Name = format("%s-%s-ec2-%s-persistent", var.base_name, var.region, count.index+1),
    Owner = var.owner
  }
}

resource "aws_volume_attachment" "persistent_re_cluster_instance" {
  count       = var.data-node-count
  device_name = "/dev/sdj"
  volume_id   = element(aws_ebs_volume.persistent_re_cluster_instance.*.id, count.index)
  instance_id = element(aws_instance.nginx.*.id, count.index)
}