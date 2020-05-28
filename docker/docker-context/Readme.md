# Show current docker context

## Setup instructions

```bash
sudo rm -rf /usr/local/bin/docker-context && \
    sudo wget https://raw.githubusercontent.com/rxmicro/dev/master/docker/docker-context/setup.sh -O /usr/local/bin/docker-context && \
    sudo chmod 755 /usr/local/bin/docker-context
```

This setup bash script performs the following steps:

1. Remove the previous version of `docker-context` script.
2. Download the latest version of `docker-context` to the `/usr/local/bin/docker-context` location.
3. Make the `docker-context` script executable.

## Usage instructions

```bash
cd /path/to/the/project/dir

docker-context
```

To configure docker context use [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file) file