# Stage 1: Build
FROM maven:3-openjdk-17 AS build # Hoặc eclipse-temurin:17-jdk-jammy, tùy bạn chọn
WORKDIR /app
COPY . . # Sao chép toàn bộ mã nguồn vào image
# Hoặc COPY pom.xml . và COPY src src để tận dụng cache tốt hơn

# Build ứng dụng, bỏ qua test
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM openjdk:17-jdk-slim # Hoặc eclipse-temurin:17-jre-jammy
WORKDIR /app

# Sửa dòng này để sao chép file JAR
# Sử dụng *.jar để khớp với bất kỳ file JAR nào trong target/
COPY --from=build /app/target/*.jar /app/app.jar # <-- ĐÃ SỬA

# Expose cổng 8080 cho bên ngoài truy cập
EXPOSE 8080

# Lệnh chạy ứng dụng Spring Boot (chạy JAR)
ENTRYPOINT ["java", "-jar", "app.jar"] # <-- ĐÃ SỬA