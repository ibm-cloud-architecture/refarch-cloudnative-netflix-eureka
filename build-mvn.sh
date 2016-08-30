#!/bin/bash

mvn clean package

cp target/eureka-0.0.1-SNAPSHOT.jar docker/app.jar

cd docker/

docker build -t microservices-refapp-eureka .
