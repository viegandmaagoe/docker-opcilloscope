FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS build

ARG TARGETARCH

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/SquareWaveSystems/opcilloscope.git .

RUN DOTNET_RID=$([ "$TARGETARCH" = "amd64" ] && echo "linux-x64" || echo "linux-arm64") && \
    dotnet publish Opcilloscope.csproj \
        -c Release \
        -r $DOTNET_RID \
        --self-contained true \
        -o /app


FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends libncursesw6 libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
