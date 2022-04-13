resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
resource "random_password" "wp_password" {
  length           = 8
  special          = true
  override_special = "_%@"
}

resource "alicloud_vpc" "default" {
  vpc_name    = "${var.name}"
  cidr_block  = "${var.cidr}"
}

resource "alicloud_vswitch" "public" {
  vswitch_name      = "${var.name}_public_${count.index}"
  vpc_id            = "${alicloud_vpc.default.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, count.index)}"
  zone_id           = "${lookup(data.alicloud_zones.default.zones[count.index], "id")}"
  count             = "${var.az_count}"
}

resource "alicloud_vswitch" "private" {
  vswitch_name      = "${var.name}_private_${count.index}"
  vpc_id            = "${alicloud_vpc.default.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, count.index + 2)}"
  zone_id           = "${lookup(data.alicloud_zones.default.zones[count.index], "id")}"
  count             = "${var.az_count}"
}

resource "alicloud_security_group" "http" {
  name   = "${var.name}_http_sg"
  vpc_id = "${alicloud_vpc.default.id}"
}

resource "alicloud_security_group" "https" {
  name   = "${var.name}_https_sg"
  vpc_id = "${alicloud_vpc.default.id}"
}

resource "alicloud_security_group" "ssh" {
  name   = "${var.name}_ssh_sg"
  vpc_id = "${alicloud_vpc.default.id}"
}

resource "alicloud_security_group_rule" "allow_http_access" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = "${alicloud_security_group.http.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https_access" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = "${alicloud_security_group.https.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_ssh_access" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.ssh.id}"
  cidr_ip           = "0.0.0.0/0"
}
