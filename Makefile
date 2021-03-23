# used for building docker image only
DRY_RUN ?= false
ifneq (${DRY_RUN},true)
ifneq (${DRY_RUN},false)
$(error DRY_RUN must be 'true' or 'false')
endif
endif
PROJ_VERSION ?= 7.2.1

.PHONY: release_proj_artifacts
release_proj_artifacts: ## Release docker image kisiodigital/proj-ci:${PROJ_VERSION}-artifacts
	$(info > Build docker image kisiodigital/proj-ci:${PROJ_VERSION}-artifacts)
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) --tag ${PROJ_VERSION}-artifacts --stage builder proj

.PHONY: release_proj
release_proj: ## Release docker image kisiodigital/proj-ci:${PROJ_VERSION}
	$(info > Build docker image kisiodigital/proj-ci:${PROJ_VERSION})
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) --tag ${PROJ_VERSION} proj

.PHONY: release_rust
release_rust: ## Release docker image kisiodigital/rust-ci:latest
	$(info > Build docker image kisiodigital/rust-ci:latest)
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) rust

.PHONY: release_rust_proj
release_rust_proj: ## Release docker image kisiodigital/rust-ci:latest-proj${PROJ_VERSION}
	$(info > Build docker image kisiodigital/rust-ci:latest-proj)
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) --tag latest-proj${PROJ_VERSION} rust proj

.PHONY: release_tartare
release_tartare: ## Release docker image kisiodigital/tartare-ci:latest
	$(info > Build docker image kisiodigital/tartare-ci:latest)
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) tartare

.PHONY: help
help: ## Print this help message
	@grep -E '^[a-zA-Z_-]+:.*## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
