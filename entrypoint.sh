#!/bin/bash
mkdir -p ~/.zeroclaw
cp -n /etc/zeroclaw/config.yaml ~/.zeroclaw/config.yaml 2>/dev/null || true
exec zeroclaw "$@"
