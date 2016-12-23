define lc =
	$(shell echo $1 | tr '[:upper:]' '[:lower:]')
endef

PROJECT := $(shell basename ${PWD})
IMAGE := $(call lc,${PROJECT})
TAG := $(shell date +%s)
USER_ID := $(shell id -u)
USER_GROUP := $(shell id -g)

help:
	@echo "Rules:"
	@sed -n -e 's/^\([a-zA-Z0-9_-]\+\): ##\(.*\)/\t\1\t\2/p' $(firstword $(MAKEFILE_LIST))


