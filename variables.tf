variable "rds_identifier" {
  default = "dentolo"
}

variable "rds_instance_type" {
  default = "db.t3.micro"
}
variable "rds_storage_size" {
  default = "5"
}

variable "rds_engine" {
  default = "postgres"
}

variable "rds_engine_version" {
  default = "13.7"
}

variable "rds_db_name" {
  default = "testing"
}

variable "rds_admin_user" {
  default = "dentolo"
}

variable "rds_admin_password" {
  default = "dentoloTask"
}

variable "rds_publicly_accessible" {
  default = "true"
}