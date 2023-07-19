# Build stage
ARG VERSION=1.0.0
ARG USER=user
FROM maven:3.6.0-jdk-8-slim AS build
ARG VERSION
ARG USER
COPY my-app /home/app/src
RUN mvn versions:set -DnewVersion=$VERSION -f /home/app/src/pom.xml && mvn -f /home/app/src/pom.xml package

# Run stage
FROM openjdk:8-jre-slim
ARG VERSION
ARG USER
ENV USER=${USER}
RUN useradd -U --shell /bin/false -m -p x --uid 1001 $USER
COPY --chown=1001:1001 --from=build /home/app/src/target/my-app-$VERSION.jar /home/${USER}/my-app.jar
USER $USER
ENTRYPOINT java -jar /home/${USER}/my-app.jar