#!/bin/bash

./gradlew clean build

cp build/libs/eureka-0.0.1-SNAPSHOT.jar docker/app.jar

cd docker/

docker build -t microservices-refapp-eureka .
