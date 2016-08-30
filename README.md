# IBM Cloud Architecture - Microservices Reference Application

## Netflix OSS on Bluemix - Eureka Service Discovery

### Description
TBD

### Root Reference Application
https://github.com/ibm-cloud-architecture/microservices-netflix

### Application Architecture
TBD

### Run this Application Component

#### Build the Application Component
1.  Run one of the provided build scripts to compile the Java code, package it into a runnable JAR, and build the Docker image.  Run either  
        ./build-mvn.sh  
  or  
        ./build-gradle.sh  
  to run the Maven or Gradle builds, respectively.  Both build packages produce the same output, however both build files are provided for convenience of the user.

#### Run it Locally
1.  You can now run either the JAR file or the Docker image locally.  

    1.1.  To run the JAR file locally, you can simply pass parameters to the Java command in the command prompt:  
        java -jar docker/app.jar  
    1.2.  To run the Docker file locally, you can pass the same paramters to start the local Docker image:  
        docker run -p 8761:8761 microservices-refapp-eureka:latest  

2.  Your Eureka client applications can now connect to the running Eureka server via the following URL:
        http://localhost:8761/eureka/
    Note that the URL suffix of `/eureka/` is a required addition.

#### Run it on Bluemix
1.  Edit the Bluemix Response File to select your desired external public route, application domain, and other operational details.  The default values in the `.bluemixrc` are acceptable to deploy in to the US-South Bluemix region.

2.  To deploy Eureka as a container group onto the Bluemix Container Service, execute the following script:
        ./deploy-container-group.sh
    This script will create a clustered group of homogeneous containers, with additional management capabilities provided by Bluemix.

3.  The script will complete rather quickly, but the creation of the necessary Container Group and clustered containers may take a few moments. To check on the status of your Eureka Container Group, you can run the following command:
        cf ic group ls | grep eureka_cluster
    Once you see a value for *Status* of `CREATE_COMPLETED`, your Eureka instance will now be publicly accessible through the URL configured in the Bluemix response file.  

    Your Eureka clients will be able to access Eureka via that URL and the required `/eureka/` suffix.  For example,  
        http://microservices-refapp-eureka-cloudarch.mybluemix.net/eureka/

#### Validate Deployment
TBD
