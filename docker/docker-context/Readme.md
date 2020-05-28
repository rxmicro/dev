# Show current docker context

## Setup instructions

```bash
rm -rf /tmp/setup && \
    wget https://raw.githubusercontent.com/rxmicro/dev/master/docker/docker-context/setup.sh -o /tmp/setup && \  
    sudo mv /tmp/setup /usr/local/bin/docker-context && \
    sudo chmod 755 /usr/local/bin/docker-context 
```

## Usage instructions

```bash
cd /path/to/the/project/dir

docker-context
```

To configure docker context use [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file) file