# ci-images

This repository contains helpful Docker images for the CI with CanalTP's projects.

## Docker images

A few Docker images are available containing most of the useful tools to build
and verify projects.

### `kisiodigital/proj-ci:7.2.1-stretch-artifacts`

This Docker image provides pre-built artifacts for [proj] library,
based on a Debian stretch.

In order to use it in a multistage Docker image, you can do the following setup.

```
FROM kisiodigital/proj-ci:7.2.1-stretch-artifacts as proj-artifacts

FROM debian:stretch

COPY --from=proj-artifacts /proj-artifacts /
ENV RUNTIME_DEPENDENCIES="clang libtiff5 libcurl3-nss"
RUN apt update \
    && apt install --yes ${RUNTIME_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
```

Do not forget to install the runtime dependencies on which the [proj] artifacts depend.

### `kisiodigital/proj-ci:7.2.1-stretch`

This Docker image provides all the binaries and libraries of the project [proj].

### `kisiodigital/rust-ci:latest`

Based on Docker image Debian stretch, it provides the additional tools:

- [`rustup`]: setup for a functional Rust ecosystem
- [`rustfmt`]: auto-formatting of the Rust source code
- [`clippy`]: static linting of the Rust source code
- [`cargo-audit`]: cargo tool to report known CVE in the dependencies
- [`docker`]: docker engine

[`rustup`]: https://rustup.rs/
[`rustfmt`]: https://github.com/rust-lang/rustfmt
[`clippy`]: https://github.com/rust-lang/rust-clippy
[`cargo-audit`]: https://github.com/RustSec/cargo-audit
[`docker`]: https://www.docker.com/

#### Variant `kisiodigital/rust-ci:latest-proj`

Based on Docker image `kisiodigital/rust-ci:latest`, it provides also the
[Proj] library, allowing to compile a Rust project with [`proj`]'s crate.

[proj]: https://github.com/OSGeo/PROJ
[`proj`]: https://crates.io/crates/proj
