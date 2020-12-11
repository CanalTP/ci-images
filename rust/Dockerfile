FROM rust:1.48-slim-buster

# Generic building tools
RUN apt update \
	&& apt install --yes make \
	&& apt autoremove --yes \
	&& rm -rf /var/lib/apt/lists/*

# For Rust
RUN rustup component add rustfmt clippy
# 'libssl-dev' and 'pkg-config' are useful for compilation of Rust crate
# 'openssl-sys' which is used by 'cargo-audit'. Once compiled and installed,
# only the library 'libssl1.1' is needed.
# we also install docker to be able to release the project on a docker registry

ARG DOCKER_VERSION="5:19.03.13~3-0~debian-buster"
RUN BUILD_DEPENDENCIES="apt-transport-https curl gnupg-agent software-properties-common libssl-dev pkg-config" \
	&& apt update \
	&& apt install --yes libssl1.1 ca-certificates ${BUILD_DEPENDENCIES}\
	&& cargo install cargo-audit \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt update \
    && apt -y install docker-ce-cli=${DOCKER_VERSION} \
    && apt -y purge ${BUILD_DEPENDENCIES} \
	&& apt autoremove --yes \
	&& rm -rf /var/lib/apt/lists/*
ENV CARGO_HOME=/tmp/cargo
ENV CARGO_TARGET_DIR=/tmp/cargo-target
