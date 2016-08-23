#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/.bluemixrc

#################################################################################
# Validate image exists in Bluemix registry
#################################################################################
echo "Looking up Bluemix registry images"
BLUEMIX_IMAGES=$(bluemix ic images --format "{{.Repository}}:{{.Tag}}")

REQUIRED_IMAGES=(
    ${EUREKA_IMAGE}
)

for image in ${REQUIRED_IMAGES[@]}; do
    echo "$BLUEMIX_IMAGES" | grep "$image" > /dev/null
    if [ $? -ne 0 ]; then
        #echo "Pulling ${DOCKERHUB_NAMESPACE}/$image from Dockerhub"
        #bluemix ic cpi ${DOCKERHUB_NAMESPACE}/$image ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/$image
        #TODO Fail and echo message that image must be built and pushed
        #docker build -t registry.ng.bluemix.net/cloudarch/eureka .
        #docker push registry.ng.bluemix.net/cloudarch/eureka
    fi
done

#################################################################################
# Start Eureka container group
#################################################################################
echo "Starting Eureka container group"
bluemix ic group-create --name eureka_cluster \
  --publish 8761 --memory 256 --auto \
  --min 1 --max 3 --desired 2 \
  --hostname $REGISTRY_HOSTNAME \
  --domain $ROUTES_DOMAIN \
  ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${EUREKA_IMAGE}
