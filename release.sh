#!/usr/bin/env bash

Error() {
    echo "error: ${1}"
    exit 1
}

script_path=$(dirname "${BASH_SOURCE[0]}")
DOCKER_NAMESPACE='kisiodigital'
IMAGE='rust-ci'

DRY_RUN='false'
while [[ ${#} -gt 0 ]]; do
    case "${1}" in
    '-d' | '--dry-run') DRY_RUN='true' ;;
    *) if [[ "${1}" =~ ^- ]]; then
           Error "flag ${1} is unknown, the only recognized flag is '--dry-run (-d)'"
       else
           if [[ -z "${IMAGE_VARIANT}" ]]; then
               IMAGE_VARIANT="$1"
           else
               Error "only one image's variant is accepted, '${IMAGE_VARIANT}' already given, '${1}' is incompatible"
           fi
       fi ;;
    esac
    shift 1
done

if [[ -z "${IMAGE_VARIANT}" ]]; then
    IMAGE_VARIANT="base"
fi

[ "${DRY_RUN}" = 'true' ] && echo "dry-run activated! The docker image will not be pushed."

[ -n "$(git status --untracked-files=no --porcelain)" ] && Error "git status is not clean, build aborted"

# step 0: prepare docker image name with registry and tag
# get the tag from git
TAG=$(git describe --tags --abbrev=0 2> /dev/null)
HAS_TAG=$(git tag --list --points-at HEAD)
[ -z "${HAS_TAG}" ] && TAG='latest'
[ -z "${TAG}" ] && Error "impossible to get a tag"

if [[ "${IMAGE_VARIANT}" != "base" ]]; then
    TAG="${TAG}-${IMAGE_VARIANT}"
fi

# step 1: build docker images for git HEAD
IMAGE_FULLNAME="${DOCKER_NAMESPACE}/${IMAGE}:${TAG}"
echo "Building $IMAGE_FULLNAME"
docker build --pull --no-cache --force-rm -t "${IMAGE_FULLNAME}" "${IMAGE_VARIANT}"

# step 2: push the image to the registry
if [ "${DRY_RUN}" = 'false' ]; then
    echo "pushing '${IMAGE_FULLNAME}'"
    docker push "${IMAGE_FULLNAME}" || Error "pushing ${IMAGE} failed"
fi

exit 0
