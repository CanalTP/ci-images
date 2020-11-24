FROM rust:1.48-slim-buster

ENV CARGO_TARGET_DIR=/tmp/cargo-target
RUN rustup component add rustfmt clippy
# 'libssl-dev' and 'pkg-config' are useful for compilation of Rust crate
# 'openssl-sys' which is used by 'cargo-audit'. Once compiled and installed,
# only the library 'libssl1.1' is needed.
RUN apt update \
	&& apt install --yes libssl1.1 libssl-dev pkg-config \
	&& cargo install cargo-audit \
	&& apt purge --yes libssl-dev pkg-config \
	&& apt autoremove --yes \
	&& rm -rf /var/lib/apt/lists/*
