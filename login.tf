resource "openstack_compute_instance_v2" "login" {
    name = "${var.team_name}-login"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.small"
    key_pair = var.key_pair

    security_groups = ["terraform_ssh_ping", "default"]

    network = {
        name = "auto_allocated_network"
    }

    depends_on = [ openstack_compute_secgroup_v2.terraform_ssh_ping ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a floating (public) IP address
resource "openstack_networking_floatingip_v2" "terraform_floatingip_login" {
    pool = "public"
}

# Assign the floating IP to the login node
resource "openstack_compute_floatingip_associate_v2" "terraform_floatingip_assoc_login" {
    floating_ip = "${openstack_networking_floatingip_v2.terraform_floatingip_login.address}"
    instance_id = "${openstack_compute_instance_v2.login.id}"
}

output "floating_ip_login" {
  value = openstack_networking_floatingip_v2.terraform_floatingip_login.address
  description = "Public IP for ${var.team_name} login node"
}