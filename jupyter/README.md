# Jupyter server

This template deploys a Jupyter Hub, which can be used for users to execute Jupyter notebooks. An Admin user should be created, and then the admin can add more users.

Imortantly, at this time the template does not use SSL, so it is not recommended to use it in production. If we deploy this product, we would need to get a domain name to use with the server, and get a certificate from a certificate authority.

## Adding new users
1. Enter the Jupyter Hub as admin
2. Click on File, and then *Hub Control Panel*
3. Click on *Admin* and then *Add Users*