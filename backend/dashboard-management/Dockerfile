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

# 2. Copiamos la estructura de código fuente directamente al WORKDIR
COPY lumentrack-commons/src ./src

RUN chmod +x ./gradlew

# Al estar en su propio contexto raíz aislado, ejecutamos directo la tarea sin prefijos
RUN ./gradlew publishToMavenLocal --no-daemon

# ========================================================
# ETAPA 2: Compilar el Microservicio (dashboard-management)
# ========================================================
FROM eclipse-temurin:25-jdk-noble AS app-builder
WORKDIR /src

# 1. Usamos el wrapper y configuraciones propios de dashboard-management
COPY dashboard-management/gradlew .
COPY dashboard-management/gradle/ gradle/
COPY dashboard-management/build.gradle .
COPY dashboard-management/settings.gradle .

# 2. Copiamos el código fuente de la aplicación directo al WORKDIR (esencial para MapStruct)
COPY dashboard-management/src ./src

# 3. Importamos el Maven Local generado en la Etapa 1 con la librería común
COPY --from=commons-builder /root/.m2 /root/.m2

RUN chmod +x ./gradlew

# Removemos el prefijo del módulo ya que mapeamos su propio wrapper independiente
RUN ./gradlew bootJar -x test --no-daemon

# ========================================================
# ETAPA 3: Imagen final de ejecución (Runtime)
# ========================================================
FROM eclipse-temurin:25-jdk-noble

# Instalamos curl de forma segura para el funcionamiento del healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiamos el JAR final generado en la ETAPA 2 (compilado directamente en /src/build)
COPY --from=app-builder /src/build/libs/*.jar lumentrack-dashboard-backend.jar

# Copiamos el certificado ca.pem directo desde los recursos copiados en la etapa 2
COPY --from=app-builder /src/src/main/resources/ca.pem ca.pem

# Optimización de la JVM para entornos de contenedores
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

EXPOSE 8081

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-dashboard-backend.jar"]