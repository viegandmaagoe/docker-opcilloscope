IMAGE_NAME := opcilloscope
VERSION    := latest
REGISTRY   :=

ifdef REGISTRY
  FULL_IMAGE := $(REGISTRY)/$(IMAGE_NAME):$(VERSION)
else
  FULL_IMAGE := $(IMAGE_NAME):$(VERSION)
endif

.PHONY: build build-local run setup-buildx

## Build multi-platform image (linux/amd64 + linux/arm64) and push to registry
build: setup-buildx
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--tag $(FULL_IMAGE) \
		--push \
		.

## Build for the local machine architecture only (use for local testing)
build-local: setup-buildx
	docker buildx build \
		--platform linux/$$(docker system info --format '{{.Architecture}}' | sed 's/x86_64/amd64/;s/aarch64/arm64/') \
		--tag $(FULL_IMAGE) \
		--load \
		.

## Run interactively. Optionally pass OPC_SERVER=opc.tcp://host:port to connect on startup.
run:
	docker run --rm -it $(if $(OPC_SERVER),-e OPC_SERVER=$(OPC_SERVER)) $(FULL_IMAGE) $(ARGS)

## Ensure a multi-platform buildx builder is available
setup-buildx:
	@docker buildx inspect opcilloscope-builder > /dev/null 2>&1 || \
		docker buildx create --name opcilloscope-builder --use
	@docker buildx use opcilloscope-builder
