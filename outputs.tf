output "vpc_id" {
  value = "${alicloud_vpc.default.id}"
}

output "public_vswitchs_ids" {
  value = ["${alicloud_vswitch.public.*.id}"]
}

output "private_vswitchs_ids" {
  value = ["${alicloud_vswitch.private.*.id}"]
}

output "eip_address" {
  value = ["${alicloud_eip.default.*.ip_address}"]
}

output "db_connections" {
  value = "${alicloud_db_instance.default.connection_string}"
}

output "db_generated_password" {
  value     = "${random_password.db_password.result}"
  sensitive = true
}

output "wp_generated_password" {
  value     = "${random_password.wp_password.result}"
  sensitive = true
}