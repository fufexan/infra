variable "compartment_id" {
  description = "OCID"
  type        = string
}
variable "region" {
  description = "region where we have OCI tenancy"
  type        = string
  default     = "eu-frankfurt-1"
}
