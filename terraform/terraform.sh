#!/bin/bash

WORKSPACE=$1
ACTION=${2:-plan} # Default action will be plan

# Validating the workspace
if [[ ! "$WORKSPACE" =~ ^(dev|prod)$ ]]; then
    echo "Invalid workspace. Must be dev or prod"
    exit 1
fi

# Check if the tfvars file exists
if [[ ! -f "environments/${WORKSPACE}.tfvars" ]]; then
    echo "Environment file environments/${WORKSPACE}.tfvars not found "
    exit 1
fi

# Select workspace

terraform workspace select $WORKSPACE || terraform workspace new $WORKSPACE

case $ACTION in
    plan)
        terraform plan -var-file="environments/${WORKSPACE}.tfvars"
        ;;
    apply)
        terraform apply -var-file="environments/${WORKSPACE}.tfvars" -auto-approve
        ;;
    destroy)
        terraform destroy -var-file="environments/${WORKSPACE}.tfvars" -auto-approve
        ;;
    *)
        echo "Invalid action. Must be either plan, apply or destroy"
        exit 1
        ;;
esac