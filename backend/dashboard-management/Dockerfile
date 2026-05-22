# --- ETAPA 1: COMPILACIÓN (Build) ---
FROM eclipse-temurin:25-jdk-noble AS build
WORKDIR /app

# 1. Copiamos los archivos de Gradle primero para aprovechar el caché de capas
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Truco Senior real: Descargamos SOLO las dependencias a la caché de Docker 
# sin intentar compilar un código que aún no existe.
RUN chmod +x ./gradlew
RUN ./gradlew dependencies --no-daemon

# 2. Copiamos el código fuente fresquecito
COPY src src

# Compilamos el JAR. Al no haber limpiado las dependencias previas, es ultra rápido,
# pero al ser la primera vez que ve "src", MapStruct generará tus mappers con LocalDate sí o sí.
RUN ./gradlew bootJar -x test --no-daemon


# --- ETAPA 2: EJECUCIÓN (Runtime) ---
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# 3. Instalamos curl de forma ultra ligera en Alpine para el healthcheck
RUN apk add --no-cache curl

# 4. Copiamos el JAR generado con nombre exacto
COPY --from=build /app/build/libs/lumentrack-dashboard-backend.jar lumentrack-dashboard-backend.jar

# 5. Tus optimizaciones de memoria y puerto
ENV JAVA_OPTS="-Dserver.port=8081 -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
EXPOSE 8081

# 6. Ejecución
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-dashboard-backend.jar"]