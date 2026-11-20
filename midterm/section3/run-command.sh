
#!/usr/bin/env bash
set -euo pipefail

# Run from the folder containing this script and the seccomp profile
cd "$(dirname "$0")"

docker run --rm -d \
  --name ia462-final-test \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --cap-drop=ALL \
  --security-opt no-new-privileges:true \
  --security-opt seccomp=seccomp-profile.json \
  -p 127.0.0.1:8000:8000 \
  ia462-hardened:1.0
