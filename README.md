# ZeroClaw DevWorkspace Image

A thin wrapper around the official [ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw) distroless image, adding a minimal shell environment for use in Eclipse Che / Red Hat DevSpaces.

## Why

The official `ghcr.io/zeroclaw-labs/zeroclaw` image is distroless — no shell, no coreutils. DevWorkspace Operator needs to `exec` into containers to run devfile commands, open terminals, and inject tools. This image copies the `zeroclaw` binary into a UBI9-minimal base that provides `bash` and basic utilities.

## Build

```bash
# Multi-arch
docker buildx build --platform linux/amd64,linux/arm64 \
  -t quay.io/che-incubator/zeroclaw-image:next --push .

# Single-arch
docker build -t quay.io/che-incubator/zeroclaw-image:next .
```

## Usage

**Note:** This image is intended for the ZeroClaw devfile sample in the [devfile registry](https://github.com/devfile/registry) (not yet merged — see `stacks/zeroclaw/`).

```yaml
components:
  - name: zeroclaw
    container:
      image: quay.io/che-incubator/zeroclaw-image:next
```

## Base images

- **ZeroClaw binary**: `ghcr.io/zeroclaw-labs/zeroclaw:latest`
- **Runtime base**: `registry.access.redhat.com/ubi9/ubi-minimal:latest`
