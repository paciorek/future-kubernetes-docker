## Used by the helm chart to configure R in the scheduler and worker pods. Not intended for use by users.
setup_kube <- function(set_Renviron = FALSE) {
    ## EXTRA_R_PACKAGES in set in values.yaml in the helm chart.
    install.packages(strsplit(Sys.getenv('EXTRA_R_PACKAGES'), ' ')[[1]])
    if(set_Renviron) {
        system("echo R_FUTURE_MAKENODEPSOCK_RSHCMD=kubectl >> /usr/local/lib/R/etc/Renviron")
        system("echo R_FUTURE_MAKENODEPSOCK_RSHOPTS=exec -it >> /usr/local/lib/R/etc/Renviron")
        system("echo 'R_FUTURE_MAKENODEPSOCK_RSHPOSTOPTS=-- bash -c' >> /usr/local/lib/R/etc/Renviron")
        system("echo R_FUTURE_MAKENODEPSOCK_MASTER=future-scheduler >> /usr/local/lib/R/etc/Renviron")
        system("echo KUBERNETES_SERVICE_HOST=$(kubectl get svc --namespace default kubernetes -o jsonpath='{.spec.clusterIP}') >> /usr/local/lib/R/etc/Renviron")
        system("echo KUBERNETES_SERVICE_PORT=$(kubectl get svc --namespace default kubernetes -o jsonpath='{.spec.ports[0].port}')  >> /usr/local/lib/R/etc/Renviron")
        system("echo R_PARALLEL_PORT=$(kubectl get svc --namespace default future-scheduler -o jsonpath='{.spec.ports[?(@.name==\"future-master\")].port}') >> /usr/local/lib/R/etc/Renviron")
        system("echo R_FUTURE_WORKERS=$(kubectl get pod --namespace default -o jsonpath='{.items[?(@.metadata.labels.component==\"worker\")].metadata.name}') >> /usr/local/lib/R/etc/Renviron")
    }
}

## Allow users to get worker names, e.g.,
## plan(cluster, workers = get_kube_workers(), revtunnel = FALSE)
get_kube_workers <- function() {
	workers_string <- system("kubectl get pod --namespace default -o jsonpath='{.items[?(@.metadata.labels.component==\"worker\")].metadata.name}'", intern = TRUE)
	return(strsplit(workers_string, ' ')[[1]])
}	

