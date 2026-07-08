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

# Corregido: Al estar en su propio contexto raíz, se ejecuta directo la tarea
RUN ./gradlew publishToMavenLocal --no-daemon

# ========================================================
# ETAPA 2: Compilar el Microservicio (admin-management)
# ========================================================
FROM eclipse-temurin:25-jdk-noble AS app-builder
WORKDIR /src

# 1. Usamos el wrapper y configuraciones propios de admin-management
COPY admin-management/gradlew .
COPY admin-management/gradle/ gradle/
COPY admin-management/build.gradle .
COPY admin-management/settings.gradle .

# 2. Copiamos el código fuente de la aplicación
COPY admin-management/src ./src

# 3. Importamos el Maven Local generado en la Etapa 1
COPY --from=commons-builder /root/.m2 /root/.m2

RUN chmod +x ./gradlew

# Corregido: Se remueve el prefijo del módulo ya que mapeamos su propio wrapper independiente
RUN ./gradlew bootJar -x test --no-daemon

# ========================================================
# ETAPA 3: Imagen final de ejecución (Producción)
# ========================================================
FROM eclipse-temurin:25-jdk-noble
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Copiamos el JAR final generado en la ETAPA 2
COPY --from=app-builder /src/build/libs/*.jar lumentrack-admin-backend.jar

# Copiamos el certificado ca.pem directo desde los recursos copiados en la etapa 2
COPY --from=app-builder /src/src/main/resources/ca.pem ca.pem

ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
EXPOSE 8083

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar lumentrack-admin-backend.jar"]