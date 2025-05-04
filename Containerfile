FROM debian:bookworm-slim

LABEL org.opencontainers.image.description="Bitwarden CLI in a container"
LABEL org.opencontainers.image.authors="Bruno Bernard <brunobernard@duck.com>"

ENV BW_CLI_VERSION=2025.4.0 \
    DEBIAN_FRONTEND=noninteractive \
    HOME=/home/nonroot

RUN groupadd -r nonroot --gid=1000 && \
    useradd -r -g nonroot --uid=1000 -d ${HOME} nonroot && \
    mkdir -p ${HOME}/.config/"Bitwarden CLI" && \
    chown -R nonroot:nonroot ${HOME}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      wget \
      unzip \
      dumb-init \
      ca-certificates && \
    wget -q https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-linux-${BW_CLI_VERSION}.zip && \
    unzip bw-linux-${BW_CLI_VERSION}.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    apt-get purge -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* bw-linux-${BW_CLI_VERSION}.zip

COPY --chown=nonroot:nonroot entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER nonroot
WORKDIR ${HOME}

EXPOSE 8087

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint.sh"]
CMD ["bw", "serve", "--hostname", "0.0.0.0"]