variable "namespace" {
  description = "The namespace for the resources"
  type        = string
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use"
  type        = number
}

variable "region" {
  description = "The region to deploy the resources"
  type        = string
}