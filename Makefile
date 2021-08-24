.EXPORT_ALL_VARIABLES:

.PHONY: gen-index
gen-index:
	helm repo index . --url https://cyverse.github.io/irods-csi-driver-helm
