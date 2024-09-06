# Create a port on the subnet made in subnet.tf
resource "openstack_networking_port_v2" "login_port" {
    name           = "login-node-port-${var.team_name}"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.indyscc_subnet.id
    }

    depends_on = [ openstack_networking_subnet_v2.indyscc_subnet ]
}

# Create the login node
resource "openstack_compute_instance_v2" "login" {
    name = "${var.team_name}-login"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.small"
    key_pair = var.key_pair

    security_groups = ["terraform_ssh_ping", "default"]

    network {
        port = openstack_networking_port_v2.login_port.id
    }

    depends_on = [ openstack_compute_secgroup_v2.terraform_ssh_ping, openstack_networking_port_v2.login_port ]

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