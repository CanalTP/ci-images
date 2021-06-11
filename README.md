# ci-images

This repository contains helpful Docker images for the CI with CanalTP's projects.

## Docker images

A few Docker images are available containing most of the useful tools to build
and verify projects.

### `kisiodigital/proj-ci:7.2.1-artifacts`

This Docker image provides pre-built artifacts for [proj] library,
based on a Debian stretch.

In order to use it in a multistage Docker image, you can do the following setup (make sure that clang is >=3.9).

```sh
FROM kisiodigital/proj-ci:7.2.1-artifacts as proj-artifacts

FROM debian:stretch

COPY --from=proj-artifacts /proj-artifacts /
ARG RUNTIME_DEPENDENCIES="pkg-config libtiff5 libcurl3-nss libsqlite3-0 clang" # or clang-3.9
RUN apt update \
    && apt install --yes ${RUNTIME_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
```

Do not forget to install the runtime dependencies on which the [proj] artifacts depend.

> For running `proj`, the following Debian packages are needed:
> - 'clang' provides 'llvm-config', 'libclang.so' and 'stddef.h' needed for compiling 'proj-sys' (clang >=3.9 needed by proj-sys)
> - 'pkg-config' needed by 'proj-sys' to find the installed version
> - 'libtiff5' provides 'libtiff.so', needed for linking when 'proj-sys' is used
> - 'libcurl3-nss' provides 'libcurl-nss.so', needed for linking when 'proj-sys' is used
> - 'libsqlite3-0' is used by proj to manage different projections definitions (EPSG)
> - 'proj' provides 'proj.h' and 'libproj.so', needed for compiling 'proj-sys' (installed manually below)

### `kisiodigital/proj-ci:7.2.1`

This Docker image provides all the binaries and libraries of the project [proj],
based on a Debian stretch.

### `kisiodigital/rust-ci:latest`

Based on Docker image Debian stretch, it provides the additional tools:

- [`rustup`]: setup for a functional Rust ecosystem
- [`rustfmt`]: auto-formatting of the Rust source code
- [`clippy`]: static linting of the Rust source code
- [`cargo-audit`]: cargo tool to report known CVE in the dependencies
- [`docker`]: docker engine

If you want to release this image with the latest version of Rust, just trigger the Jenkins job manually.
It is also possible to pin a specific Rust version by providing `--default-toolchain` param to
rustup-init script.

To know which version of Rust is embedded in the image, do the following:

```sh
docker run --rm kisiodigital/rust-ci:latest rustc --version
```

[`rustup`]: https://rustup.rs/
[`rustfmt`]: https://github.com/rust-lang/rustfmt
[`clippy`]: https://github.com/rust-lang/rust-clippy
[`cargo-audit`]: https://github.com/RustSec/cargo-audit
[`docker`]: https://www.docker.com/

#### Variant `kisiodigital/rust-ci:latest-proj7.2.1`

Based on Docker image `kisiodigital/rust-ci:latest`, it provides also the
[Proj] library, allowing to compile a Rust project with [`proj`]'s crate.

[proj]: https://github.com/OSGeo/PROJ
[`proj`]: https://crates.io/crates/proj
