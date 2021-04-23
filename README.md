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

## Configuring iRODS CSI Driver Globally
Cluster admins can configure the iRODS CSI Driver's parameters. This can be used to provide default values or to provide proxy authentication. 

To configure the iRODS CSI Driver globally, a secret `<driver-installation-name>-global-secret` should be created in the same namespace as the driver installed (`default` namespace by default). The secret will aready exist when the driver is installed. You will need to delete the existing secret and create a new one.

Following parameters can be set:
| Parameter Name | Description | Example Value |
| --- | --- | --- |
| client | Default client type | "irodsfuse" |
| host | default iRODS hostname | "data.cyverse.org" |
| port | default iRODS port | Optional, Default "1247" |
| zone | default iRODS zone | "iplant" |
| user | iRODS proxy user id (used for proxy authentication) | "rods" |
| password | iRODS proxy user password | "password" in plane text |
| volumeRootPath | iRODS path to mount. Creates a subdirectory per persistent volume. (only for dynamic volume provisioning) | "/iplant/dynamic_volumes" |
| enforceProxyAccess | "true" to mandate passing `clientUser`, or giving different `user` as in global configuration. | "false". "false" by default. |
| mountPathWhitelist | a comma-separated list of paths to allow mount. | "/iplant/home" |


To create or delete secrets, please refer this manual 
[Managing Secret using Kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/).