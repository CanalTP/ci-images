ARG TAG=latest
FROM kisiodigital/proj-ci:7.2.1-stretch-artifacts as proj-artifacts
FROM kisiodigital/rust-ci:${TAG}

# For running `proj`, the following Debian packages are needed:
# - 'clang' provides 'llvm-config', 'libclang.so' and 'stddef.h' needed for compiling 'proj-sys'
# - 'libtiff5' provides 'libtiff.so', needed for linking when 'proj-sys' is used
# - 'libcurl3-nss' provides 'libcurl-nss.so', needed for linking when 'proj-sys' is used
# - 'proj' provides 'proj.h' and 'libproj.so', needed for compiling 'proj-sys' (installed manually below)
ARG RUNTIME_DEPENDENCIES="clang libtiff5 libcurl3-nss"
COPY --from=proj-artifacts /proj-artifacts /
RUN apt update \
    && apt install --yes ${RUNTIME_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
