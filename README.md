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

### Set global configuration during installation

Configure the chart-managed global Secret through a Helm values file. The
`globalConfig.secret.stringData` entries become defaults for all volumes and
can provide the iRODS connection settings and proxy-authentication policy.
Start with [force_image_pull.yaml](https://cyverse.github.io/irods-csi-driver-helm/examples/force_image_pull.yaml):

```
curl -fsSLO https://cyverse.github.io/irods-csi-driver-helm/examples/force_image_pull.yaml
chmod 600 force_image_pull.yaml
```

Edit `globalConfig.secret.stringData` in the downloaded file. At a minimum,
set the `host`, `port`, `zone`, `user`, `password`, and
`mountPathWhitelist` values for your iRODS deployment. The file also sets the
controller and node plugin image `pullPolicy` to `Always`; remove those image
sections if that behavior is not wanted. Treat this file as sensitive because
`password` is stored in plain text.

Install the chart using the values file. Helm creates the
`irods-csi-driver-global-secret` Secret in the selected namespace and manages
it as part of this release:

```
helm install --create-namespace --namespace irods-csi-driver \
  --values ./force_image_pull.yaml \
  irods-csi-driver irods-csi-driver-repo/irods-csi-driver
```

For a proxy-focused starting point without the image pull settings, use
[proxy_config_example.yaml](https://cyverse.github.io/irods-csi-driver-helm/examples/proxy_config_example.yaml)
instead.

See the [iRODS CSI Driver Kubernetes examples](https://github.com/cyverse/irods-csi-driver/tree/master/examples/kubernetes).

## Reconfiguring iRODS CSI Driver Globally

To change the global settings after installation, update the same values file
and run `helm upgrade --install` with the original release name and namespace.
Do not delete and recreate the generated Secret with `kubectl`; Helm owns it
and updates it from `globalConfig.secret.stringData`.

```
helm upgrade --install --namespace irods-csi-driver \
  --values ./force_image_pull.yaml \
  irods-csi-driver irods-csi-driver-repo/irods-csi-driver
```

The following parameters can be set in `globalConfig.secret.stringData`:

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
| poolEndpoint | iRODSFS pool service endpoint | "tcp://irodsfs-pool.example.org:12020" |
| debug | Enable irodsfs debug logging | "true" |
| readOnly | Mount the volume read-only | "true" |
| volumeRootPath | iRODS path to mount. Creates a subdirectory per persistent volume. (only for dynamic volume provisioning) | "/iplant/dynamic_volumes" |
| noVolumeDir | "true" to not create a subdirectory under `volumeRootPath`. It mounts the `volumeRootPath`. (only for dynamic volume provisioning) | "false". "false" by default. |
| provisioningMode | Dynamic provisioning marker written by the driver. Do not set manually. | "dynamic" |
| enforceProxyAccess | "true" to mandate passing `clientUser`, or giving different `user` as in global configuration. | "false". "false" by default. |
| mountPathWhitelist | a comma-separated list of paths to allow mount. | "/iplant/home" |
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
