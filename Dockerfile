FROM scratch

WORKDIR /application
ENV JAVA_HOME /application/jvm
ENV PATH $JAVA_HOME/bin:$PATH

COPY target/jvm jvm
COPY target/*.jar app.jar

EXPOSE 8080
USER 1001

CMD ["java",  "-jar", "app.jar"]