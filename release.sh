#!/usr/bin/env bash
HELP="./release.sh <image> [<variant>]

This script builds and pushes a Docker image named \`<image>-ci:latest\` using \`./<image>/Dockerfile\`.

If \`<variant>\` is present, the image is named \`<image>-ci:latest-<variant>\` using \`<image>/<variant>/Dockerfile\`."

Error() {
    echo "error: ${1}"
    exit 1
}

script_path=$(dirname "${BASH_SOURCE[0]}")
DOCKER_NAMESPACE='kisiodigital'

DRY_RUN='false'
while [[ ${#} -gt 0 ]]; do
    case "${1}" in
    '-d' | '--dry-run') DRY_RUN='true' ;;
	'-h' | '--help') echo "${HELP}" && exit 0 ;;
    *) if [[ "${1}" =~ ^- ]]; then
           Error "flag ${1} is unknown, the only recognized flag is '--dry-run (-d)'"
       else
           if [[ -z "${IMAGE}" ]]; then
               IMAGE="${1}"
           elif [[ -z "${IMAGE_VARIANT}" ]]; then
               IMAGE_VARIANT="${1}"
           else
               Error "only one image's variant is accepted, '${IMAGE_VARIANT}' already given, '${1}' is incompatible"
           fi
       fi ;;
    esac
    shift 1
done

if [[ -z "${IMAGE}" ]]; then
    Error "one image must be given as parameter, none was given"
fi

[ "${DRY_RUN}" = 'true' ] && echo "dry-run activated! The docker image will not be pushed."

# [ -n "$(git status --untracked-files=no --porcelain)" ] && Error "git status is not clean, build aborted"

# step 0: prepare docker image name with registry and tag
# get the tag from git
TAG=$(git describe --tags --abbrev=0 2> /dev/null)
HAS_TAG=$(git tag --list --points-at HEAD)
[ -z "${HAS_TAG}" ] && TAG='latest'
[ -z "${TAG}" ] && Error "impossible to get a tag"

# step 1: build docker images for git HEAD
if [[ -z "${IMAGE_VARIANT}" ]]; then
	DOCKERFILE_PATH="./${IMAGE}/"
    IMAGE_FULLNAME="${DOCKER_NAMESPACE}/${IMAGE}-ci:${TAG}"
    BUILD_ARG=''
else
	DOCKERFILE_PATH="./${IMAGE}/${IMAGE_VARIANT}"
    IMAGE_FULLNAME="${DOCKER_NAMESPACE}/${IMAGE}-ci:${TAG}-${IMAGE_VARIANT}"
    BUILD_ARG="--build-arg TAG=${TAG}"
fi
echo "Building $IMAGE_FULLNAME"
docker build --pull --no-cache --force-rm ${BUILD_ARG} --tag "${IMAGE_FULLNAME}" "${DOCKERFILE_PATH}"

# step 2: push the image to the registry
if [ "${DRY_RUN}" = 'false' ]; then
    echo "pushing '${IMAGE_FULLNAME}'"
    docker push "${IMAGE_FULLNAME}" || Error "pushing ${IMAGE} failed"
fi

exit 0
