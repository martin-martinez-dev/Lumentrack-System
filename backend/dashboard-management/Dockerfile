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
RUN ./gradlew build -x test --no-daemon > /dev/null 2>&1 || true

# 2. Copiamos el código fuente y compilamos
# Aquí es donde se generan los Mappers gracias a tu build.gradle corregido
COPY src src
#RUN ./gradlew clean build -x test --no-daemon
#Trucos Senior
# Compilamos SIN ejecutar clean para aprovechar el impacto del caché de dependencias
RUN ./gradlew bootJar -x test --no-daemon



# --- ETAPA 2: EJECUCIÓN (Runtime) ---
#Trucos de Senior
#FROM eclipse-temurin:25-jdk-noble
# Cambiamos a JRE sobre Alpine: Pasamos de ~500MB a ~180MB de imagen base
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# 3. Instalamos curl para el healthcheck (como tenías antes)
#RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
#Trucos Senior
# Instalamos curl de forma ultra ligera en Alpine para el healthcheck
RUN apk add --no-cache curl

# 4. Copiamos el JAR generado en la etapa anterior
# Nota: Usamos el comodín para no depender de la versión exacta en el nombre
# En lugar de usar comodines que pueden traer el jar equivocado:
COPY --from=build /app/build/libs/lumentrack-dashboard-backend.jar lumentrack-dashboard-backend.jar

# 5. Copiamos tu certificado para la conexión segura
#COPY src/main/resources/ca.pem ca.pem
#Trucos Senior
# Si tu código requiere el ca.pem FUERA del JAR, lo extraemos de la etapa de build así:
# COPY --from=build /app/src/main/resources/ca.pem ca.pem

# 6. Tus optimizaciones de memoria y puerto
ENV JAVA_OPTS="-Dserver.port=8081 -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
EXPOSE 8081

# 7. Ejecución
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-dashboard-backend.jar"]