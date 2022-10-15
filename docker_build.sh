#!/bin/bash

docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_TOKEN} registry-1.docker.io

docker build -t ${IMAGE_TAG} .
docker push ${IMAGE_TAG}
docker image rm ${IMAGE_TAG}