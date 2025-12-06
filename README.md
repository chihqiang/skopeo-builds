## ▶️ Usage Releases

~~~
wget -q --show-progress -O skopeo.tar.gz https://github.com/chihqiang/skopeo-builds/releases/download/v1.21.0/skopeo_darwin_arm64.tar.gz
tar -zxf skopeo.tar.gz 
./skopeo --version
~~~

## ▶️ Usage Docker

Build docker

~~~
docker build -t zhiqiangwang/skopeo:latest .
docker build --build-arg SKOPEO_VERSION=v1.21.0 -t zhiqiangwang/skopeo:1.21.0 .
~~~

Run Skopeo directly via Docker:

~~~
docker run --rm zhiqiangwang/skopeo:latest --version
~~~

Copy a container image:

```
docker run --rm \
  -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
  zhiqiangwang/skopeo:latest copy \
    --insecure-policy \
    --multi-arch=all \
    --dest-tls-verify=false \
    "docker://alpine:latest" \
    "docker://myregistry.local/alpine:latest"
```

If you only want to copy a **single architecture** (e.g., `linux/amd64`), use `--override-arch`:

```
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

Inspect an image:

```
docker run --rm  zhiqiangwang/skopeo:latest inspect docker://alpine:latest
```

Temporary entry container

~~~
docker run --rm -v $HOME/.docker/config.json:/root/.docker/config.json:ro -it --entrypoint bash zhiqiangwang/skopeo:latest
~~~
