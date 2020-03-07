# future-kubernetes-docker

A Docker container for use in a Kubernetes cluster with the R future package. This Docker container image is available on Docker Hub as `paciorek/future-kubernetes`.

The future package provides for parallel computation in R on one or more machines.

- <https://cran.r-project.org/package=future>
- <https://github.com/HenrikBengtsson/future>

This Docker container is used by [this helm chart](https://github.com/paciorek/future-helm-chart) as the base container for the pods in a Kubernetes cluster providing access to the R future package via RStudio or R. 


## Creating this Docker container on Docker Hub

The container image was created on Docker Hub like this:

```
docker login --username=paciorek 
docker build -t future .
docker tag future paciorek/future-kubernetes:0.1
docker push paciorek/future-kubernetes
```


## Acknowledgments

Thanks to the [Rocker](https://github.com/rocker-org/rocker) team for the container on which this is based. 

