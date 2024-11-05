## iRODS CSI Driver Helm Chart Repo
This repository publishes iRODS CSI Driver Helm Chart.

## Adding this repository to your Helm
```
helm repo add irods-csi-driver-repo https://cyverse.github.io/irods-csi-driver-helm/
helm repo update
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

To install the helm chart for proxy auth, create a yaml file with driver configuration.
An example configuration file is available at [proxy_config_example.yaml](https://cyverse.github.io/irods-csi-driver-helm/examples/proxy_config_example.yaml).
Then install the driver with `-f` flag.
```
helm install irods-csi-driver irods-csi-driver-repo/irods-csi-driver -f ./proxy_config_example.yaml
```

## Configuring iRODS CSI Driver Globally
Cluster admins can configure the iRODS CSI Driver's parameters. This can be used to provide default values or to provide proxy authentication. 

To configure the iRODS CSI Driver globally, a secret `<driver-installation-name>-global-secret` should be created in the same namespace as the driver installed (`default` namespace by default). The secret will aready exist when the driver is installed. You will need to delete the existing secret and create a new one.

The following parameters can be set:

| Parameter Name       | Description                                                                                               | Example Value              |
|----------------------|-----------------------------------------------------------------------------------------------------------|----------------------------|
| `client`            | Default client type                                                                                       | `"irodsfuse"`              |
| `host`              | Default iRODS hostname                                                                                    | `"data.cyverse.org"`       |
| `port`              | Default iRODS port (optional, default is `"1247"`)                                                        | `"1247"`                   |
| `zone`              | Default iRODS zone                                                                                        | `"iplant"`                 |
| `user`              | iRODS proxy user ID (used for proxy authentication)                                                       | `"rods"`                   |
| `password`          | iRODS proxy user password (in plain text)                                                                 | `"password"`               |
| `volumeRootPath`    | iRODS path to mount. Creates a subdirectory per persistent volume (only for dynamic volume provisioning). | `"/iplant/dynamic_volumes"`|
| `enforceProxyAccess`| Set to `"true"` to mandate passing `clientUser` or using a different `user` as in global configuration.   | `"false"` (default)        |
| `mountPathWhitelist`| A comma-separated list of paths to allow mounting                                                         | `"/iplant/home"`           |


To create or delete secrets, please refer this manual 
[Managing Secret using Kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/).