ARG TAG=latest
ARG PROJ_VERSION=7.2.1
FROM kisiodigital/proj-ci:${PROJ_VERSION}-artifacts as proj-artifacts
FROM kisiodigital/rust-ci:${TAG}

ARG RUNTIME_DEPENDENCIES="clang libclang1-3.9 pkg-config libtiff5 libcurl3-nss libsqlite3-0"
COPY --from=proj-artifacts /proj-artifacts /
RUN apt update \
    && apt install --yes curl ${RUNTIME_DEPENDENCIES} \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
