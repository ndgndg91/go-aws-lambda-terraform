# Makefile
# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=main
PACKAGE_NAME=lambda.zip

S3_BUCKET=passbook-api
DELETE_ACCOUNT_LAMBDA_NAME=passbook-delete-account
DELETE_BANK_ACCOUNT_LAMBDA_NAME=passbook-delete-bank-account
GET_BANK_ACCOUNT_LAMBDA_NAME=passbook-get-bank-account
GET_MY_INFO_LAMBDA_NAME=passbook-get-my-info
POST_ACCOUNT_LAMBDA_NAME=passbook-post-account
POST_BANK_ACCOUNT_LAMBDA_NAME=passbook-post-bank-account

build:
	cd delete-account && $(GOBUILD) -o $(BINARY_NAME) -v && cd ..
	cd delete-bank-account && $(GOBUILD) -o $(BINARY_NAME) -v && cd ..
	cd get-bank-account && $(GOBUILD) -o $(BINARY_NAME) -v && cd ..
	cd get-my-info && $(GOBUILD) -o $(BINARY_NAME) -v && cd ..
	cd post-account && $(GOBUILD) -o $(BINARY_NAME) -v && cd ..
	cd post-bank-account && $(GOBUILD) -o $(BINARY_NAME) -v
clean:
	$(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip
	cd delete-account && $(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip && cd ..
	cd delete-bank-account && $(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip && cd ..
	cd get-bank-account && $(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip && cd ..
	cd get-my-info && $(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip && cd ..
	cd post-account && $(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip && cd ..
	cd post-bank-account && $(GOCLEAN) && rm -f $(BINARY_NAME) && rm -f lambda.zip
deps:
	$(GOGET) github.com/aws/aws-sdk-go
	$(GOGET) github.com/aws/aws-lambda-go
build-linux:
	cd delete-account && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v
	cd delete-bank-account && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v
	cd get-bank-account && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v
	cd get-my-info && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v
	cd post-account && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v
	cd post-bank-account && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v
package: build-linux
	cd delete-account && zip $(PACKAGE_NAME) $(BINARY_NAME)
	cd delete-bank-account && zip $(PACKAGE_NAME) $(BINARY_NAME)
	cd get-bank-account && zip $(PACKAGE_NAME) $(BINARY_NAME)
	cd get-my-info && zip $(PACKAGE_NAME) $(BINARY_NAME)
	cd post-account && zip $(PACKAGE_NAME) $(BINARY_NAME)
	cd post-bank-account && zip $(PACKAGE_NAME) $(BINARY_NAME)
ci: package
	cd delete-account && aws s3 cp $(PACKAGE_NAME) s3://${S3_BUCKET}/${DELETE_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} && cd ..
	cd delete-bank-account && aws s3 cp $(PACKAGE_NAME) s3://${S3_BUCKET}/${DELETE_BANK_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} && cd ..
	cd get-bank-account && aws s3 cp $(PACKAGE_NAME) s3://${S3_BUCKET}/${GET_BANK_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} && cd ..
	cd get-my-info && aws s3 cp $(PACKAGE_NAME) s3://${S3_BUCKET}/${GET_MY_INFO_LAMBDA_NAME}/${PACKAGE_NAME} && cd ..
	cd post-account && aws s3 cp $(PACKAGE_NAME) s3://${S3_BUCKET}/${POST_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} && cd ..
	cd post-bank-account && aws s3 cp $(PACKAGE_NAME) s3://${S3_BUCKET}/${POST_BANK_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME}
cd:
	cd delete-account && aws lambda update-function-code --region ap-northeast-2 --function-name ${DELETE_ACCOUNT_LAMBDA_NAME} \
    		--s3-bucket ${S3_BUCKET} --s3-key ${DELETE_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} --publish && cd ..
	cd delete-bank-account && aws lambda update-function-code --region ap-northeast-2 --function-name ${DELETE_BANK_ACCOUNT_LAMBDA_NAME} \
    		--s3-bucket ${S3_BUCKET} --s3-key ${DELETE_BANK_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} --publish && cd ..
	cd get-bank-account && aws lambda update-function-code --region ap-northeast-2 --function-name ${GET_BANK_ACCOUNT_LAMBDA_NAME} \
        	--s3-bucket ${S3_BUCKET} --s3-key ${GET_BANK_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} --publish && cd ..
	cd get-my-info && aws lambda update-function-code --region ap-northeast-2 --function-name ${GET_MY_INFO_LAMBDA_NAME} \
    		--s3-bucket ${S3_BUCKET} --s3-key ${GET_MY_INFO_LAMBDA_NAME}/${PACKAGE_NAME} --publish && cd ..
	cd post-account && aws lambda update-function-code --region ap-northeast-2 --function-name ${POST_ACCOUNT_LAMBDA_NAME} \
    		--s3-bucket ${S3_BUCKET} --s3-key ${POST_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} --publish && cd ..
	cd post-bank-account && aws lambda update-function-code --region ap-northeast-2 --function-name ${POST_BANK_ACCOUNT_LAMBDA_NAME} \
    		--s3-bucket ${S3_BUCKET} --s3-key ${POST_BANK_ACCOUNT_LAMBDA_NAME}/${PACKAGE_NAME} --publish && cd ..
create-bucket:
	aws s3 mb s3://${S3_BUCKET}
init-prepare-step-1: create-bucket ci
init-prepare-step-2: init-prepare-step-1
	cd terraform && terraform init && terraform apply -auto-approve
init-project: init-prepare-step-2 cd clean
destroy-project: clean
	cd terraform && terraform destroy -auto-approve
	aws s3 rm s3://${S3_BUCKET} --recursive
	aws s3 rb s3://${S3_BUCKET} --force