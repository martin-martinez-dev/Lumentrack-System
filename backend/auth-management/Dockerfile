# Paso 1: Usar la imagen de JDK 25.
# Si aún no está en 'alpine', usamos 'noble' (Ubuntu) para mayor compatibilidad
FROM eclipse-temurin:25-jdk-noble

# Paso 2: Instalar curl para el healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Paso 3: Crear un directorio de trabajo
WORKDIR /app

# Paso 4: Argumento para el archivo JAR (opcional, facilita cambios de versión)
ARG JAR_FILE=build/libs/*.jar

# Paso 5: Copiar el JAR al contenedor
# Usamos el nombre por defecto del JAR generado por Gradle si no se especifica bootJar.archiveFileName
# Y lo renombramos a un nombre consistente para el backend de auth
COPY build/libs/auth-management-0.0.1-SNAPSHOT.jar lumentrack-auth-backend.jar

# Copiamos el certificado ca.pem
# AÑADIDO
COPY src/main/resources/ca.pem ca.pem

# Paso 6: Optimización de memoria para contenedores Java
# Esto ayuda a que Java entienda los límites de RAM del contenedor
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Paso 7: Exponer el puerto de tu backend
EXPOSE 8084

# Paso 8: Ejecutar la aplicación con las optimizaciones
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-auth-backend.jar"]