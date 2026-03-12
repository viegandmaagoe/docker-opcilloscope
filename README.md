# opcilloscope (Docker)

A Docker wrapper around [opcilloscope](https://github.com/SquareWaveSystems/opcilloscope) — a terminal-based OPC UA client for browsing and monitoring industrial automation data.

Builds multi-platform images for **Apple Silicon (linux/arm64)** and **Intel x86 (linux/amd64)**.

## Build

### Local machine only (for testing)

```bash
make build-local
```

### Multi-platform image (requires push to a registry)

Set your registry and push:

```bash
make build REGISTRY=your.registry.io/namespace
```

Or push to Docker Hub:

```bash
make build REGISTRY=docker.io/yourusername
```

## Run

### Interactive (enter server URL in the UI)

```bash
docker run --rm -it opcilloscope
```

### With a connection string

Pass the OPC UA endpoint via the `OPC_SERVER` environment variable to connect automatically on startup:

```bash
docker run --rm -it -e OPC_SERVER=opc.tcp://192.168.1.100:4840 opcilloscope
```

### With a config file

Mount a saved `.json` config and pass it as an argument:

```bash
docker run --rm -it -v "$PWD/myconfig.json:/config.json" opcilloscope --config /config.json
```

### Test with a public server

```bash
docker run --rm -it -e OPC_SERVER=opc.tcp://milo.digitalpetri.com:62541/milo opcilloscope
docker run --rm -it -e OPC_SERVER=opc.tcp://opcuaserver.com:48010 opcilloscope
```

## Connecting to an OPC UA server

1. Launch the container (with or without `OPC_SERVER`)
2. If no env var is set, enter the endpoint URL in the UI (`opc.tcp://<host>:<port>[/path]`)
3. The address space tree loads on the left — navigate with arrow keys
4. Press **Enter** on a node to subscribe; **Delete** to unsubscribe

### Network access

If your OPC UA server runs on the **host machine**:

```bash
docker run --rm -it --network host -e OPC_SERVER=opc.tcp://localhost:4840 opcilloscope
```

If your OPC UA server is on a **remote host**, no special networking is needed — just set `OPC_SERVER` to the full endpoint URL.

## Keyboard shortcuts

| Key      | Action                        |
|----------|-------------------------------|
| Enter    | Subscribe to selected node    |
| Delete   | Unsubscribe                   |
| S        | Oscilloscope view (up to 5 signals, 30s window) |
| T        | Trend plot (single signal)    |
| W        | Write value to node           |
| Ctrl+R   | Toggle CSV recording          |
| +/-      | Zoom in/out (scope view)      |
| ?        | Help menu                     |

## CSV export

Recorded CSV files are written inside the container at the working directory. Mount a host directory to persist them:

```bash
docker run --rm -it -v "$PWD/data:/app/data" opcilloscope
```

Then use `Ctrl+R` inside the app to start/stop recording.
