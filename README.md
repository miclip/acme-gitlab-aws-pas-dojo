#  PAS on AWS managed by GitLab Pipelines

GitLab pipeline that terraforms and deploys PAS to AWS using scripts extracted from Platform Automation. Tested with a SaaS GitLab account but there's no reason it wouldn't work on prem. We didn't deploy GitLab runners into the AWS environment but that would be the ideal approach. 

Note: 
1. SaaS GitLab has a 1GB limit on internal `Artifact` storage so the pipeline utilities S3 to store Pivnet downloads. If you have the ability to control this using the `Artifact` `Dependency` mechanisms might simplify the pipeline. 
2. We downloaded the Platform Automation docker image and pushed it to the internal Registry on `GitLab.com`. 
3. The scripts from Platform Automation are pretty much plug-n-play with a couple of caveats. Concourse creates VARS and Directories based on the Task definition. GitLab won't do this so you'll have to either remove some of them or default unused vars in the `variables` declaration. In this example I tried not to modify the scripts as much as possible. It will simplify the pipeline to have `vars`, `config`, `env` & `state` directories at the root of the repo. The Platform Automation scripts assume they're created by Concourse but within GitLab you'd have to move things around or change the scripts. It is possible to pull in Artifacts from external repos but we didn't take that route. 
4. As far as I could tell GitLab only supports one pipeline per repo, so moving configuration into a separate repo is probably a better real world approach. One central configuration repo that is pulled in using GitLabs Artifact mechanism by each pipeline. 

## Getting Started

### Create Infrastructure

1. Clone the repo `git clone [Added Repo URL]`
1. Sign up to GitLab, I paid for the bronze account but I suspect you could do this on their free subscription. 
1. Create a S3 bucket to store terraform state and pivnet downloads. 
1. Update `terraform.tfvars`
1. Add the following `secrets` to GitLab's `Environment Variables` (Settings\CI CD\ Enviroment variables) section by project:

        1. aws_access_key_id
        2. aws_secret_access_key
        3. pivnet_token
        4. opsman_user_password
        5. opsman_user_username
        6. ops_manager_decryption_passphrase
        7. ssl_cert - wildcard Cert to be installed on AWS LB 
        8. ssl_private_key
         
    In the pipeline update the global S3 vars: 

    ``` yml
    variables:
        S3_BUCKET_TERRAFORM: miclip-terraform
        S3_ENDPOINT: http://s3.amazonaws.com
        S3_REGION: us-east-2
    ```

    There terraform configuration has been modified to use S3 as a backend config: 

    ``` 
    terraform {
        required_version = "< 0.12.0"
        backend "s3" {}
        }
    ```

    which allows: 

    ``` yml
    script:
        - terraform init -backend-config="bucket=${S3_BUCKET_TERRAFORM}" -backend-config="key=${environment}/terraform.tfstate" -backend-config="region=${S3_REGION}" terraforming-pas
        - terraform plan -out=pcf.tfplan -var-file=${VARS_FILE} terraforming-pas
        - terraform apply pcf.tfplan
    ```
1. Commit and push repo, GitLab will detect the `gitlab-ci.yml` and kickoff the pipeline. The terraform state will be initialized on S3 and you should end up with the terraformed AWS environment. 

### GitLab Environment Variables

| key | Description |
|-----|-------------|
|


### Fetch Products

### Deploy PAS

### Deploy Healthwatch 
