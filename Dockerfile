# Stage 1: Build the Java/TeaVM code
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY . .

# Run the Maven build to generate the TeaVM files
RUN mvn clean package -DskipTests

# Stage 2: Serve the static files using Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy the compiled HTML/JS from the Maven 'target' folder
# Note: Adjust 'teavm' if the repo uses a different folder name in target
COPY --from=build /app/target/teavm /usr/share/nginx/html

# Expose port 80 for Render
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
