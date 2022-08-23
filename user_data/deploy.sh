#!/bin/bash

dir='.terraform'
if [ -d $dir ]; then
    terraform destroy --auto-approve
    rm -rfv .terraform
fi

file='.terraform.lock.hcl'
if [ -f $file ]; then
    rm -rfv .terraform.lock.hcl
fi

file='terraform.tfstate'
if [ -f $file ]; then
    rm -rfv terraform.tfstate
fi

file='terraform.tfstate.backup'
if [ -f $file ]; then
    rm -rfv terraform.tfstate.backup
fi

file='tfplan'
if [ -f $file ]; then
    rm -rfv tfplan
fi

terraform init
terraform fmt
terraform validate

terraform plan -out=tfplan
terraform apply --auto-approve tfplan
