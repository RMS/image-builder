#!/bin/bash
set -x
IMAGE_REPO="circleci/build-image"
PUSH_REPO="eastus-artifactory.azure.rmsonecloud.net:6001"
#SHA=$(shell git rev-parse --short HEAD)
# VERSION=$(CIRCLE_BUILD_NUM)-$(SHA)
NO_CACHE=""

REPOS=(data-store)

mkdir -p repos
if [ ! -d "repos/data-store" ]
then
    git clone git@github.com:RMS/data-store.git repos/data-store
else
    cd repos/data-store && git pull -s recursive -X theirs && cd ../..
fi

echo "Building Docker image ${PUSH_REPO}/buildbox:${TAG}"
sudo docker build ${NO_CACHE} --build-arg IMAGE_TAG=buildbox \
-t ${PUSH_REPO}/buildbox:${TAG} \
-f targets/ubuntu-14.04-thin/Dockerfile \
.


# sudo docker push ${PUSH_REPO}/buildbox:${TAG}