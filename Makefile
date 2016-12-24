include utils.mk

SRC_DIR ?= ${PWD}/src
BUILD_DIR ?= ${PWD}/build
DOCKER_BUILD_ARGS += --force-rm --rm
BUILDCONTAINER := Dockerfile.build
BUILD_IMAGE := ${IMAGE}_build

.ONESHELL:
all: build app image ## Build and Run the project docker image

build: ## Contruct the build container and build the binaries and libraries
	@docker build ${DOCKER_BUILD_ARGS} -f ${BUILDCONTAINER} -t ${BUILD_IMAGE} .
	@mkdir -p ${BUILD_DIR}

app: build ## Build the application an the dependencies
	docker run --rm --user ${USER_ID}:${USER_GROUP} --volume ${SRC_DIR}:/usr/src --volume ${BUILD_DIR}:/usr/local ${BUILD_IMAGE} make vapoursynth vapoursynth_install

plugins: app
	docker run --rm --user ${USER_ID}:${USER_GROUP} --volume ${SRC_DIR}:/usr/src --volume ${BUILD_DIR}:/usr/local ${BUILD_IMAGE} make plugins plugins_install

image: ## Build the project Docker image named after the folder name
	docker build -t ${IMAGE} .

build_shell: build
	docker run -it --rm --user ${USER_ID}:${USER_GROUP} --volume ${SRC_DIR}:/usr/src --volume ${BUILD_DIR}:/usr/local ${BUILD_IMAGE} sh


shell: ## Run the project docker image and destroy the container after use
	docker run -it --rm --user ${USER_ID}:${USER_GROUP} --name ${IMAGE} --volume ${PWD}:/data --entrypoint sh ${IMAGE}

clean:
	-rm -rf src/vapoursynth-R* zimg-release-* vapoursynth-plugins build
	-docker rmi ${BUILD_IMAGE} 


.PHONY: all build run

