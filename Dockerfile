FROM public.ecr.aws/docker/library/maven:3.8-openjdk-11 as builder

#WORKDIR /tmp

# compile the source code and package it in a jar file
COPY pom.xml .
# go-offline using the pom.xml
RUN mvn dependency:go-offline
# copy your other files
COPY ./src ./src
# compile the source code and package it in a jar file
RUN mvn clean install -Dmaven.test.skip=true
RUN cp target/*.jar application.jar

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