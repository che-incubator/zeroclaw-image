IMAGE ?= quay.io/che-incubator/zeroclaw
TAG ?= next

.PHONY: build push

build:
	docker build -t $(IMAGE):$(TAG) .

push: build
	docker push $(IMAGE):$(TAG)
