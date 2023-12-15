# IaC Deployments

This repository contains a collection of Terraform deployments that utilize the Nutanix IaC modules from the delivery-nutanix-iac repository. They can be used as a reference for how to use the modules and as configured they show an example Nutanix environment configured with both a "dev" and a "test" RKE2 cluster and databases intended for deploying the UDS Software Factory.

The deployments assume a variety of input variables are set that are specific to the modules being referenced. Details about module specific variables can be found in the delivery-nutanix-iac README, but here are the common variables needed for connecting the Nutanix provider to a Nutanix environment.

## Prism Central Variables

```
nutanix_username = "your-prism-username"
nutanix_password = "your-prism-password"
nutanix_endpoint = "hostname/ip of prism or prism central"
nutanix_port     = 9440
nutanix_insecure = true # true if you need to disable cert validation for prism
```

## Nutanix Database Service Variables

```
ndb_username = "your-ndb-username"
ndb_password = "your-ndb-password"
ndb_endpoint = "hostname/ip of NDB service"
```

# Deploying Infrastructure For UDS SWF



# Upgrading RKE2 cluster

