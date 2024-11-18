# Create a port on the subnet made in subnet.tf for each of the 20 instances
resource "openstack_networking_port_v2" "cpu_ports" {
    count = var.cpu_node_count

    name           = "${var.team_name}-cpu${count.index}"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_group.id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.hpl_subnet.id
    }
}

resource "openstack_compute_instance_v2" "cpu_nodes" {
    count = var.cpu_node_count

    name = "${var.team_name}-cpu${count.index}"
    image_name = "snapshot-${var.team_name}-cpu"
    flavor_name = "m3.xl"
    key_pair = "indyscc-admins"

    user_data = templatefile("cloud-init.yml.tftpl", {
        ceph_access_key = openstack_sharedfilesystem_share_access_v2.share_access.access_key,
        team_name = var.team_name,
        submission_server_passphrase = var.app_cred_secret,
        share_export_location = openstack_sharedfilesystem_share_v2.scratch_share.export_locations[0].path
    })

    network {
        port = openstack_networking_port_v2.cpu_ports[count.index].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_group, openstack_networking_port_v2.cpu_ports, openstack_sharedfilesystem_share_v2.scratch_share]

    metadata = {
        terraform_controlled = "yes"
    }
}

resource "openstack_networking_port_v2" "gpu_port" {
    name           = "${var.team_name}-gpu0"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_group.id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.hpl_subnet.id
    }
}

resource "openstack_compute_instance_v2" "gpu_node" {
    name = "${var.team_name}-gpu0"
    image_name = "snapshot-${var.team_name}-cpu"
    flavor_name = "g3.xl"
    key_pair = "indyscc-admins"

    user_data = templatefile("cloud-init.yml.tftpl", {
        ceph_access_key = openstack_sharedfilesystem_share_access_v2.share_access.access_key,
        team_name = var.team_name,
        submission_server_passphrase = var.app_cred_secret,
        share_export_location = openstack_sharedfilesystem_share_v2.scratch_share.export_locations[0].path
    })

    network {
        port = openstack_networking_port_v2.gpu_port.id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_group, openstack_networking_port_v2.gpu_port, openstack_sharedfilesystem_share_v2.scratch_share]

    metadata = {
        terraform_controlled = "yes"
    }
}