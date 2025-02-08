ENV := dev

ifeq ($(ENV),stg)
	AWS_PROFILE := ""
	AWS_ACCESS_KEY_ID := STG_ACCESS_KEY_ID
	AWS_SECRET_ACCESS_KEY := STG_SECRET_ACCESS_KEY
	AWS_REGION := ap-northeast-1
	SOPS_KMS_ARN = "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
else ifeq ($(ENV),prd)
	AWS_PROFILE := ""
	AWS_ACCESS_KEY_ID := PRD_ACCESS_KEY_ID
	AWS_SECRET_ACCESS_KEY := PRD_SECRET_ACCESS_KEY
	AWS_REGION := ap-northeast-1
	SOPS_KMS_ARN = "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
else
	AWS_PROFILE := ""
	AWS_ACCESS_KEY_ID := ""
	AWS_SECRET_ACCESS_KEY := ""
	AWS_REGION := ap-northeast-1
	SOPS_KMS_ARN = "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
endif

.PHONY: fmt init list show plan apply destroy

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

# e.g. make show AWS_RESOURCE=<resource_name>.<resource_type>
show:
	@export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) && \
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) && \
	export AWS_REGION=$(AWS_REGION) && \
	terraform state show $(AWS_RESOURCE)

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


.PHONY: encrypt-secret decrypt-secret

# e.g. make encrypt-secret ENV=dev CREDENTIAL_FILE_NAME=web_front
encrypt-secret:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) sops --kms $(SOPS_KMS_ARN) tfvars/$(ENV)_$(CREDENTIAL_FILE_NAME).yaml

# e.g. make decrypt-secret ENV=dev CREDENTIAL_FILE_NAME=web_front
decrypt-secret:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) sops --kms $(SOPS_KMS_ARN) -d tfvars/$(ENV)_$(CREDENTIAL_FILE_NAME).yaml
