


resource "aws_instance" "this" {
count = var.instance_count

ami              = var.ami
instance_type    = var.instance_type
subnet_id         = var.subnet_id
key_name               = var.key_name
monitoring             = var.monitoring
get_password_data      = var.get_password_data
vpc_security_group_ids = var.vpc_security_group_ids
iam_instance_profile   = var.iam_instance_profile

associate_public_ip_address = var.associate_public_ip_address
private_ip                  = var.private_ip
ipv6_address_count          = var.ipv6_address_count
ipv6_addresses              = var.ipv6_addresses

ebs_optimized = var.ebs_optimized

dynamic "root_block_device" {
for_each = var.root_block_device
content {
delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
encrypted             = lookup(root_block_device.value, "encrypted", null)
iops                  = lookup(root_block_device.value, "iops", null)
kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
volume_size           = lookup(root_block_device.value, "volume_size", null)
volume_type           = lookup(root_block_device.value, "volume_type", null)
}
}

dynamic "ebs_block_device" {
for_each = var.ebs_block_device
content {
delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
device_name           = ebs_block_device.value.device_name
encrypted             = lookup(ebs_block_device.value, "encrypted", null)
iops                  = lookup(ebs_block_device.value, "iops", null)
kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
volume_size           = lookup(ebs_block_device.value, "volume_size", null)
volume_type           = lookup(ebs_block_device.value, "volume_type", null)
}
}
provisioner "remote-exec" {
# Install Python for Ansible
inline = ["sudo dnf -y install python libselinux-python"]

connection {
type        = "ssh"
user        = "fedora"
private_key = "${file(var.ssh_key_private)}"
}
}

provisioner "local-exec" {
command = "ansible-playbook -u fedora -i '${self.public_ip},' --private-key ${var.ssh_key_private} -T 300 ngnix-centos.yml"
}
}


