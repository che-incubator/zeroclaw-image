#!/bin/bash
zeroclaw config set gateway.web_dist_dir /usr/local/share/zeroclaw/web/dist 2>/dev/null || true
exec zeroclaw "$@"
