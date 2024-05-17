# Deployment of an RStudio server in AWS
 NOTE: This document is taken from Jeff Stafford's [blog post](https://jstaf.github.io/posts/rstudio-server-semi-pro/)
 
## Install Rstudio server

This was tested on Ubuntu 22.04
```shell
# Update repositories
sudo apt update
# Install R
sudo apt install r-base
# Install dependencies
sudo apt install gdebi-core
# Download RStudio
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.06.0-421-amd64.deb
# Install RStudio server
sudo gdebi rstudio-server-2023.06.0-421-amd64.deb
```

## Configure firewall
```shell
# Install firewalld
sudo apt install firewalld
sudo systemctl enable --now firewalld
# open ports 80 and 443
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --reload
```
## Setup PAM modules
Add to `/etc/pam.d/rstudio`:

```shell
#%PAM-1.0
auth      requisite      pam_succeed_if.so uid >= 500 quiet
auth      required       pam_unix.so nodelay

account   required       pam_unix.so
````

## Configure reverse proxy
```shell
# Install nginx
sudo apt install nginx
sudo systemctl enable --now nginx
```
### Configure nginx
Edit the file `/etc/nginx/sites-enabled/rstudio.gedac.org` and add the following lines:
```nginx
server {
  location / {
    proxy_pass http://localhost:8787;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
 		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

  }
}
```

## Configure HTTPS with Certbot
### Install certbot
```shell
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```
### Generate certificate and restart nginx
```shell
sudo certbot certonly --nginx
sudo systemctl restart nginx
```

## Limit resources per user
1. Edit the file `/etc/security/limits.conf` and add the following lines:
   ```shell
   1000:       -    as  8388608
   ```
2. Add this line to `/etc/pam.d/rstudio`
    ```shell
    session    required   pam_limits.so
