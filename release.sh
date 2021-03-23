#!/usr/bin/env bash
HELP="./release.sh <image> [<variant>]
    -d | --dry-run         build but do not push docker images to the registry
    -p | --proj-version    version of proj dependency
    -h | --help            display this help message
    -t | --tag             specify the tag of the Docker image (default: 'latest' or 'latest-variant')
    -s | --stage           specify an intermediate Docker stage to release (default: to latest stage)

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
    '-t' | '--tag') shift 1;
        TAG="${1}" ;;
    '-s' | '--stage') shift 1 ;
        STAGE="${1}" ;;
    '-d' | '--dry-run') DRY_RUN='true' ;;
    '-p' | '--proj-version') shift 1;
    	PROJ_VERSION="${1}" ;;
    '-h' | '--help') echo "${HELP}" && exit 0 ;;
    *) if [[ "${1}" =~ ^- ]]; then
           Error "flag ${1} is unknown"
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
# get the tag from git, only if not already specified (see '--tag' option)
[ -z "${TAG}" ] && TAG=$(git describe --tags --abbrev=0 2> /dev/null)
[ -z "${TAG}" ] && TAG=latest

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
if [[ ! -z "${STAGE}" ]]; then
    BUILD_ARG="${BUILD_ARG} --target ${STAGE}"
fi
if [[ ! -z "${PROJ_VERSION}" ]]; then
    BUILD_ARG="${BUILD_ARG} --build-arg ${PROJ_VERSION}"
fi
echo "Building $IMAGE_FULLNAME"
docker build --pull --no-cache --force-rm ${BUILD_ARG} --tag "${IMAGE_FULLNAME}" "${DOCKERFILE_PATH}"

# step 2: push the image to the registry
if [ "${DRY_RUN}" = 'false' ]; then
    echo "pushing '${IMAGE_FULLNAME}'"
    docker push "${IMAGE_FULLNAME}" || Error "pushing ${IMAGE} failed"
fi

exit 0
