FROM debian:stretch as builder

ARG PROJ_VERSION="7.2.1"

# For running `proj`, the following Debian packages are needed:
# - 'clang' provides 'llvm-config', 'libclang.so' and 'stddef.h' needed for compiling 'proj-sys'
# - 'libtiff5' provides 'libtiff.so', needed for linking when 'proj-sys' is used
# - 'libcurl3-nss' provides 'libcurl-nss.so', needed for linking when 'proj-sys' is used
# - 'proj' provides 'proj.h' and 'libproj.so', needed for compiling 'proj-sys' (installed manually below)
ARG RUNTIME_DEPENDENCIES="clang libtiff5 libcurl3-nss"

# For building `libproj' and the Rust's crate `proj-sys`, the following Debian packages are needed:
ENV BUILD_DEPENDENCIES="libcurl4-nss-dev libsqlite3-dev libtiff5-dev cmake pkg-config sqlite3 wget"
RUN apt update \
    && apt install --yes ${BUILD_DEPENDENCIES} ${RUNTIME_DEPENDENCIES} \
    && wget https://github.com/OSGeo/PROJ/releases/download/${PROJ_VERSION}/proj-${PROJ_VERSION}.tar.gz \
    && tar -xzvf proj-${PROJ_VERSION}.tar.gz \
    && mv proj-${PROJ_VERSION} /tmp/proj-src \
    && cd /tmp/proj-src \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make DESTDIR=/proj-artifacts install \
    && rm -fr /tmp/proj-src \
    && apt purge --yes ${BUILD_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

FROM debian:stretch
ARG RUNTIME_DEPENDENCIES
COPY --from=builder /proj-artifacts /
RUN apt update \
    && apt install --yes ${RUNTIME_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
