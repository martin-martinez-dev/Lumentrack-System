# ========================================================
# ETAPA 1: Compilar la librería común (lumentrack-commons)
# ========================================================
FROM eclipse-temurin:25-jdk-noble AS commons-builder
WORKDIR /src

# 1. Copiamos el wrapper y configuraciones desde la carpeta del commons
COPY lumentrack-commons/gradlew .
COPY lumentrack-commons/gradle/ gradle/
COPY lumentrack-commons/build.gradle .
COPY lumentrack-commons/settings.gradle .

# 2. Copiamos la estructura de código fuente directamente
COPY lumentrack-commons/src ./src

RUN chmod +x ./gradlew

# Al estar en su propio contexto raíz aislado, ejecutamos directo la tarea sin prefijos
RUN ./gradlew publishToMavenLocal --no-daemon

# ========================================================
# ETAPA 2: Compilar el Microservicio (auth-management)
# ========================================================
FROM eclipse-temurin:25-jdk-noble AS app-builder
WORKDIR /src

# 1. Usamos el wrapper y configuraciones propios de auth-management
COPY auth-management/gradlew .
COPY auth-management/gradle/ gradle/
COPY auth-management/build.gradle .
COPY auth-management/settings.gradle .

# 2. Copiamos el código fuente de la aplicación directo al WORKDIR
COPY auth-management/src ./src

# 3. Importamos el Maven Local generado en la Etapa 1 con la librería común
COPY --from=commons-builder /root/.m2 /root/.m2

RUN chmod +x ./gradlew

# Removemos el prefijo del módulo ya que mapeamos su propio wrapper independiente
RUN ./gradlew bootJar -x test --no-daemon

# ========================================================
# ETAPA 3: Imagen final de ejecución (Producción)
# ========================================================
FROM eclipse-temurin:25-jdk-noble

# Instalar curl para asegurar el funcionamiento del healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiamos el JAR final generado en la ETAPA 2 (ahora compilado directamente en /src/build)
COPY --from=app-builder /src/build/libs/*.jar lumentrack-auth-backend.jar

# Copiamos el certificado ca.pem directo desde los recursos copiados en la etapa 2
COPY --from=app-builder /src/src/main/resources/ca.pem ca.pem

# Optimización de la JVM para contenedores
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

EXPOSE 8084

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-auth-backend.jar"]