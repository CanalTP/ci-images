ARG TAG=latest
FROM kisiodigital/rust-ci:${TAG}

ARG PROJ_VERSION="7.1.0"
ENV PROJ_DEB "proj_${PROJ_VERSION}_amd64.deb"
ENV GPG_KEY "C60D758F807A525534C5DFD57B639E3638A8112A"
# For building Rust's crate 'proj-sys', the following Debian packages are needed:
# - 'clang' provides 'llvm-config', 'libclang.so' and 'stddef.h' needed for compiling 'proj-sys'
# - 'proj' provides 'proj.h' and 'libproj.so', needed for compiling 'proj-sys'
# - 'libtiff5' provides 'libtiff.so', needed for linking when 'proj-sys' is used
# - 'libcurl3-nss' provides 'libcurl-nss.so', needed for linking when 'proj-sys' is used
RUN apt update \
	&& apt install --yes apt-transport-https gnupg2 wget \
	&& wget --quiet --output-document - "https://kisiodigital.jfrog.io/kisiodigital/api/gpg/key/public" | apt-key add - \
	&& echo "deb [arch=amd64] https://kisiodigital.jfrog.io/kisiodigital/debian-local stretch main" > /etc/apt/sources.list.d/kisio-digital.list \
	&& apt update \
	&& apt install --yes clang proj=${PROJ_VERSION} libtiff5 libcurl3-nss \
	&& apt purge --yes apt-transport-https gnupg2 wget \
	&& apt autoremove --yes \
	&& rm -rf /var/lib/apt/lists/*
