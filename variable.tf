#vpc variable#

variable "vpc_cidr" {}

#Subnet variables#
variable "redshift_subnet_cidr_first" {}
variable "redshift_subnet_cidr_second" {}

##Redshift Clusters##
variable "rs_cluster_identifier" {}
variable "rs_database_name" {}
variable "rs_master_username" {}
variable "rs_master_pass" {}
variable "rs_nodetype" {}
variable "rs_cluster_type" {}