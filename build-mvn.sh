#!/bin/bash

mvn clean package

cp target/eureka-*.jar docker/app.jar

cd docker/

docker build -t microservices-refapp-eureka .
