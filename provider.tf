terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  alias           = "dev"
  features        {}
}

provider "azurerm" {
  features        {}
  alias           = "prod"
}

provider "aws" {
  #alias = "us-east-1"
  region = local.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  alias = "us-west-1"
  region     = "us-west-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}