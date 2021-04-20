# terraform-test
>> terraform init
>> terraform fmt
>> terraform validate
>> terraform plan
>> terraform apply

# Create a workspace
>> terraform workspace new [NAME]

# For multiple environments 'workspaces'
>> terraform workspace select dev
>> terraform apply -var-file=dev.tfvars
>> terraform destroy -var-file=dev.tfvars
