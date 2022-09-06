TAG:=latest
MODEL_RUN:=FLAH123
IMAGE:=msrp-webapp-dev
CLUSTER:=MSRPWEBAPP-dev
SERVICE:=msrp-app-us-service-dev
COUNT:=2

## Build the docker image
build-image:
	@echo "Building the docker image: $(IMAGE):$(TAG)"
	docker build -f ../docker/Dockerfile . --tag $(IMAGE):$(TAG)

## Push latest docker image to ecr
push-image-ecr:
	@echo "Pushing the image: $(IMAGE):$(TAG) to ECR"
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 165868383646.dkr.ecr.us-west-2.amazonaws.com
	docker tag $(IMAGE):$(TAG) 165868383646.dkr.ecr.us-west-2.amazonaws.com/$(IMAGE):$(TAG)
	docker push 165868383646.dkr.ecr.us-west-2.amazonaws.com/$(IMAGE):$(TAG)


update-service:
	@echo "updating AWS ECS service : ${SERVICE}"
	./service_manager.sh $SERVICE $CLUSTER

# Build and push the docker image to ecr
build-push-image-ecr: build-image push-image-ecr