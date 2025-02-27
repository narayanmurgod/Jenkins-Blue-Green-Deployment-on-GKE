# Use the Eclipse Temurin 17 JDK Alpine base image
FROM eclipse-temurin:17-jdk-alpine

# Expose the port your app runs on
EXPOSE 8080

# Set the working directory inside the container
ENV APP_HOME="/usr/src/app"
WORKDIR $APP_HOME

# Copy the JAR file into the container
COPY target/*.jar $APP_HOME/app.jar

# Command to run the application
CMD ["java", "-jar", "app.jar"]