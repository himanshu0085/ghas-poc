FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl jq git

# Install GitHub CLI
RUN type -p curl >/dev/null || apt-get install curl -y
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install gh -y

WORKDIR /app

COPY scan.sh /app/scan.sh
RUN chmod +x /app/scan.sh

ENTRYPOINT ["/app/scan.sh"]
