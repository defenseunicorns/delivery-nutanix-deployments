# delivery-nutanix-cluster-deployment

## Postgres Profile VM deployment
This deployment uses the postgres-profile-vm module from the delivery-nutanix-iac repo to stand up a VM that is preconfigured with all the settings required for the NDB service to import it for the purpose of creating a new Postgres database profile. It requires a VM image that has been built by the delivery-nutanix-image-builder repo that contains all the prerequisite software installed. An example set of variables for this deployment is provided:

```
nutanix_username    = "your-prism-username"
nutanix_password    = "your-prism-password"
nutanix_endpoint    = "hostname/ip of prism or prism central"
nutanix_port        = 9440
nutanix_insecure    = true
nutanix_cluster     = "Your-Cluster"
nutanix_subnet      = "Your Subnet"
image_name          = "uds-postgresql-buildtag"
ssh_authorized_keys = ["Your SSH public key"]
user_password       = "$6$eqCKlTML5rIALmwB$6fyOlrTK9E353ofDISHuEJxqIZx8MYt.mQM.qfbeydQX/CGnz204AlmYg5VCZ8O/xLKJ34CkgV7hyoUno08N9."
pg_password         = "desired-postgres-user-password"
```

nutanix_insecure sets if cert validation should be disabled or not. The image name should be an image available in the cluster that was built by the postgres-profile image builder. user_password is the password that will be configured for the 'era' user which is used by NDB to connect to the instance. The hashed value can be obtained by using the command `mkpasswd -m sha-512 -s` and providing the desired password. pg_password is the password that will be set for the postgres user and is also used by the NDB service to import the database. The passwords can be anything and will not persist when NDB provisions new databases in the future since NDB lets you set passwords at database provision time.

When the postgres image being used has SELinux enabled (if using RHEL this is the default), the following is a required `Post Create Command` when provisioning a database with the profile:

```
sudo /.autorelabel; sudo reboot
```

This fixes SELinux labels that prevent the era_postgres service from running correctly and failing to start on future reboots.