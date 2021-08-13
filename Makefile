.EXPORT_ALL_VARIABLES:

.PHONY: gen_index
gen_index:
	helm repo index . --url https://cyverse.github.io/irods-csi-driver-helm
