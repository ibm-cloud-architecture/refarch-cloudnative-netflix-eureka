#!/bin/bash

while getopts "md" ARG; do
  case ${ARG} in
    m)
      USE_MAVEN='yes'
      ;;
    d)
      DO_DOCKER='yes'
      ;;
  esac
done

if [[ ${USE_MAVEN} == 'yes' ]]; then
  mvn clean package
  if [[ ${DO_DOCKER} == 'yes' ]]; then
    cp target/eureka-0.0.1-SNAPSHOT.jar docker/app.jar
  fi
else
  ./gradlew clean build
  if [[ ${DO_DOCKER} == 'yes' ]]; then
	cp build/libs/eureka-0.0.1-SNAPSHOT.jar docker/app.jar
  fi
fi

if [[ ${DO_DOCKER} == 'yes' ]]; then
  cd docker/
  docker build -t microservices-refapp-eureka .
fi
