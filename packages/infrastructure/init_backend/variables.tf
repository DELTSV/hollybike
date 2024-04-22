variable "access_key_id" {
  description = "Scaleway access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Scaleway secret key"
  type        = string
  sensitive   = true
}

variable "project_id" {
  type        = string
  description = "Your project ID."
}