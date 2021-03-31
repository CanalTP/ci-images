FROM debian:stretch-backports

# Generic tools
RUN apt update \
    && apt install --yes build-essential git-man/stretch-backports git/stretch-backports \
    && git --version \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo

# install rustup for all users (inspired by rust official image Dockerfile)
ENV PATH=/usr/local/cargo/bin:${PATH}
RUN apt update \
    && apt install --yes curl \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal \
    && chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME} \
    && rustup --version \
    && cargo --version \
    && rustc --version \
    && apt purge --yes curl \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# Rust tools
RUN rustup component add rustfmt clippy \
    && chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}

# 'libssl-dev' and 'pkg-config' are useful for compilation of Rust crate
# 'openssl-sys' which is used by 'cargo-audit'. Once compiled and installed,
# only the library 'libssl1.1' is needed.
ARG AUDIT_BUILD_DEPENDENCIES="libssl-dev pkg-config"
RUN apt update \
    && apt install --yes libssl1.1 ca-certificates ${AUDIT_BUILD_DEPENDENCIES}\
    && cargo install cargo-audit \
    && chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME} \
    && apt -y purge ${AUDIT_BUILD_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# we also install docker to be able to release the project on a docker registry
ARG DOCKER_BUILD_DEPENDENCIES="apt-transport-https curl gnupg-agent software-properties-common"
ARG DOCKER_VERSION="5:19.03.9~3-0~debian-stretch"
RUN apt update \
    && apt install --yes ${DOCKER_BUILD_DEPENDENCIES} \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt update \
    && apt -y install docker-ce-cli=${DOCKER_VERSION} \
    && add-apt-repository --remove "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt -y purge ${DOCKER_BUILD_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

ENV CARGO_HOME=/tmp/cargo
ENV CARGO_TARGET_DIR=/tmp/cargo-target
