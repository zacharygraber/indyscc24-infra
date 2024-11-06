# Create a port on the subnet made in subnet.tf for each of the 20 instances
resource "openstack_networking_port_v2" "cpu_ports" {
    count = 20

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
    count = 20

    name = "${var.team_name}-cpu${count.index}"
    image_name = "snapshot-${var.team_name}-cpu"
    flavor_name = "m3.xl"
    key_pair = "zegraber-test-api-key"

    network {
        port = openstack_networking_port_v2.cpu_ports[count.index].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_group, openstack_networking_port_v2.cpu_ports]

    metadata = {
        terraform_controlled = "yes"
    }
}