# syntax=docker/dockerfile:1

# Build stage (используем проверенный тег)
FROM maven:3.8.8-jdk-17 AS builder

WORKDIR /build
COPY pom.xml .
COPY src ./src

# кешируем зависимости и собираем
RUN mvn -B -Dmaven.test.skip=true dependency:resolve
RUN mvn -B -Dmaven.test.skip=true package

# Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
