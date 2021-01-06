# com-gil-dong-infra-terraform

1. Create AWS IAM user (access key, secret key)
2. Install Terraform
3. Install terraform plugin on IDE
4. Install AWS CLI
5. Create S3 Bucket for managing terraform state


- infrastructure command
<pre>
 <code>
 $ cd terraform/

 $ terraform init

 $ terraform plan

 $ terraform apply
 </code>
</pre>

- lambda function deploy using Makefile
<pre>
 <code>
    make build && make deploy
 </code>
</pre>

- directly call the lambda function using aws cli
<pre>
 <code>
    aws lambda invoke --function-name {function-name} /dev/stdout
 </code>
</pre>

- call the lambda function through api gateway
<pre>
 <code>
    aws_api_gateway_deployment.api_deployment.invoke_url
 </code>
</pre>