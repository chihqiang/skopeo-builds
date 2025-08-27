# =====================
# 构建阶段
# =====================
FROM golang:1.23-alpine AS builder

# 安装最小构建依赖
RUN apk update && apk add gpgme btrfs-progs-dev llvm15-dev gcc musl-dev wget

ARG SKOPEO_VERSION=v1.20.0

RUN cd /tmp \
    && wget https://github.com/containers/skopeo/archive/refs/tags/${SKOPEO_VERSION}.tar.gz -O skopeo.tar.gz \
    && mkdir /tmp/skopeo \
    && tar -xf skopeo.tar.gz -C /tmp/skopeo --strip-components=1 \
    && cd /tmp/skopeo \
    && CGO_ENABLE=0 GO111MODULE=on GOOS=linux go build -mod=vendor '-buildmode=pie' -ldflags '-extldflags -static' -gcflags '' -tags 'exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp' -o /skopeo ./cmd/skopeo

# =====================
# 运行阶段
# =====================
FROM ubuntu:22.04

# 安装运行时依赖
RUN apt-get update && apt-get install -y ca-certificates jq && rm -rf /var/lib/apt/lists/*

# 拷贝静态二进制
COPY --from=builder /skopeo /usr/bin/skopeo
RUN chmod +x /usr/bin/skopeo

# 默认入口
ENTRYPOINT ["/usr/bin/skopeo"]
CMD ["--version"]