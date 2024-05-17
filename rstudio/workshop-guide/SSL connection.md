# Allocate an Elastic IP (EIP)
To ensure that your EC2 instance's IP address remains static (in case the instance is stopped or terminated), allocate an Elastic IP address and associate it with your instance. This provides a static public IP address that you can use to point your domain to.

# Register a Domain Name
Use Route 53 to register a domain name.

Create a new A record (or AAAA record) and point it to the Elastic IP address you allocated for your EC2 instance.

Ensure that your EC2 instance's security group allows inbound traffic on the necessary ports (e.g., port 80 for HTTP, port 443 for HTTPS).

# Install Certbot

```shell
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Generate certificates from Let's Encrypt

```shell
sudo certbot -d <domain.name>
```


# Create NGINX conf for RStudio
```shell
sudo vi /etc/nginx/sites-available/<domain.name>
```

Alter the domain name and paste the below content.

```shell
server {
    listen 80;
    server_name <domain.name>;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name <domain.name>;

    ssl_certificate /etc/letsencrypt/live/<domain.name>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<domain.name>/privkey.pem;


    location / {
        proxy_pass http://localhost:8787;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
```

Enable the configuration by creating a symbolic link
```shell
sudo ln -s /etc/nginx/sites-available/<domain.name> /etc/nginx/sites-enabled/
```

Validate NGINX configuration, before reload the server.

```shell
sudo nginx -t
```

You should see a response like below,
```shell
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Reload NGNIX server
```shell
sudo systemctl reload nginx
```