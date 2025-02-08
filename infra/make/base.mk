ENV := dev

ifeq ($(ENV),stg)
	AWS_PROFILE           := ""
	AWS_ACCESS_KEY_ID     := ""
	AWS_SECRET_ACCESS_KEY := ""
	AWS_REGION            := "ap-northeast-1"
	SOPS_KMS_ARN          := "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
else ifeq ($(ENV),prd)
	AWS_PROFILE           := ""
	AWS_ACCESS_KEY_ID     := ""
	AWS_SECRET_ACCESS_KEY := ""
	AWS_REGION            := "ap-northeast-1"
	SOPS_KMS_ARN          := "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
else
	AWS_PROFILE           := ""
	AWS_ACCESS_KEY_ID     := ""
	AWS_SECRET_ACCESS_KEY := ""
	AWS_REGION            := "ap-northeast-1"
	SOPS_KMS_ARN          := "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
endif

.PHONY: fmt init list show plan apply destroy import

fmt:
	terraform fmt

init:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform init -reconfigure

list:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform state list

# e.g. $ make show AWS_RESOURCE_TYPE=aws_route53_zone AWS_RESOURCE_NAME=web_front
show:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform state show $(AWS_RESOURCE_TYPE).$(AWS_RESOURCE_NAME)

plan:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform plan

apply:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform apply

destroy:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform destroy

# e.g. make import AWS_RESOURCE_TYPE=aws_route53_zone AWS_RESOURCE_NAME=web_front AWS_RESOURCE_IDENTIFIER=Z12345678901234567890
import:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform import $(AWS_RESOURCE_TYPE).$(AWS_RESOURCE_NAME) $(AWS_RESOURCE_IDENTIFIER)

.PHONY: encrypt-secret decrypt-secret

# e.g. make encrypt-secret ENV=dev CREDENTIAL_FILE_NAME=web_front
encrypt-secret:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) \
		sops --kms $(SOPS_KMS_ARN) tfvars/$(ENV)_$(CREDENTIAL_FILE_NAME).yaml

# e.g. make decrypt-secret ENV=dev CREDENTIAL_FILE_NAME=web_front
decrypt-secret:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) \
		sops --kms $(SOPS_KMS_ARN) -d tfvars/$(ENV)_$(CREDENTIAL_FILE_NAME).yaml
