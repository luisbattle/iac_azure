init:
	tfenv install 1.0.6
	tfenv use 1.0.6
	terraform init

plan:
	terraform plan

apply:
	terraform apply --auto-approve

destroy:
	terraform destroy
