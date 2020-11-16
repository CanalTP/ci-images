# used for building docker image only
DRY_RUN ?= false
ifneq (${DRY_RUN},true)
ifneq (${DRY_RUN},false)
$(error DRY_RUN must be 'true' or 'false')
endif
endif

.PHONY: release_base
release_base: ## Release docker image kisiodigital/rust-ci:latest
	$(info > Build docker image kisiodigital/rust-ci:latest)
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) base

.PHONY: release_proj
release_proj: ## Release docker image kisiodigital/rust-ci:latest-proj
	$(info > Build docker image kisiodigital/rust-ci:latest-proj)
	@./release.sh $(if $(findstring true,${DRY_RUN}), --dry-run) proj

.PHONY: help
help: ## Print this help message
	@grep -E '^[a-zA-Z_-]+:.*## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
