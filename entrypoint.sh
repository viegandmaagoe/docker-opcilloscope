#!/bin/sh
set -e

if [ -n "$OPC_SERVER" ] && [ "$#" -eq 0 ]; then
    CONFIG_FILE="$(mktemp /tmp/opcilloscope-XXXXXX.json)"
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > "$CONFIG_FILE" <<EOF
{
  "server": { "endpointUrl": "$OPC_SERVER" },
  "settings": { "publishingIntervalMs": 0, "samplingIntervalMs": 0 },
  "monitoredNodes": [],
  "metadata": { "createdAt": "$NOW", "lastModified": "$NOW" }
}
EOF
    exec /app/opcilloscope --config "$CONFIG_FILE"
fi

exec /app/opcilloscope "$@"
