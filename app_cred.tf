resource "openstack_identity_application_credential_v3" "team_scoped_credentials" {
    name = "indyscc-team-${var.team_name}"
    expires_at = "2024-11-22T00:00:00Z"
    unrestricted = false

    secret = var.app_cred_secret

    access_rules {
        path    = "/v2.1/servers"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/detail"
        service = "compute"
        method  = "GET"
    }

    # access rules for login node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.name}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.name}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.name}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.name}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_node.name}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu node by id

    dynamic "access_rules" {
        for_each = range(var.cpu_node_count)
        content {
            path = "/v2.1/servers/${openstack_compute_instance_v2.cpu_nodes[access_rules.value].id}"
            service = "compute"
            method  = "GET"
        }
    }
    dynamic "access_rules" {
        for_each = range(var.cpu_node_count)
        content {
            path = "/v2.1/servers/${openstack_compute_instance_v2.cpu_nodes[access_rules.value].id}/action"
            service = "compute"
            method  = "POST"
        }
    }
    dynamic "access_rules" {
        for_each = range(var.cpu_node_count)
        content {
            path = "/v2.1/servers/${openstack_compute_instance_v2.cpu_nodes[access_rules.value].id}/remote-consoles"
            service = "compute"
            method  = "POST"
        }
    }

    # access rules for cpu node by name

    dynamic "access_rules" {
        for_each = range(var.cpu_node_count)
        content {
            path = "/v2.1/servers/${openstack_compute_instance_v2.cpu_nodes[access_rules.value].name}"
            service = "compute"
            method  = "GET"
        }
    }
    dynamic "access_rules" {
        for_each = range(var.cpu_node_count)
        content {
            path = "/v2.1/servers/${openstack_compute_instance_v2.cpu_nodes[access_rules.value].name}/action"
            service = "compute"
            method  = "POST"
        }
    }
    dynamic "access_rules" {
        for_each = range(var.cpu_node_count)
        content {
            path = "/v2.1/servers/${openstack_compute_instance_v2.cpu_nodes[access_rules.value].name}/remote-consoles"
            service = "compute"
            method  = "POST"
        }
    }

    # access rules for GPU node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu_node.id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu_node.id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu_node.id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu_node.name}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu_node.name}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu_node.name}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

}