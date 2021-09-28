init:
	tfenv init
	tfenv install 1.0.6
	tfenv use 1.0.6
	# Elimino llaves
	rm -rf id_rsa*
	# Genero nuevas llaves
	./scripts/generate_pem.sh
	# LLave generada
	cat id_rsa.pub
	terraform init

show:
	terraform plan

apply:
	# Aplico TF
	terraform apply #--auto-approve

destroy:
	terraform destroy
