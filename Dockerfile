FROM maven:3.8.6-openjdk-8-slim
VOLUME /tmp

COPY pom.xml .
# go-offline using the pom.xml
RUN mvn dependency:go-offline
# copy your other files
COPY ./src ./src
# compile the source code and package it in a jar file
RUN mvn clean install -Dmaven.test.skip=true

ARG JAR_FILE=target/*.jar
#COPY ["/tmp/target/*.jar", "application.jar"]
COPY $JAR_FILE application.jar
#RUN cp ar application.jar

ARG JAR_FILE
ADD target/*.jar app.jar

ENV JAR_OPTS=""
ENV JAVA_OPTS=""
ENTRYPOINT exec java -jar /app.jar $JAR_OPTS
