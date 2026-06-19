# ZeroClaw — thin wrapper for DevWorkspace
#
# The official ZeroClaw image is distroless (no shell, no coreutils).
# This wrapper adds a minimal shell environment so the image works
# inside Eclipse Che / DevSpaces DevWorkspaces, where DWO needs to
# exec into containers, run devfile commands, and open terminals.
#
# Official image: ghcr.io/zeroclaw-labs/zeroclaw
# Repo: https://github.com/zeroclaw-labs/zeroclaw
#
# Build:
#   docker buildx build --platform linux/amd64 \
#     -t quay.io/che-incubator/zeroclaw:next --push .
#
# Or single-arch:
#   docker build -t quay.io/che-incubator/zeroclaw:next .

FROM ghcr.io/zeroclaw-labs/zeroclaw:latest AS zeroclaw

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

COPY --from=zeroclaw /usr/local/bin/zeroclaw /usr/local/bin/zeroclaw

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

ENTRYPOINT ["zeroclaw"]
CMD ["daemon"]
