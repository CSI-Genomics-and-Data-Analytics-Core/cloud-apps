# RStudio Server

This folder contains a cloudformation template to create the infrastructure needed to run an Rstudio server. In addition to resource allocation, we have to specify the username and password for the first user to use the server. More users can be added by connecting to the instance via SSH using the private key from the key pair referenced in the cloudformation template.  
Imortantly, at this time the template does not use SSL, so it is not recommended to use it in production. If we deploy this product, we would need to get a domain name to use with the server, and get a certificate from a certificate authority.

## How to use
When deploying the template, we need to specify the following parameters:
- InstanceType: The type of instance to use. The default is r5.4xlarge, which has 16 vCPUs and 128 GB of RAM. This is a good starting point, but it can be changed to a more powerful instance if needed.
- KeyName: The name of the key pair to use to connect to the instance via SSH. This key pair needs to be created in the region where the instance will be deployed.
- username: The username for the rstudio user. This user will be created when the instance is deployed, and it will be the first user to use the Rstudio server.
- password: The password for the rstudio user. This user will be created when the instance is deployed, and it will be the first user to use the Rstudio server.

This template uses the Ubuntu 22.04 server AMI available for the region where the template is deployed.