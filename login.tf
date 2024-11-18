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
    key_pair = "indyscc-admins"

    user_data = templatefile("cloud-init.yml.tftpl", {
        ceph_access_key = openstack_sharedfilesystem_share_access_v2.share_access.access_key,
        team_name = var.team_name,
        submission_server_passphrase = var.app_cred_secret,
        share_export_location = openstack_sharedfilesystem_share_v2.scratch_share.export_locations[0].path
    })

    network {
        port = openstack_networking_port_v2.login_port.id
    }

    depends_on = [ openstack_compute_secgroup_v2.terraform_ssh_ping, openstack_networking_port_v2.login_port, openstack_sharedfilesystem_share_v2.scratch_share ]

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