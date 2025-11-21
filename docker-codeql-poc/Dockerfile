FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl unzip git jq bash && \
    rm -rf /var/lib/apt/lists/*

# Install CodeQL CLI
RUN curl -L -o codeql.zip https://github.com/github/codeql-cli-binaries/releases/latest/download/codeql-linux64.zip \
    && unzip codeql.zip -d /opt \
    && rm codeql.zip

ENV PATH="/opt/codeql:/opt/codeql/codeql:${PATH}"

WORKDIR /scan

ENTRYPOINT ["/bin/bash"]
