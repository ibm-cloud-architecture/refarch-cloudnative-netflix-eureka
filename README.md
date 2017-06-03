# IBM Cloud Architecture - Microservices Reference Application for Netflix OSS

### Netflix Microservices Framework on Bluemix - Eureka Service Discovery

#### Description
  This project contains a packaged [Eureka](https://github.com/Netflix/eureka) Service Discovery server for use in a [Netflix OSS](http://netflix.github.io/)-based microservices architecture.  This enables individual microservices to dynamically register themselves and lookup required peer microservices for request routing.  The repository builds the Eureka component into a runnable JAR that can either be used directly in Cloud Foundry or built into a Docker image (with the [Dockerfile](https://github.com/ibm-cloud-architecture/refarch-cloudnative-netflix-eureka/blob/master/docker/Dockerfile) provided).

  This repository, and its parent reference application, are built to enable deployment and learning of building and operating microservices-based applications on the IBM Cloud, but due to the OSS-based nature of the components involved, this reference application can be deployed to any cloud or on-premises environment as desired.

#### Parent Reference Application
  **This project is part of the [IBM Cloud Architecture - Microservices Reference Application for Netflix OSS](https://github.com/ibm-cloud-architecture/refarch-cloudnative-netflix*) suite.**

  For full reference application overviews and deployment guidance, please refer to the root repository above.  The overall project consists of multiple sub projects:

  - Standard Netflix OSS-based microservice architecture components, like Eureka and Zuul
  - Sample Spring Boot applications which provide a REST API and communication between each other.
  - Deployment pipeline and automation guidance

The **Microservices Reference Application for Netflix OSS** is maintained by the IBM Cloud Lab Services and [Cloud Solution Engineering](https://github.com/ibm-cloud-architecture) teams.

#### Application Architecture
1.  **IBM Cloud Architecture - Microservices Reference Application for Netflix OSS**  
    The Microservices Reference Application for Netflix OSS leverages Eureka as its service discovery mechanism.  You can see where Eureka is used, highlighted in the diagram below.  
    ![Microservices RefApp Architecture](static/imgs/netflix-oss-wfd-arch-eureka.png?raw=true)
2.  **IBM Cloud Architecture - Cloud Native Microservices Reference Application for OmniChannel**  
    The Eureka component is also leveraged in the [OmniChannel Application](https://github.com/ibm-cloud-architecture/refarch-cloudnative) as its service discovery mechanism.  You can see where Eureka is used, highlighted in the diagram below.  
    ![OmniChannel Application Architecture](static/imgs/omnichannel-arch-eureka.png?raw=true)


#### APIs in this application:
The REST APIs provided by Eureka are documented on the [Eureka GitHub page](https://github.com/Netflix/eureka/wiki/Eureka-REST-operations), but there are a few simple REST APIs that can be accessed via cURL or Chrome POSTMAN to send get/post/put/delete requests to the application.
- Query for all instances:  
`http://<hostname>/eureka/v2/apps`  

- Query for all *appID* instances:  
`http://<hostname>/eureka/v2/apps/*appID*`  

- Query for a specific *instanceID*:  
`http://<hostname>/eureka/v2/instances/*instanceID*`  

- Query for a specific *appID/instanceID*:  
`http://<hostname>/eureka/v2/apps/*appID*/*instanceID*`  

#### Pre-requisites:
- Install Java JDK 1.8 and ensure it is available in your PATH
- _(Optional)_ A local Docker instance (either native or docker-machine based) running on localhost to host container(s). [Click for instructions](https://docs.docker.com/machine/get-started/).
- _(Optional)_ Apache Maven is used for an alternate build system.  [Click for instructions](https://maven.apache.org/install.html).

#### Build the Application Component
1.  Build the application.  A utility script is provided to easily build using either Gradle (default) or Maven.  You can optionally specify the `-d` parameter to build the associated Docker image as well.  The default Gradle build instructions use a Gradle wrapper requiring no further installation.  The Maven build instructions require Maven to be installed locally.

    1.1 Build the application using Gradle:
      ```
      ./build-microservice.sh [-d]
      ```

    1.1 Build the application using Maven:
      ```
      ./build-microservice.sh -m [-d]
      ```

#### Run the Application Component Locally
1.  You can now run either the JAR file or the Docker image locally.  

    1.1.  To run the JAR file locally, you can simply pass parameters to the Java command in the command prompt:  
        `java -jar docker/app.jar`  
    1.2.  To run the Docker file locally, you can pass the same parameters to start the local Docker image:  
        `docker run -p 8761:8761 netflix-eureka:latest`  

2.  Your Eureka client applications can now connect to the running Eureka server via configuration of the following Spring Boot property:  
        `eureka.client.serviceUrl.defaultZone=http://localhost:8761/eureka/`

3.  The Eureka user interface is available via `http://localhost:8761`.

#### Run the Application Component on Bluemix
1.  Edit the Bluemix Response File to select your desired external public route, application domain, and other operational details.  The default values in the file `bluemix/.bluemixrc` are acceptable to deploy to the US-South Bluemix region.

2.  To deploy Eureka as a container group onto the Bluemix Container Service, execute the following script:  
        `./deploy-container-group.sh`  

    This script will create a clustered group of homogeneous containers, with additional management capabilities provided by Bluemix.

3.  The script will complete rather quickly, but the creation of the necessary Container Group and clustered containers may take a few moments. To check on the status of your Eureka Container Group, you can run the following command:  
        `cf ic group ls | grep eureka_cluster`  

    Once you see a value for *Status* of `CREATE_COMPLETED`, your Eureka instance will now be publicly accessible through the URL configured in the Bluemix response file.  

4.  Your Eureka client applications can now connect to the running Eureka server via configuration of the following Spring Boot property:  
      `eureka.client.serviceUrl.defaultZone=http://netflix-eureka-[YOUR_NAMESPACE].mybluemix.net/eureka/`

5.  The Eureka user interface is available via `http://netflix-eureka-[YOUR_NAMESPACE].mybluemix.net`.

#### Validate the Application Component Deployment
1.  Validate that the user interface appears after a few seconds of the application being started.
