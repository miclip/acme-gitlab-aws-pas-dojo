#!/bin/bash -exu

main(){
  local path=${1?"Path is required (e.g. terraforming-pas, terraforming-pks, terraforming-control-plane)"}
  local url

   cat << EOF > /tmp/key
${opsman_ssh_private_key}
EOF
    chmod 600 /tmp/key

  ssh -t -i /tmp/key "ubuntu@${opsman_url}"  << EOF
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
         mysql -h ${rds_instance_endpoint} -u admin -p${rds_instance_password}  -e "CREATE DATABASE \$i;"
     done;
EOF
}

main "$@"