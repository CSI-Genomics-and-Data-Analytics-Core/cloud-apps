# Cloud applications

In this repository, we will keep code and procedures to deploy cloud applications that researchers might need.

## Windows GUI applications
In some instances, users need to analyze data in a graphical user interface (GUI) application. For these cases, the folder `win_ec2` contains a cloud formation script to deploy a Windows server 2022 instance, that can be accessed using an RDP client.

## RStudio Server
RStudio Server is a web application that allows users to run RStudio in a web browser. This is useful for users that need to run R code in a remote server, but do not want to use the command line. In addition to basic resource allocation, the template requires the user to set a user name and password to create the first user to use the server. The template also allows ssh connections, using the private key from the key pair referenced in the template. As output of the stack, the public IP and the user name will be displayed.