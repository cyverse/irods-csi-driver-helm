## iRODS CSI Driver Helm Chart Repository
This repository publishes the iRODS CSI Driver Helm chart.

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

`irodsfs` and `irodsfsd` must be installed before installing or using the iRODS CSI Driver. You can obtain them from the following repositories:

- [irodsfs](https://github.com/cyverse/irodsfs)
- [irodsfsd](https://github.com/cyverse/irodsfsd)

`irodsfsd` runs as a non-root user while kubelet creates CSI staging paths as
`root`. Grant the `irodsfsd` user access to the driver staging root and set a
default ACL so newly created volume paths inherit it. Do not change kubelet
ownership or make its directories world-writable:

```shell
sudo apt-get install -y acl
sudo mkdir -p /var/lib/kubelet/plugins/kubernetes.io/csi/irods.csi.cyverse.org
sudo setfacl -m u:irodsfsd:--x /var/lib/kubelet
sudo setfacl -m u:irodsfsd:--x /var/lib/kubelet/plugins
sudo setfacl -m u:irodsfsd:--x /var/lib/kubelet/plugins/kubernetes.io
sudo setfacl -m u:irodsfsd:--x /var/lib/kubelet/plugins/kubernetes.io/csi
sudo setfacl -R -m u:irodsfsd:rwx \
  /var/lib/kubelet/plugins/kubernetes.io/csi/irods.csi.cyverse.org
sudo setfacl -m d:u:irodsfsd:rwx \
  /var/lib/kubelet/plugins/kubernetes.io/csi/irods.csi.cyverse.org
```

For the supplied k3s test setup, the iRODS CSI Driver repository's
`test/ansible/irodsfsd_install.yml` playbook configures these ACLs
automatically.

The following example installs the iRODS CSI Driver as `irods-csi-driver` in the `irods-csi-driver` namespace.
```
helm install --create-namespace --namespace irods-csi-driver irods-csi-driver irods-csi-driver-repo/irods-csi-driver
```

To install the Helm chart for proxy authentication, create a YAML file with the driver configuration.
An example configuration file is available at [proxy_config_example.yaml](https://cyverse.github.io/irods-csi-driver-helm/examples/proxy_config_example.yaml).
Then install the driver with `-f` flag.
```
helm install --create-namespace --namespace irods-csi-driver irods-csi-driver irods-csi-driver-repo/irods-csi-driver -f ./proxy_config_example.yaml
```

See the [iRODS CSI Driver Kubernetes examples](https://github.com/cyverse/irods-csi-driver/tree/master/examples/kubernetes).

## Configuring iRODS CSI Driver Globally
Cluster administrators can configure iRODS CSI Driver parameters to provide default values or proxy authentication.

To configure the iRODS CSI Driver globally, create a secret named `<driver-installation-name>-global-secret` in the same namespace as the installed driver (`default` by default). The secret already exists after the driver is installed. To change the global configuration, delete the existing secret and create a new one.

The following parameters can be set:

| Parameter Name | Description | Example Value |
| --- | --- | --- |
| client | Driver type | "irodsfuse" |
| authenticationScheme | iRODS authentication scheme | "native" |
| clientServerNegotiation | iRODS client-server negotiation setting | "request_server_negotiation" |
| clientServerPolicy | iRODS client-server negotiation policy | "CS_NEG_REQUIRE" |
| host | iRODS hostname | "data.cyverse.org" |
| port | iRODS port | Optional, Default "1247" |
| zone | iRODS zone | "iplant" |
| clientZone | iRODS client zone for proxy authentication | "iplant" |
| user | iRODS user id | "irods_user" |
| clientUser | iRODS client user id for proxy authentication | "irods_client_user" |
| password | iRODS user password | "password" in plain text |
| defaultResource | Default iRODS resource | "demoResc" |
| encryptionAlgorithm | iRODS encryption algorithm | "AES-256-CBC" |
| encryptionKeySize | iRODS encryption key size | "32" |
| encryptionSaltSize | iRODS encryption salt size | "8" |
| encryptionNumHashRounds | iRODS encryption hash rounds | "16" |
| caCertificateFile | TLS CA certificate file | "/etc/ssl/certs/ca.pem" |
| caCertificatePath | TLS CA certificate directory | "/etc/ssl/certs" |
| verifyServer | TLS server verification setting | "cert" |
| sslServerName | TLS server name | "data.cyverse.org" |
| path | iRODS collection path to mount. Required unless `pathMappings` is supplied. | "/iplant/home/irods_user" |
| pathMappings | JSON array of iRODS path mappings. Replaces `path` when supplied. | `[{"irods_path":"/iplant/home/user","mapping_path":"/","resource_type":"dir"}]` |
| readAheadMax | Maximum read-ahead size | "1048576" |
| uid | host system UID to map owner | -1 (executor's UID, mostly UID of root, 0) |
| gid | host system GID to map owner | -1 (executor's GID, mostly GID of root, 0) |
| systemUser | Host system user used by irodsfs | "root" |
| metadataConnection | JSON iRODS metadata connection configuration | `{}` |
| ioConnection | JSON iRODS I/O connection configuration | `{}` |
| cache | JSON iRODSFS cache configuration | `{}` |
| poolEndpoint | iRODSFS pool service endpoint | "tcp://irodsfs-pool.example.org:1247" |
| debug | Enable irodsfs debug logging | "true" |
| readOnly | Mount the volume read-only | "true" |
| volumeRootPath | iRODS path to mount. Creates a subdirectory per persistent volume. (only for dynamic volume provisioning) | "/iplant/dynamic_volumes" |
| noVolumeDir | "true" to not create a subdirectory under `volumeRootPath`. It mounts the `volumeRootPath`. (only for dynamic volume provisioning) | "false". "false" by default. |
| provisioningMode | Dynamic provisioning marker written by the driver. Do not set manually. | "dynamic" |
| enforceProxyAccess | "true" to mandate passing `clientUser`, or giving different `user` as in global configuration. | "false". "false" by default. |
| mountPathWhitelist | a comma-separated list of paths to allow mount. | "/iplant/home" |



To create or delete secrets, see [Managing Secrets Using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/).

## Installing iRODS CSI Driver in a k0s Cluster
`k0s` is a Kubernetes distribution. Unlike other Kubernetes distributions, which use `/var/lib/kubelet` as the kubelet directory, k0s uses `/var/lib/k0s/kubelet`. Set `kubeletDir` to `/var/lib/k0s/kubelet` to allow the iRODS CSI Driver to mount persistent volumes.

You can do this by adding `--set kubeletDir=/var/lib/k0s/kubelet` to the install command:
```
helm install --create-namespace --namespace irods-csi-driver --set kubeletDir=/var/lib/k0s/kubelet irods-csi-driver irods-csi-driver-repo/irods-csi-driver
```

Alternatively, add the following line to the user configuration file. An example configuration file is available at [k0s.yaml](https://cyverse.github.io/irods-csi-driver-helm/examples/k0s.yaml).
```
kubeletDir: /var/lib/k0s/kubelet
```
