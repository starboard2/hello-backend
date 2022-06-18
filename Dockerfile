FROM public.ecr.aws/docker/library/maven:3.8-openjdk-11 as builder

#WORKDIR /tmp

# compile the source code and package it in a jar file
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar

RUN java -Djarmode=layertools -jar application.jar extract

FROM adoptopenjdk:11-jre-hotspot
#ARG WORKDIR=/tmp
COPY --from=builder ./dependencies/ ./
COPY --from=builder ./snapshot-dependencies/ ./
RUN true
COPY --from=builder ./spring-boot-loader/ ./
RUN true
COPY --from=builder ./application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]