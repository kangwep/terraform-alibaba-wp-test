data "alicloud_zones" "default" {
  available_instance_type = "${var.ecs_type}"
  available_disk_category = "cloud_ssd"
}

resource "alicloud_eip" "default" {
  bandwidth            = "200"
  internet_charge_type = "PayByBandwidth"
  count     = "${var.vm_count}"
}

resource "alicloud_eip_association" "default" {
  allocation_id = "${element(alicloud_eip.default.*.id, count.index)}"
  instance_id   = "${element(alicloud_instance.web.*.id, count.index)}"
  count         = "${var.vm_count}"
}

resource "alicloud_instance" "web" {
  instance_name              = "${var.name}_web_srv_${count.index}"
  instance_type              = "${var.ecs_type}"
  system_disk_category       = "cloud_ssd"
  system_disk_size           = 30
  image_id                   = "${var.ecs_image_name}"
  count                      = "${var.vm_count}"

  vswitch_id                 = "${element(alicloud_vswitch.public.*.id, count.index)}"
  internet_max_bandwidth_out = 0 // Not allocate public IP for VPC instance

  security_groups            = ["${alicloud_security_group.http.id}", "${alicloud_security_group.https.id}", "${alicloud_security_group.ssh.id}"]
  password                   = "${var.ssh_password}"

  user_data = templatefile("${path.module}/tpl/setup.sh", {
    WORDPRESS_DB_HOSTNAME     = "${alicloud_db_instance.default.connection_string}"
    WORDPRESS_DB_NAME        = "${var.wp_db_name}"
    WORDPRESS_DB_USER        = "${var.wp_db_user}"
    WORDPRESS_DB_PASSWORD    = "${random_password.db_password.result}"
    WORDPRESS_ADMIN_USER     = "${var.wp_admin_user}"
    WORDPRESS_ADMIN_PASSWORD = "${random_password.wp_password.result}"
    WORDPRESS_ADMIN_EMAIL    = "${var.wp_admin_email}"
    WORDPRESS_URL            = "${var.wp_url}"
    WORDPRESS_SITE_TITLE     = "${var.wp_site_title}"
    LETS_ENCRYPT_STAGING     = ""
  })

  depends_on                 = [alicloud_db_instance.default, alicloud_db_account.account]
}

resource "alicloud_db_instance" "default" {
    instance_name         = "${var.name}-db-srv"
    engine                = "MySQL"
    engine_version        = "8.0"
    instance_type         = "${var.rds_type}"
    instance_storage      = "20"

    vswitch_id            = "${element(alicloud_vswitch.private.*.id, 0)}"
    security_ips          = ["${var.cidr}"]
}

resource "alicloud_db_account" "account" {
  db_instance_id   = "${alicloud_db_instance.default.id}"
  account_name     = "${var.wp_db_user}"
  account_password = random_password.db_password.result
}

resource "alicloud_db_database" "default" {
  instance_id = "${alicloud_db_instance.default.id}"
  name        = "${var.wp_db_name}"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = "${alicloud_db_instance.default.id}"
  account_name = "${var.wp_db_user}"
  privilege    = "ReadWrite"
  db_names     = ["${var.wp_db_name}"]
}
