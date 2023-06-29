terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "network" {
  source     = "./network"
  tenancy_id = var.tenancy_id
}

# eta
resource "oci_core_instance" "eta" {
  compartment_id      = var.tenancy_id
  availability_domain = var.availability_domain
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "terraform-eta"
  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7wq4opozz63gwzrolqmalwadtckpke5ehhxh634myjquvwlzetyq"
  }
  create_vnic_details {
    assign_public_ip          = true
    display_name              = "eta_vnic"
    subnet_id                 = module.network.terraform_subnet.id
    assign_private_dns_record = false
  }
  lifecycle {
    ignore_changes = [
      source_details
    ]
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

# alpha
resource "oci_core_instance" "alpha" {
  compartment_id      = var.tenancy_id
  availability_domain = var.availability_domain
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }
  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaavv2mpdlhnbt6zehvubcorl4oqkrzthc5ustlfs7npfhkk7r6xyq"
  }
  display_name = "alpha"
  create_vnic_details {
    assign_public_ip          = true
    display_name              = "alpha_vnic"
    subnet_id                 = module.network.terraform_subnet.id
    assign_private_dns_record = false
  }
  lifecycle {
    ignore_changes = [
      source_details
    ]
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}
