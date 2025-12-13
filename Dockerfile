FROM ubuntu:22.04

ARG SKOPEO_VERSION=v1.21.0

ENV SKOPEO_VERSION=${SKOPEO_VERSION}

RUN apt-get update && apt-get install -y ca-certificates jq libterm-readline-perl-perl curl sudo wget \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

ADD install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh && bash /tmp/install.sh && rm -rf /tmp/install.sh

ENTRYPOINT ["/usr/local/bin/skopeo"]

CMD ["--version"]