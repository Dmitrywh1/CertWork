FROM maven:3.6.3-openjdk-11 as build
RUN apt-get update
RUN apt install git -y
RUN git clone https://github.com/yankils/hello-world.git
RUN cd hello-world/ && mvn package

FROM tomcat:9.0.8-jre8-alpine
COPY --from=build hello-world/webapp/target/webapp.war /usr/local/tomcat/webapps
