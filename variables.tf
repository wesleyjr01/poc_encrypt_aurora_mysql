variable "region" {
  default = "us-east-1"
}

variable "backup_retention_period" {
  type = string
  description = "Aurora MySQL backup_retention_period."
}

variable "preferred_backup_window" {
  type = string
  description = "Aurora MySQL preferred_backup_window"
}

variable "cluster_identifier" {
  type = string
  description = "Aurora MySQL cluster_identifier"
}

variable "engine_version" {
  type = string
  description = "Aurora MySQL engine_version"
}