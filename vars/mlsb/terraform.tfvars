env_name                        =       "mlsb"
dns_suffix                      =       "miclip.io"
region                          =       "us-east-2"
availability_zones              =       ["us-east-2a", "us-east-2c"]
vpc_cidr                        =       "10.0.0.0/16"
create_versioned_pas_buckets    =       true
create_backup_pas_buckets       =       true
ops_manager_vm                  =       true
ops_manager_ami                 =       "ami-01ef505e19fca5403"
rds_instance_count              =       1
tags                            =       {
    Team = "miclip"
}
