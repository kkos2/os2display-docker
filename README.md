# Infrastructure for Os2Display

The repository contains a Docker setup for running locally and images for running on production.

## Development

To get started you need the following:
1. Install [Docker](https://docs.docker.com/install/)
2. Install [Docker Compose](https://docs.docker.com/compose/install/)
3. Install [Dory](https://github.com/FreedomBen/dory). - Something similiar will do. dnsmasq, or another project that can provide access to the containers via the `VIRTUAL_HOST` environments-specified in docker-compose.
4. `dory up`
5. `make clone-admin`
6. `make reset-dev` or `make reset-dev-nfs` (see below)
7. `make run-gulp`

When you have made changes to slides or screens you might want to run `make run-gulp`
again.

After reset the site will be available at https://admin.kff-os2display.docker

## NFS
Docker For Mac is notoriously slow when it comes to "bind" mounts. In order to support this better the setup supports mounting the code-base via NFS with two caveats.

1. A compatible /etc/exports has to be set up in advance, eg. sees https://forums.docker.com/t/nfs-native-support/48531
2. The mount will display all files as being owned by the same user, any attempts to change the ownership or permissions will be rejected. This may cause problems if you need your code to handle ownerships

The setup is currently unable to auto-detect whether to use NFS, so instead you have to explicitly reset using

```bash
make reset-dev-nfs
```

## Testing a release
```bash
make reset-release
```

## Other
See Makefile and the [documentation](documentation) for more details or feel
free to contact the authors for more details.
