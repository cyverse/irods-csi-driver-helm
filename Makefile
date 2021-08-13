.EXPORT_ALL_VARIABLES:

.PHONY: gen_index
gen_index:
	helm repo index . --url https://github.com/cyverse/irods-csi-driver
