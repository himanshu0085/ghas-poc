FROM ubuntu:22.04

# --------------------------
# Install dependencies for all languages
# --------------------------
RUN apt-get update && apt-get install -y \
    curl unzip git tar jq bash \
    python3 python3-pip \
    openjdk-11-jdk \
    golang \
    && rm -rf /var/lib/apt/lists/*

# Ensure "python" command exists (CodeQL extractor expects it)
RUN ln -sf /usr/bin/python3 /usr/bin/python

# --------------------------
# 📌 Download CodeQL bundle automatically
# --------------------------
ARG CODEQL_VERSION=v2.23.6
RUN curl -L \
    -o /tmp/codeql.tar.gz \
    https://github.com/github/codeql-action/releases/download/codeql-bundle-${CODEQL_VERSION}/codeql-bundle-linux64.tar.gz \
    && mkdir -p /opt/codeql \
    && tar -xzf /tmp/codeql.tar.gz -C /opt/codeql --strip-components=1 \
    && rm /tmp/codeql.tar.gz

# Add CodeQL CLI to PATH
ENV PATH="/opt/codeql:/opt/codeql/codeql:/opt/codeql/bin:${PATH}"

# Working directory inside container
WORKDIR /scan

ENTRYPOINT ["/bin/bash"]
