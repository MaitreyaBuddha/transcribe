
USERNAME_OR_ORG=$(shell git config --get remote.origin.url | sed -n 's/.*github.com[:\/]\(.*\)\/.*/\1/p')
REPO_NAME=$(shell basename -s .git `git config --get remote.origin.url`)
BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD)
SHORT_SHA=$(shell git rev-parse --short=4 HEAD)
IMAGE_PRE=ghcr.io/${USERNAME_OR_ORG}/$(REPO_NAME):$(BRANCH_NAME)
IMAGE_TAG=$(shell echo ${IMAGE_PRE} | tr '[:upper:]' '[:lower:]')
IMAGE_TAG_SHA=${IMAGE_TAG}-$(SHORT_SHA)


build:
	@echo "Building Docker image with tags: $(IMAGE_TAG) and $(IMAGE_TAG_SHA)"
	@docker build . \
	--tag $(IMAGE_TAG) \
	--tag $(IMAGE_TAG_SHA)

push:
	@echo "Pushing Docker images..."
	@docker push \
	--all-tags ghcr.io/$(REPO_NAME)

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--volume "$(PWD)":/workspace \
		--workdir /workspace \
		$(IMAGE_TAG) \
		bash

.PHONY: build
