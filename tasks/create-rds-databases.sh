#!/bin/bash -exu

main(){
  local path=${1?"Path is required (e.g. terraforming-pas, terraforming-pks, terraforming-control-plane)"}
  local url

  pushd ${path} > /dev/null
    terraform output ops_manager_ssh_private_key > /tmp/key
    rds_address=$(terraform output rds_address)
    rds_password=$(terraform output rds_password)
    chmod 600 /tmp/key
    url="$(terraform output ops_manager_dns)"
  popd

  ssh -t -i /tmp/key "ubuntu@${url}"  << EOF
     dbs="boshdb
account
app_usage_service
autoscale
ccdb
credhub
diego
locket
networkpolicyserver
nfsvolume
notifications
routing
silk
uaa"
     for i in \$dbs; do
         mysql -h ${rds_address} -u admin -p${rds_password}  -e "CREATE DATABASE \$i;"
     done;
EOF
}

main "$@"