# Requirements

* NFS Server installed and export a data directory
* Package `nfs-common` is required on every K8s node
* Install nfs provisioner as Helm chart
* Run `kubectl apply -f pv-nfs.yaml`
