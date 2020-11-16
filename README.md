# rust-ci

This repository contains helpful tools for the CI with CanalTP's Rust projects.

## Docker images

A few Docker images are available containing most of the useful tools to build
and verify Rust projects.

### `kisiodigital/rust-ci:latest`

Based on Docker image `rust`, it provides the additional tools:

- [`rustfmt`]: auto-formatting of the Rust source code
- [`clippy`]: static linting of the Rust source code

[`rustfmt`]: https://github.com/rust-lang/rustfmt
[`clippy`]: https://github.com/rust-lang/rust-clippy

### `kisiodigital/rust-ci:proj-latest`

Based on Docker image `kisiodigital/rust-ci:latest`, it provides also the
[Proj] library, allowing to compile a Rust project with [`proj`]'s crate.

[proj]: https://github.com/OSGeo/PROJ
[`proj`]: https://crates.io/crates/proj
