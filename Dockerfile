# ZeroClaw — thin wrapper for DevWorkspace
#
# The official ZeroClaw image is distroless (no shell, no coreutils)
# and ships without the web dashboard frontend.
# This wrapper:
#   1. Extracts the binary and pre-built dashboard from the release tarball
#   2. Adds a shell environment (UBI9-minimal)
#
# Official image: ghcr.io/zeroclaw-labs/zeroclaw
# Repo: https://github.com/zeroclaw-labs/zeroclaw
#
# Build:
#   docker buildx build --platform linux/amd64 \
#     -t quay.io/che-incubator/zeroclaw-image:next --push .
#
# Or single-arch:
#   docker build -t quay.io/che-incubator/zeroclaw-image:next .

ARG ZEROCLAW_VERSION=v0.8.1

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest AS release

ARG ZEROCLAW_VERSION
ARG TARGETARCH=amd64

RUN microdnf install -y --nodocs tar gzip && microdnf clean all

RUN curl -sL https://github.com/zeroclaw-labs/zeroclaw/releases/download/${ZEROCLAW_VERSION}/zeroclaw-x86_64-unknown-linux-gnu.tar.gz \
    | tar xz -C /tmp

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

RUN microdnf install -y --nodocs \
        bash \
        coreutils-single \
        procps-ng \
        findutils \
        tar \
        gzip \
        shadow-utils \
        ca-certificates \
    && microdnf clean all

COPY --from=release /tmp/zeroclaw /usr/local/bin/zeroclaw
COPY --from=release /tmp/web/dist /usr/local/share/zeroclaw/web/dist
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENV HOME=/home/user \
    ZEROCLAW_DATA_DIR=/home/user/.zeroclaw/data \
    ZEROCLAW_GATEWAY_PORT=42617 \
    LANG=C.UTF-8

RUN mkdir -p /home/user/.zeroclaw && \
    chgrp -R 0 /home/user && \
    chmod -R g=u /home/user

WORKDIR /home/user

USER 1001

EXPOSE 42617

ENTRYPOINT ["entrypoint.sh"]
CMD ["daemon"]
