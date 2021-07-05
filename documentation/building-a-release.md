# Building images to get ready for a release

Deployment of a release happens in two steps. First a new set of container-images needs to be built, then they need to be deployed to the correct environment.

Build is handled by merge by a Google Cloud Build in the [kkos2/os2display-admin](https://github.com/kkos2/os2display-admin).

The subsequent manual triggering of the automated deployment is handled by scripts in [kkos2/os2display-k8s-environments](https://github.com/kkos2/os2display-k8s-environments).
