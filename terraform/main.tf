terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

module "network" {
  source         = "./network"
  compartment_id = var.compartment_id
}

# eta
resource "oci_core_instance" "eta" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E1.Micro"
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
}

# alpha
# resource "oci_core_instance" "alpha" {
#   availability_domain = "vOMn:EU-MARSEILLE-1-AD-1"
#   compartment_id      = var.compartment_id
#   shape               = "VM.Standard.A1.Flex"
#   shape_config {
#     memory_in_gbs = 24
#     ocpus         = 4
#   }
#   display_name = "alpha"
#   source_details {
#     source_type = "image"
#     source_id   = module.images.alpha_id
#   }
#   create_vnic_details {
#     assign_public_ip          = true
#     display_name              = "alpha_vnic"
#     subnet_id                 = module.network.terraform_subnet.id
#     assign_private_dns_record = false
#   }
#   lifecycle {
#     ignore_changes = [
#       source_details
#     ]
#   }
# }
