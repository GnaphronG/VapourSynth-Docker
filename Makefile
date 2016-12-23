include utils.mk

SRC_DIR ?= ${PWD}/src
BUILD_DIR ?= ${PWD}/build
DOCKER_BUILD_ARGS += --force-rm --rm
BUILDCONTAINER := Dockerfile.build
BUILD_IMAGE := ${IMAGE}_build

.ONESHELL:
build: ## Contruct the build container and build the binaries and libraries
	mkdir -p ${BUILD_DIR}
	docker build -q ${DOCKER_BUILD_ARGS} -f ${BUILDCONTAINER} -t ${BUILD_IMAGE} .
	docker run --rm --id ${USER_ID}:${USER_GROUP} --volume ${SRC_DIR}:/usr/src --volume ${BUILD_DIR}:/usr/local ${BUILD_IMAGE} make all install

all: build run ## Build and Run the project docker image

image: ## Build the project Docker image named after the folder name
	docker build -t ${IMAGE} .

run: ## Run the project docker image and destroy the container after use
	docker run -it --rm --name ${IMAGE}_${TAG} --volume ${PWD}/src:/usr/src/myapp ${IMAGE}

shell: ## Run the project docker image and destroy the container after use
	docker run -it --rm --name ${IMAGE}_${TAG} --volume ${PWD}/src:/usr/src/myapp --entrypoint bash ${IMAGE}

.PHONY: all build run

