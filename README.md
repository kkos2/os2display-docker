# OS2Display docker development environment for KFF


To get started you need the following:
1. Install [Docker](https://docs.docker.com/install/)
2. Install [Docker Compose](https://docs.docker.com/compose/install/)
3. Install [Dory](https://github.com/FreedomBen/dory). - Something similar will do. dnsmasq, or another project that can provide access to the containers via the `VIRTUAL_HOST` environments-specified in docker-compose.

# Initial local setup
1. Ensure Dory is running by running `dory up` - this is only necessary to do once, dory should keep running at least until you reboot your machine.
2. Do an initial clone of the admin repository by running `make clone-admin`. This task requires that you have configured `_variables.source` during the initial fork of `os2display-docker`. See [Initial setup of os2display-docker](#initial-setup-of-os2display-docker).

# Development and testing
You now ready to start developing and/or testing releases by following the steps below. When the reset is complete the site will be available at `https://admin.$DOCKER_BASE_DOMAIN.docker` (see _variables.source for the value of `$DOCKER_BASE_DOMAIN`).

## Development
1. Run `make reset-dev` or `make reset-dev-nfs` (see NFS section below)
2. Run `make run-gulp` to do an initial build of assets. Re-run this task every time you modify any js/css that needs building, eg. any changes to slide/screen templates.

## Building a release
The kff os2display project auto-builds releases for each push to the `os2display-admin` repository (see the `os2display-admin/cloudbuild` directory). Each successfully built docker-image is published to `eu.gcr.io/os2display-kff/admin-release` and a tag matching the release is pushed to the `os2display-admin` repo. You can follow the build via https://console.cloud.google.com/cloud-build/builds?project=os2display-kff
Consult https://github.com/kkos2/os2display-k8s-environments for how to deploy the release to an environment.

## Testing a release
You can test a release locally before deploying it by updating `ADMIN_RELEASE_TAG` in _variables.source, then run `make reset-release`.

Consider committing the change to `_variables.source` if the release is deployed to prod.

## Changes to core and third-party bundles.
Changes should be delivered via patches (see [Changes to admin](#changes-to-admin)). The patch should be placed in admin/patches.

You develop the patch by making changes to the downloaded bundle in `admin/vendor/os2display/<bundlename>`. This can be eased by cloning the bundle from https://github.com/os2display, checking out the correct version, and then moving the .git folder into the bundle.
Eg.
```bash
git clone https://github.com/os2display/admin-bundle.git
cd admin-bundle
git checkout <some tag>
mv .git /myproject/os2display-docker/development/admin/vendor/os2display/admin-bundle/
```
Implement your changes and then do a
```bash
cd /myproject/os2display-docker/development/admin/vendor/os2display/admin-bundle/
git diff <some tag> HEAD > /myproject/os2display-docker/development/admin/patches/mypatch.patch
```

Add the patch to composer.json, remove the module (or move it to a temporary location if you want to keep the workspace), and then do a clean `make reset-dev`/`make reset-dev-nfs`.

Your patch should now be applied.
When you are ready to commit, finish off by running
```bash
make update-composer-lock
```
To refresh the lock-file (as it references the patch).

You should ideally do a fork of the repository in mention and open a pull-request with your change.

### Recompiling assets for bundles
You may need to rebuild assets that you've modified in bundles. For this you can use the same approach as the one used for building admin assets:
```bash
cd /myproject/os2display-docker/development/admin/vendor/os2display/some-bundle
# Consult the gulp-file for actual targes, and replace yarn for npm if
# npm is used.
docker run \
  -v $(PWD):/app \
  -w /app \
  node:8.16.0-slim \
  sh -c "yarn && yarn run gulp js assets sass"
```

### NFS
Docker For Mac is notoriously slow when it comes to "bind" mounts. In order to support this better the setup supports mounting the code-base via NFS with two caveats.

1. A compatible /etc/exports has to be set up in advance, eg. sees https://forums.docker.com/t/nfs-native-support/48531
2. The mount will display all files as being owned by the same user, any attempts to change the ownership or permissions will be rejected. This may cause problems if you need your code to handle ownerships

The setup is currently unable to auto-detect whether to use NFS, so instead you have to explicitly reset using

```bash
make reset-dev-nfs
```

# Other resources
* See the Makefile for additional tasks.  
* See https://github.com/reload/os2display-k8s/tree/master/documentation for general documentation on the docker-based hosting of os2display
* see https://github.com/os2display/docs for the official project documentation.

Or feel free to contact the authors for more details.

# Initial setup of this repo
Fork this repository from reload/os2display-docker, then customize `_variables.source`. You should at the very least update `ADMIN_REPOSITORY` and `ADMIN_REPOSITORY_BRANCH` to reference your `admin` fork.

## Changes to admin
You must make the following changes to your `admin` fork to be compatible with the docker-setup.

First add support for patches during composer-install.
```shell
docker-compose run \
  -e COMPOSER_MEMORY_LIMIT=-1 \
  admin-php \
  composer require cweagans/composer-patches:~1.0
```
(The composer dependencygraph is quite large so we need to cancel the memory-limit an keep our fingers crossed, you probably need about 3-4 gigabytes of available memory in the container).

Add a patch to support non-localhost elasticsearch (until https://github.com/os2display/admin/pull/20 gets merged).
```shell
{
  "require": {
    "cweagans/composer-patches": "~1.0",
  },
  "extra": {
    "patches": {
      "os2display/admin-bundle": {
        "Switch to supporting a separate configuration for the public search hostname": "patches/admin-bundle-public-search.patch"
      }
    }
  }
}
```
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
