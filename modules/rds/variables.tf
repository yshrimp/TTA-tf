variable "db_subnet_ids" {
  description = "Subnet IDs for DB Subnet Group"
  type = list(string)
}

variable "db_sg_id" {
  description = "DB sg id"
  type = list(string)
}

variable "db_identifier" {
  description = "DB Identifier"
  type = string
  default = "database-1"  
}

variable "db_name" {
  description = "DB name"
  type = string
  default = "school"
}

variable "db_username" {
  description = "DB username"
  type = string
  default = "admin"
}

variable "db_storage_type" {    
  description = "DB storage type"
  type = string
  default = "gp3"
}

variable "db_engine" {
  description = "DB engine type"
  type = string
  default = "mysql"
}

variable "db_engine_version" {
  description = "DB engine version"
  type = string
  default = "8.0.43"
}

variable "db_instance_class" {
  description = "DB instance type"
  type = string
  default = "db.t3.micro"
}




