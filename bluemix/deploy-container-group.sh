#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/.bluemixrc

#################################################################################
# Validate image exists in Bluemix registry
#################################################################################
echo "Looking up Bluemix registry images"
BLUEMIX_IMAGES=$(cf ic images --format "{{.Repository}}:{{.Tag}}")

REQUIRED_IMAGES=(
    ${REGISTRY_IMAGE}
)

for image in ${REQUIRED_IMAGES[@]}; do
    echo "$BLUEMIX_IMAGES" | grep "$image" > /dev/null
    if [ $? -ne 0 ]; then
        #echo "Pulling ${DOCKERHUB_NAMESPACE}/$image from Dockerhub"
        echo "Registry Image Not Found.  Attempting to push from Local Docker"
        DOCKER_IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}")
        echo "$DOCKER_IMAGES" | grep "$image" > /dev/null
        if [ $? -ne 0 ]; then
          echo "Local Registry Image Not Found.  Exiting..."
          exit 1
        fi
        docker tag ${REGISTRY_IMAGE} ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${REGISTRY_IMAGE}
        docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${REGISTRY_IMAGE}
    fi
done

#################################################################################
# Start Eureka container group
#################################################################################
echo "Starting Eureka container group"
cf ic group create --name eureka_cluster \
  --publish 8761 --memory 256 --auto \
  --min 1 --max 3 --desired 1 \
  --hostname ${REGISTRY_HOSTNAME} \
  --domain ${ROUTES_DOMAIN} \
  --env eureka.client.fetchRegistry=true \
  --env eureka.client.registerWithEureka=true \
  --env eureka.client.serviceUrl.defaultZone=${REGISTRY_URL}/eureka/ \
  --env eureka.instance.hostname=${REGISTRY_HOSTNAME}.${ROUTES_DOMAIN} \
  --env eureka.instance.nonSecurePort=80 \
  --env eureka.port=80 \
  ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${REGISTRY_IMAGE}
