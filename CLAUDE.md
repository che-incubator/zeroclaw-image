# ZeroClaw DevWorkspace Image

## What this is

A container image project that wraps the official distroless ZeroClaw binary (`ghcr.io/zeroclaw-labs/zeroclaw`) into a UBI9-minimal base with bash and coreutils. This makes it compatible with Eclipse Che / Red Hat DevSpaces, where DevWorkspace Operator needs to exec into containers.

## Architecture

Multi-stage Dockerfile:
1. **Stage 1** (`zeroclaw`): official distroless image — source of the `zeroclaw` binary at `/usr/local/bin/zeroclaw`
2. **Stage 2** (`ubi9-minimal`): runtime base with bash, coreutils, procps — copies the binary in

The image runs as non-root (`USER 1001`) with group 0 write permissions on `/home/user` for OpenShift arbitrary UID compatibility.

## Key paths

- `/usr/local/bin/zeroclaw` — the zeroclaw binary
- `/home/user/.zeroclaw/data` — data directory (`ZEROCLAW_DATA_DIR`)
- `/home/user` — home directory (`HOME`)
- Port `42617` — gateway server (`ZEROCLAW_GATEWAY_PORT`)

## Build

```bash
make build                    # local build
make push                     # build + push
make build IMAGE=foo TAG=bar  # custom image/tag
```

## Upstream tracking

The `FROM ghcr.io/zeroclaw-labs/zeroclaw:latest` tag floats. Pin to a specific tag or SHA when stability matters. Check available tags:
```bash
skopeo list-tags docker://ghcr.io/zeroclaw-labs/zeroclaw
```

## Related

- Devfile stack using this image: `devfile/registry` repo, `stacks/zeroclaw/`
- Official ZeroClaw repo: https://github.com/zeroclaw-labs/zeroclaw
