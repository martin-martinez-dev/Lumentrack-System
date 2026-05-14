# --- ETAPA 1: COMPILACIÓN (Build) ---
FROM eclipse-temurin:25-jdk-noble AS build
WORKDIR /app

# 1. Copiamos los archivos de Gradle primero para aprovechar el caché de capas
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Damos permisos y descargamos dependencias
RUN chmod +x ./gradlew
RUN ./gradlew dependencies --no-daemon

# 2. Copiamos el código fuente y compilamos
# Aquí es donde se generan los Mappers gracias a tu build.gradle corregido
COPY src src
RUN ./gradlew clean build -x test --no-daemon

# --- ETAPA 2: EJECUCIÓN (Runtime) ---
FROM eclipse-temurin:25-jdk-noble
WORKDIR /app

# 3. Instalamos curl para el healthcheck (como tenías antes)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 4. Copiamos el JAR generado en la etapa anterior
# Nota: Usamos el comodín para no depender de la versión exacta en el nombre
COPY --from=build /app/build/libs/*.jar lumentrack-dashboard-backend.jar

# 5. Copiamos tu certificado para la conexión segura
COPY src/main/resources/ca.pem ca.pem

# 6. Tus optimizaciones de memoria y puerto
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
EXPOSE 8081

# 7. Ejecución
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-dashboard-backend.jar"]