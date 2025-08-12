terraform {
  required_version = ">= 1.6"
  required_providers {
    ibm = { source = "IBM-Cloud/ibm", version = "~> 1.64" }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.ibm_region
}

module "base_vsi" {
  source       = "./modules/base_vsi"
  name         = var.name
  resource_group = var.resource_group
  zone         = var.zone
}
