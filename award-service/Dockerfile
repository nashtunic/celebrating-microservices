FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY build/libs/*.jar app.jar
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]