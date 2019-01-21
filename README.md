# Releasing
1. Tag the revision in `admin` you want to release and push it
2. Build an `admin-release` release image `make build-release TAG=<tag>`
3. Push the release `make push-release TAG=<tag>`
4. Update the image-reference in the `provisioning/kubernetes-manifests/static/admin/deployment.yaml` manifest, commit the manifest
5. Apply the changes to the target namespace `kubectl apply -n <namespace> -f provisioning/kubernetes-manifests/static/admin/deployment.yaml`
