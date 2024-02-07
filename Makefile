
USERNAME_OR_ORG=$(shell git config --get remote.origin.url | sed -n 's/.*github.com[:\/]\(.*\)\/.*/\1/p')
REPO_NAME=$(shell basename -s .git `git config --get remote.origin.url`)
IMAGE_REPO=ghcr.io/${USERNAME_OR_ORG}/$(REPO_NAME)
BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD)
IMAGE_PRE=${IMAGE_REPO}:$(BRANCH_NAME)
IMAGE_TAG=$(shell echo ${IMAGE_PRE} | tr '[:upper:]' '[:lower:]')
SHORT_SHA=$(shell git rev-parse --short=4 HEAD)
IMAGE_TAG_SHA=${IMAGE_TAG}-$(SHORT_SHA)


build:
	@echo "Building Docker image with tags: $(IMAGE_TAG) and $(IMAGE_TAG_SHA)"
	@docker build . \
	--tag $(IMAGE_TAG) \
	--tag $(IMAGE_TAG_SHA)

push:
	@echo "Pushing Docker images..."
	@docker push ${IMAGE_TAG}

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
