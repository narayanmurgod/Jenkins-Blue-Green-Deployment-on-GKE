FROM eclipse-temurin:17-jdk-alpine

EXPOSE 8080

ENV APP_HOME=/usr/src/app

WORKDIR $APP_HOME

# Copy all JAR files to the app directory
COPY *.jar app.jar

# Run the first JAR file found in the directory
CMD ["sh", "-c", "java -jar $(ls app.jar)"]
