FROM rust:1.50-slim-buster

# Generic tools
RUN apt update \
    && apt install --yes make git \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# For Rust
RUN rustup component add rustfmt clippy
# 'libssl-dev' and 'pkg-config' are useful for compilation of Rust crate
# 'openssl-sys' which is used by 'cargo-audit'. Once compiled and installed,
# only the library 'libssl1.1' is needed.

ARG AUDIT_BUILD_DEPENDENCIES="libssl-dev pkg-config"
RUN apt update \
    && apt install --yes libssl1.1 ca-certificates ${AUDIT_BUILD_DEPENDENCIES}\
    && cargo install cargo-audit \
    && apt -y purge ${AUDIT_BUILD_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*git 

# we also install docker to be able to release the project on a docker registry
ARG DOCKER_BUILD_DEPENDENCIES="apt-transport-https curl gnupg-agent software-properties-common"
ARG DOCKER_VERSION="5:20.10.3~3-0~debian-buster"
RUN apt update \
    && apt install --yes ${DOCKER_BUILD_DEPENDENCIES} \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt update \
    && apt -y install docker-ce-cli=${DOCKER_VERSION} \
    && apt -y purge ${DOCKER_BUILD_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*git 

ENV CARGO_HOME=/tmp/cargo
ENV CARGO_TARGET_DIR=/tmp/cargo-target
