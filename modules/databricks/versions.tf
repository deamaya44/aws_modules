terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">= 1.0.0"
      configuration_aliases = [databricks.mws]
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}