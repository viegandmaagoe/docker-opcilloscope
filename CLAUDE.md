# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Docker wrapper that builds multi-platform images (linux/amd64 + linux/arm64) of [opcilloscope](https://github.com/SquareWaveSystems/opcilloscope) — a .NET 10 terminal UI OPC UA client. The source code is cloned from the upstream repo at image build time; no application source lives here.

## Commands

```bash
make build-local       # Build image for the local machine arch (--load, for testing)
make build REGISTRY=… # Build multi-platform and push to a registry
make run               # docker run --rm -it opcilloscope
```

Override image name/version: `make build IMAGE_NAME=foo VERSION=1.2`

## Architecture

- **Dockerfile** — two-stage build: `mcr.microsoft.com/dotnet/sdk:10.0` clones and publishes the upstream repo as a self-contained binary; `debian:bookworm-slim` is the runtime layer with `libicu72`
- **Makefile** — wraps `docker buildx`; `setup-buildx` creates a named builder (`opcilloscope-builder`) on first use; `build` requires `--push` because multi-platform images cannot be loaded locally
- **TARGETARCH mapping** — Docker's `amd64` is mapped to .NET RID `linux-x64`; `arm64` stays `linux-arm64`

## Key notes

- The container is an interactive TUI; always run with `-it`
- For CSV export persistence, mount a volume: `-v "$PWD/data:/app/data"`
- To reach an OPC UA server on the host: `--network host`
