ARG TAG=latest
FROM kisiodigital/rust-ci:${TAG}

ARG DOCKER_VERSION="5:19.03.13~3-0~debian-buster"
ARG PROJ_VERSION="7.1.0"
ENV PROJ_DEB "proj_${PROJ_VERSION}_amd64.deb"
ENV GPG_KEY "C60D758F807A525534C5DFD57B639E3638A8112A"
# For building Rust's crate 'proj-sys', the following Debian packages are needed:
# - 'clang' provides 'llvm-config', 'libclang.so' and 'stddef.h' needed for compiling 'proj-sys'
# - 'proj' provides 'proj.h' and 'libproj.so', needed for compiling 'proj-sys'
# - 'libtiff5' provides 'libtiff.so', needed for linking when 'proj-sys' is used
# - 'libcurl3-nss' provides 'libcurl-nss.so', needed for linking when 'proj-sys' is used
#
# We also need to install docker
RUN BUILD_DEPENDENCIES="apt-transport-https ca-certificates gnupg2 wget curl gnupg-agent software-properties-common" \
	&& apt update \
	&& apt install --yes ${BUILD_DEPENDENCIES} \
	&& wget --quiet --output-document - "https://kisiodigital.jfrog.io/kisiodigital/api/gpg/key/public" | apt-key add - \
	&& echo "deb [arch=amd64] https://kisiodigital.jfrog.io/kisiodigital/debian-local stretch main" > /etc/apt/sources.list.d/kisio-digital.list \
	&& apt update \
	&& apt install --yes clang proj=${PROJ_VERSION} libtiff5 libcurl3-nss \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt update \
    && apt -y install docker-ce-cli=${DOCKER_VERSION} \
    && apt -y purge ${BUILD_DEPENDENCIES} \
	&& apt autoremove --yes \
	&& rm -rf /var/lib/apt/lists/*
