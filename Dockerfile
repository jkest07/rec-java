# =========================================
# ETAPA 1 - COMPILACIÓN
# =========================================

FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Copiamos primero el pom para aprovechar la caché de Docker
COPY pom.xml .

# Descargamos dependencias
RUN mvn -B dependency:go-offline

# Copiamos el código fuente
COPY src ./src

# Compilamos la aplicación
RUN mvn -B clean package -DskipTests


# =========================================
# ETAPA 2 - EJECUCIÓN
# =========================================

FROM eclipse-temurin:21-jre-alpine

# Creamos grupo y usuario sin privilegios
RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup

# Directorio de trabajo
WORKDIR /app

# Copiamos solamente el JAR generado en la etapa anterior
COPY --from=builder \
    /build/target/rec-api-0.0.1-SNAPSHOT.jar \
    app.jar

# Cambiamos el propietario del directorio
RUN chown -R appuser:appgroup /app

# La aplicación ya no se ejecutará como root
USER appuser

# Documentamos el puerto usado por Spring Boot
EXPOSE 8080

# Comando de inicio
ENTRYPOINT ["java", "-jar", "/app/app.jar"]