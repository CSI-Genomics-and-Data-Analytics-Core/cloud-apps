# Set up a workshop via Rstudio server

## User generation

Run `create-users.sh` script to create system users and copy workshop content to each environment

Add everyone to `rstudio-users` group.

Configure `rstudio-users` group in `/etc/rstudio/rserver.conf` (already part of our launchtemplate in Cloudformation.yaml)

```shell
auth-required-user-group=rstudio-users
```
