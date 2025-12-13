# Usage Releases

~~~bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chihqiang/skopeo-builds/refs/heads/main/install.sh)"
~~~

## Usage Docker

Build docker

~~~bash
docker build -t zhiqiangwang/skopeo:latest .
~~~

Run Skopeo directly via Docker:

~~~bash
docker run --rm zhiqiangwang/skopeo:latest --version
~~~

Copy a container image:

~~~bash
docker run --rm \
  -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
  zhiqiangwang/skopeo:latest copy \
    --insecure-policy \
    --multi-arch=all \
    --dest-tls-verify=false \
    "docker://alpine:latest" \
    "docker://myregistry.local/alpine:latest"
~~~

If you only want to copy a **single architecture** (e.g., `linux/amd64`), use `--override-arch`:

~~~bash
docker run --rm \
  -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
  zhiqiangwang/skopeo:latest copy \
    --insecure-policy \
    --override-arch=amd64 \
    --override-os=linux \
    --dest-tls-verify=false \
    "docker://alpine:latest" \
    "docker://myregistry.local/alpine:amd64"
~~~

## Inspect an image:

~~~bash
docker run --rm  zhiqiangwang/skopeo:latest inspect docker://alpine:latest
~~~

## Temporary entry container

~~~bash
docker run --rm -v $HOME/.docker/config.json:/root/.docker/config.json:ro -it --entrypoint bash zhiqiangwang/skopeo:latest
~~~

## Deleting images

~~~bash
skopeo delete docker://localhost:5000/imagename:latest
~~~

## Syncing registries

~~~bash
skopeo sync --src docker --dest dir registry.example.com/busybox /media/usb
~~~

## Show unverified image's digest

~~~bash
skopeo inspect docker://registry.fedoraproject.org/fedora:latest | jq '.Digest'
"sha256:068eea1e0ee1d0916fd80177e2cfd0b64022ab307061abbd2a1ef5bb30ac528c"
~~~

## Inspecting a repository

~~~bash
skopeo inspect docker://registry.fedoraproject.org/fedora:latest
~~~
