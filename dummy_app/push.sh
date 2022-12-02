#!/bin/bash

docker tag bst-image $IMAGE_URI
docker push $IMAGE_URI