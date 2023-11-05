FROM maven:3-eclipse-temurin-21 AS build

WORKDIR /project
COPY . /project
RUN ./buildJvm.sh

FROM gcr.io/distroless/base-debian12:latest

WORKDIR /application
ENV JAVA_HOME /application/jvm
ENV PATH $JAVA_HOME/bin:$PATH

COPY --from=build /project/target/jvm /application/jvm/
COPY --from=build /project/target/*.jar app.jar

EXPOSE 8080
USER 1001

CMD ["java",  "-jar", "app.jar"]