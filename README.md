## iRODS CSI Driver Helm Chart Repo
This repository publishes iRODS CSI Driver Helm Chart.

## Adding this repository to your Helm
```
helm repo add irods-csi-driver-repo https://cyverse.github.io/irods-csi-driver-helm/
```

Verify the repository addition.
```
helm search repo irods
```


## Installing iRODS CSI Driver Helm Chart
Following example installs the iRODS CSI Driver and `irods-csi-driver` will be the name of the driver installed.
```
helm install irods-csi-driver irods-csi-driver-repo/irods-csi-driver
```
