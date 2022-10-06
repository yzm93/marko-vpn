variable "project_id" { 
  type = string
  description = "GCP project id"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}
