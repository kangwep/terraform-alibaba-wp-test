variable "name" {
  description = "Solution Name"
  default = "agence_domotique"
}

variable "az_count" {
  description = "Number of availability zones to use"
  default = 1
}

variable "ecs_type" {
  description = "Sizing of VM ECS"
  default = "ecs.t6-c1m2.large"
}

variable "ecs_image_name" {
  description = "Name of base image OS"
  default = "ubuntu_20_04_x64_20G_alibase_20210824.vhd"
}

variable "vm_count" {
  description = "Number of VMs to use"
  default = 1
}

variable "cidr" {
  description = "CIDR range to use for the VPC"
  default = "192.168.0.0/16"
}

variable "rds_type" {
  description = "Sizing of DB instance"
  default = "mysql.n2.medium.2c"
}


variable "wp_db_name" {
  description = "Wordpress database name"
  default = "wp_agency"
}

variable "wp_db_user" {
  description = "Wordpress database user"
  default = "wp_agency"
}

variable "wp_admin_user" {
  description = "Wordpress admin user"
  default = "wp_agency"
}
variable "wp_admin_email" {
  description = "Wordpress admin email"
  default = "wp_agency@gmail.com"
}
variable "wp_url" {
  description = "Wordpress url"
  default = "http://wp_agency.com"
}
variable "wp_site_title" {
  description = "Wordpress site title"
  default = "WP Agency"
}
variable "ssh_password" {
  description = "12345"
}
