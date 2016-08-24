#!/bin/bash

./gradlew clean build

cp build/libs/eureka-*.jar docker/app.jar

cd docker/

docker build -t microservices-refapp-eureka .
