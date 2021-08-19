## Used by the helm chart to configure R in the scheduler and worker pods. Not intended for use by users.
local({
setup_kube <- function() {
    ## EXTRA_R_PACKAGES in set in values.yaml in the helm chart.
    install.packages(strsplit(Sys.getenv('EXTRA_R_PACKAGES'), ' ')[[1]])
}

## Allow users to get worker names, e.g.,
## plan(cluster, workers = get_kube_workers(), revtunnel = FALSE)
## This will only work if access to kubectl is enabled from within the pods.
get_kube_workers <- function() {
	workers_string <- system("kubectl get pod --namespace default -o jsonpath='{.items[?(@.metadata.labels.component==\"worker\")].metadata.name}'", intern = TRUE)
	return(strsplit(workers_string, ' ')[[1]])
}
}, envir = globalenv()
)

