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

(TODO)

# Upgrading RKE2 cluster

The RKE2 module is designed to do upgrades by deploying a new set of nodes with an image that contain the desired updates. These updates could be OS updates and changes or an updated version of RKE2. The process of doing this is pretty straightforward, but there will be some steps that need to be followed (that would change depending on the workloads running in the cluster) to avoid data loss and minimize downtime. The example steps that will be walked through in this README assume the cluster is running the UDS SWF which includes Rook Ceph for persistent storage.

## Step 0: Create a cluster to upgrade

The following is an example cluster deployment using the RKE2 module that can be used as a starting point for doing an upgrade. Notice that bootstrap_cluster is set to true which indicates that the nodes deployed by the module start a new cluster instead of joining an existing cluster.

```
resource "random_password" "example_token" {
  length  = 40
  special = false
}

module "example-cluster" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=enable-rke2-upgrades"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "rke2-test"
  server_count        = 3
  agent_count         = 4
  server_memory       = 16*1024
  server_cpu          = 8
  agent_memory        = 64*1024
  agent_cpu           = 16
  image_name          = "uds-rke2-rhel-202311291928"
  ssh_authorized_keys = var.ssh_authorized_keys
  server_dns_name     = "kube-api.your.domain"
  join_token          = random_password.example_token.result
  bootstrap_cluster   = true
}
```

## Step 1: Deploy New Upgraded Nodes

To start the upgrade process deploy the upgraded nodes and join them to the cluster. The following example shows adding a copy of the module resource that references a different image that contains updates, adds a keyword to the name to help distinguish the new nodes from the old nodes, and has bootstrap_cluster set to false since the nodes should all join the existing cluster. Notice the server_dns_name and the join token are set to the same values as the first module resource. Those variables are what the nodes use to connect to and join the cluster. 

```
resource "random_password" "example_token" {
  length  = 40
  special = false
}

module "example-cluster" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=enable-rke2-upgrades"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "rke2-example"
  server_count        = 3
  agent_count         = 4
  server_memory       = 16*1024
  server_cpu          = 8
  agent_memory        = 64*1024
  agent_cpu           = 16
  image_name          = "uds-rke2-rhel-202311291928"
  ssh_authorized_keys = var.ssh_authorized_keys
  server_dns_name     = "kube-api.your.domain"
  join_token          = random_password.example_token.result
  bootstrap_cluster   = true
}

module "green-example-cluster" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=enable-rke2-upgrades"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "rke2-example-green"
  server_count        = 3
  agent_count         = 4
  server_memory       = 16*1024
  server_cpu          = 8
  agent_memory        = 64*1024
  agent_cpu           = 16
  image_name          = "uds-rke2-rhel-202312121939"
  ssh_authorized_keys = var.ssh_authorized_keys
  server_dns_name     = "kube-api.your.domain"
  join_token          = random_password.example_token.result
  bootstrap_cluster   = false
}
```

After running a terraform apply wait for the new nodes to join the cluster. With this example, after they all successfully join running `kubectl get nodes` should show 7 nodes that start with `rke2-example` and another 7 nodes start with `rke2-example-green`. Once the new nodes are joined and in a "Ready" state, cordon the old nodes so new pods aren't scheduled on them by running `kubectl cordon rke2-example-abc-server-0` for each node to be removed. Draining automatically cordons a node when it is drained, but by cordoning all of the nodes to be deleted it prevents pods from getting drained from a node and moved to a different node that is going to also be drained. 

Now the cluster is ready to start the process of backfilling ceph data to the new nodes and migrating pods.

## Step 2: Ceph Data Migration

