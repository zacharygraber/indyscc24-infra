# Create a port on the subnet made in subnet.tf
resource "openstack_networking_port_v2" "login_port" {
    name           = var.team_name
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"
    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.terraform_ssh_ping.id,
        openstack_compute_secgroup_v2.internal_incoming_group.id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.hpl_subnet.id
    }
}

resource "openstack_compute_instance_v2" "login_node" {
    name = "${var.team_name}-login"
    image_name = "snapshot-${var.team_name}-login"
    flavor_name = "m3.small"
    key_pair = "zegraber-test-api-key"

    network {
        port = openstack_networking_port_v2.login_port.id
    }

    depends_on = [ openstack_compute_secgroup_v2.terraform_ssh_ping, openstack_networking_port_v2.login_port ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a floating (public) IP address for each login node
resource "openstack_networking_floatingip_v2" "terraform_login_floatingip" {
    pool = "public"
}

# Assign the floating IP to the login node
resource "openstack_compute_floatingip_associate_v2" "terraform_floatingips_assoc_login" {
    floating_ip = openstack_networking_floatingip_v2.terraform_login_floatingip.address
    instance_id = openstack_compute_instance_v2.login_node.id
}