FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    adb unzip coreutils ca-certificates && rm -rf /var/lib/apt/lists/*
COPY install.sh /usr/local/bin/install-original.sh
RUN chmod +x /usr/local/bin/install-original.sh
ENTRYPOINT ["/usr/local/bin/install-original.sh"]
