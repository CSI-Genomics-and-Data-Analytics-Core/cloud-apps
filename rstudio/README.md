# RStudio Server

This folder contains a cloudformation template to create the infrastructure needed to run an Rstudio server. In addition to resource allocation, we have to specify the username and password for the first user to use the server. More users can be added by connecting to the instance via SSH using the private key from the key pair referenced in the cloudformation template.  
Imortantly, at this time the template does not use SSL, so it is not recommended to use it in production. If we deploy this product, we would need to get a domain name to use with the server, and get a certificate from a certificate authority.

## How to use
When deploying the template, we need to specify the following parameters:
- InstanceType: The type of instance to use. The default is r5.4xlarge, which has 16 vCPUs and 128 GB of RAM. This is a good starting point, but it can be changed to a more powerful instance if needed.
- username: The username for the rstudio user. This user will be created when the instance is deployed, and it will be the first user to use the Rstudio server.
- password: The password for the rstudio user. This user will be created when the instance is deployed, and it will be the first user to use the Rstudio server.

This template uses the Ubuntu 22.04 server AMI available for the region where the template is deployed.

# Using AWS CLI

aws cloudformation create-stack --stack-name RStudioStack --template-body file://<local file path to server.yaml> --tags Key=AppManagerCFNStackKey,Value=RStudioStack

aws cloudformation describe-stacks --stack-name RStudioStack  --query "Stacks[0].Outputs"

# Access RStudio

Once the deployment completed, private key stored on SSM parameter store.

Fetch key ID from ec2 key pairs

keyPairName="replace-with-your-key-pair-name"


```shell
keyPairID=$(aws ec2 describe-key-pairs \
  --filters Name=key-name,Values=$keyPairName \
  --query "KeyPairs[*].KeyPairId" \
  --output text)
```

echo "keyPairID = $keyPairID"


Define your private key file name

```shell
fileName="rstudio"

aws ssm get-parameter \
     --name /ec2/keypair/$keyPairID \
     --with-decryption \
     --query Parameter.Value \
     --output text > $fileName.pem 

chmod 400 $fileName.pem   

ssh -i rstudio.pem ubuntu@<public-ip>
```


# Update R 4.4
https://cran.r-project.org/bin/linux/ubuntu/
