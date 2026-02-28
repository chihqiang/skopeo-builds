# Skopeo Builds

## Project Overview

Skopeo Builds is a project for building and distributing the Skopeo tool. Skopeo is a command-line utility for copying, inspecting, and deleting container images between container registries without extracting them locally.

## Installation

### Install using script

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chihqiang/skopeo-builds/refs/heads/main/install.sh)"
```

### Verify installation

After installation, run the following command to verify that Skopeo is installed correctly:

```bash
skopeo --version
```

## Using Docker

### Build Docker image

```bash
docker build -t zhiqiangwang/skopeo:latest .
```

### Run Skopeo directly via Docker

```bash
docker run --rm zhiqiangwang/skopeo:latest --version
```

### Copy container image

```bash
docker run --rm \
  -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
  zhiqiangwang/skopeo:latest copy \
    --insecure-policy \
    --multi-arch=all \
    --dest-tls-verify=false \
    "docker://alpine:latest" \
    "docker://myregistry.local/alpine:latest"
```

### Copy single architecture image

If you only need to copy a specific architecture (e.g., `linux/amd64`) image, use the `--override-arch` parameter:

```bash
docker run --rm \
  -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
  zhiqiangwang/skopeo:latest copy \
    --insecure-policy \
    --override-arch=amd64 \
    --override-os=linux \
    --dest-tls-verify=false \
    "docker://alpine:latest" \
    "docker://myregistry.local/alpine:amd64"
```

### Inspect image information

```bash
docker run --rm zhiqiangwang/skopeo:latest inspect docker://alpine:latest
```

### Temporary container access

```bash
docker run --rm -v $HOME/.docker/config.json:/root/.docker/config.json:ro -it --entrypoint bash zhiqiangwang/skopeo:latest
```

## Command Line Usage

### Delete images

```bash
skopeo delete docker://localhost:5000/imagename:latest
```

### Sync registries

```bash
skopeo sync --src docker --dest dir registry.example.com/busybox /media/usb
```

### Show unverified image's digest

```bash
skopeo inspect docker://registry.fedoraproject.org/fedora:latest | jq '.Digest'
# Output example: "sha256:068eea1e0ee1d0916fd80177e2cfd0b64022ab307061abbd2a1ef5bb30ac528c"
```

### Inspect a repository

```bash
skopeo inspect docker://registry.fedoraproject.org/fedora:latest
```

## FAQ

### 1. Permission error when copying images

**Solution**: Ensure your Docker configuration file (`~/.docker/config.json`) contains the correct authentication information and that the container can read the file.

### 2. Cannot connect to private registry

**Solution**: Use the `--dest-tls-verify=false` parameter to disable TLS verification (only use in test environments), or ensure your registry certificate is configured correctly.

### 3. Failed to copy multi-architecture images

**Solution**: Ensure the target registry supports multi-architecture images, or use the `--override-arch` parameter to specify a single architecture.

## Contributing

Issues and Pull Requests are welcome to improve this project.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.
