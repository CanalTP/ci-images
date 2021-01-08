FROM python:3.6.5-slim-stretch

ARG DOCKER_VERSION="5:19.03.13~3-0~debian-stretch"

RUN BUILD_DEPENDENCIES="apt-transport-https curl gnupg-agent software-properties-common" \
    && apt-get update \
    && apt-get --yes install \
        # used in docker_wrapper.py for waiting until a container is up (wiremock)
        wget \
        make \
        # used for precommit checks
        git \
        ca-certificates \
        ${BUILD_DEPENDENCIES} \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get -y install docker-ce-cli=${DOCKER_VERSION} \
    # install docker-compose for functional tests
    && curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && apt-get -y purge ${BUILD_DEPENDENCIES} \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# the virtual env has wide permissions since we don't know the user jenkins will use
ENV VIRTUAL_ENV=/tmp/venv
ENV MYPY_CACHE_DIR=/tmp/mypy
ENV PRE_COMMIT_HOME=/tmp/precommit
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN chmod -R a+rw ${VIRTUAL_ENV}