Before draining and deleting nodes, ceph data needs to be migrated to OSDs running on the new nodes. This process can be done by using the [rook-ceph plugin](https://github.com/rook/kubectl-rook-ceph#install) for kubectl if it is available in your environment, or by running the ceph commands in the rook-ceph toolbox pod. This example will show commands using the rook-ceph plugin, but they are all available in the toolbox as well, just remove "kubectl rook-ceph" from the start of the commands when running inside the toolbox. For example, a command using the kubectl plugin: `kubectl rook-ceph ceph status` vs the same command running on the ceph-toolbox: `ceph status`

### Verify New OSDs Are Healthy

To start, verify that the ceph OSD pods deployed to the new nodes have finished standing up with the command: `kubectl get pods -n rook-ceph`. Once all the ceph pods are healthy, run `kubectl rook-ceph ceph status` to check the status of the ceph cluster. The cluster health should be `HEALTH_OK` and all the PGs under data should be `active+clean`. Next run `kubectl rook-ceph ceph osd tree` to see a list of OSDs and their host nodes. With our default module configuration, you should see one OSD per cluster node. Since we have deployed a new set of nodes, there should be enough ceph storage available on all the new nodes to backfill all of the existing ceph data to the new nodes.

### Mark Old OSDs out

In order to start backfilling, the OSDs on the old nodes need to be marked `out`. This can be done 1 OSD at a time by running the osd out command with a single OSD id like this: `kubectl rook-ceph osd out 0` You can also mark multiple OSDs as out at once by passing multiple OSD ids to the command like this: `kubectl rook-ceph osd out 0 1` which would mark OSDs 0 and 1 out at the same time. Avoid marking too many OSDs out at once since it can impact performance and availability of data while data is being backfilled to other OSDs.

After running the command, checking the osd tree again with `kubectl rook-ceph ceph osd tree` should show the OSD you marked out with a weight of 0, and running `kubectl rook-ceph ceph status` should show PGs being remapped and backfilled. Keep checking ceph status until all PGs show `active+clean` again, then repeat this process again to mark the next OSD(s) out until all OSDs on the old kubernetes nodes are marked out and the ceph cluster status is healthy with only the OSDs on the new nodes being used.

### Delete Old OSD pods

Once all the old OSDs have been marked out and the ceph cluster status is healthy, the old OSD pods can be deleted. Start by scaling the ceph operator down so it doesn't try to recreate the OSDs after they are removed: `kubectl -n rook-ceph scale deployment rook-ceph-operator --replicas=0`

Once the rook-ceph-operator pod has scaled down, each of the old OSD pods can be deleted by deleting each of their deployments like this: `kubectl delete deployment rook-ceph-osd-0 -n rook-ceph`

After the old OSD pods have been deleted, the rook-ceph-operator can be scaled back up: `kubectl -n rook-ceph scale deployment rook-ceph-operator --replicas=1`

### Purge and Remove From Ceph

After old OSD pods have deleted, running `kubectl rook-ceph ceph osd tree` should show all of the old OSDs with the status `down`. They can now be purged by running `kubectl rook-ceph ceph osd purge 0 --yes-i-really-mean-it` for each of the old OSDs. After running this for each OSD, the OSD tree should still show the old nodes, but they should have no OSDs on them anymore. Now the nodes with no OSDs can be removed from the crush map by running `kubectl rook-ceph ceph osd crush remove rke2-example-abc-server-0` for each kubernetes node that is being removed. After running that for each of the old nodes, the OSD tree should only show the upgraded nodes.

### Ceph Migration Completed

Ceph data has now been migrated to the upgraded kubernetes nodes, and the old nodes can start being drained.

## Step 3: Node Draining

For each of the old nodes run `kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data` and wait for it to finish draining. To minimize impact to running services, it is recommended to wait for all the pods that get drained from a node to get rescheduled and start back up before draining the next node.

A node may get stuck draining if it is running a pod with a pod disruption budget that has a min availability equal to the number of replicas that the pod has. When this is encountered, the drain command will log the pod that can't be evicted and keep trying until the pod is deleted. The pod logged can be manually be deleted, which should allow the drain command to finish for the node.

### Draining Nodes Running Ceph MONs

After draining a node that is running a ceph mon pod, the mon will be deleted and the ceph operator will attempt to recreate the mon on the node that was cordoned and drained. This means the pod will appear stuck in a pending state because it can't be scheduled on the node being selected for it. After a timeout, the ceph operator should create a new mon on a different node that is schedulable. It is important to not drain multiple nodes that are running ceph mon pods before a previously deleted mon has been replaced.

For example, if you have nodes `rke2-example-abc-agent-0`, `rke2-example-abc-agent-1`, and `rke2-example-abc-agent-2` running `rook-ceph-mon-a`, `rook-ceph-mon-b`, and `rook-ceph-mon-c`, after draining node `rke2-example-abc-agent-0` you will see `rook-ceph-mon-a` get deleted and recreated in a pending state. Don't drain agent 1 or 2 until you see `rook-ceph-mon-a` get replaced by `rook-ceph-mon-d` which will get scheduled on one of the new nodes that aren't cordoned. Ceph with 3 mons requires at least 2 mons to remain up to keep quorum.

### Draining Complete

Once all of the old nodes have been drained, it is safe to move onto deleting the nodes.

## Step 4: Node Deletion

Delete each node from the cluster by running `kubectl delete node <node-name>` for each of the nodes that have been successfully drained.

After removing the nodes from the cluster, the VMs can be cleaned up by removing the module resource for the old nodes from your terraform and run a `terraform apply`. Example shows the module that would be deleted commented out:

```
resource "random_password" "example_token" {
  length  = 40
  special = false
}

# module "example-cluster" {
#   source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=enable-rke2-upgrades"
# 
#   nutanix_cluster     = var.nutanix_cluster
#   nutanix_subnet      = var.nutanix_subnet
#   name                = "rke2-example"
#   server_count        = 3
#   agent_count         = 4
#   server_memory       = 16*1024
#   server_cpu          = 8
#   agent_memory        = 64*1024
#   agent_cpu           = 16
#   image_name          = "uds-rke2-rhel-202311291928"
#   ssh_authorized_keys = var.ssh_authorized_keys
#   server_dns_name     = "kube-api.your.domain"
#   join_token          = random_password.example_token.result
#   bootstrap_cluster   = true
# }

module "green-example-cluster" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=enable-rke2-upgrades"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "rke2-example-green"
  server_count        = 3
  agent_count         = 4
  server_memory       = 16*1024
  server_cpu          = 8
  agent_memory        = 64*1024
  agent_cpu           = 16
  image_name          = "uds-rke2-rhel-202312121939"
  ssh_authorized_keys = var.ssh_authorized_keys
  server_dns_name     = "kube-api.your.domain"
  join_token          = random_password.example_token.result
  bootstrap_cluster   = false
}
```

Verify that the terraform plan shows the correct RKE2 nodes being deleted, and confirm the apply. Once the apply finishes, the cluster upgrade is complete.