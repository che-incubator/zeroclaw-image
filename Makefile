IMAGE ?= quay.io/che-incubator/zeroclaw-image
TAG ?= next

.PHONY: build push

build:
	docker build -t $(IMAGE):$(TAG) .

push: build
	docker push $(IMAGE):$(TAG)
