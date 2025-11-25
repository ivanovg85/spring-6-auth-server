FROM eclipse-temurin:25-jdk AS builder

WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

COPY src/ src/
RUN ./mvnw package -DskipTests -B -Djava.version=25

FROM eclipse-temurin:25-jre

WORKDIR /app
COPY --from=builder /app/target/spring-6-auth-server-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 9000
ENTRYPOINT ["java", "-jar", "app.jar"]
