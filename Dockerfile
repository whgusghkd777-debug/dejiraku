# 1단계: 빌드 (소스 코드를 jar 파일로 만드는 과정)
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY . .
# DB 없이 시연할 것이므로 테스트는 건너뛰고 빌드합니다.
RUN mvn clean package -DskipTests

# 2단계: 실행 (만들어진 파일만 가져와서 실행)
FROM eclipse-temurin:17-jdk
WORKDIR /app
# 빌드 단계에서 생성된 jar 파일을 실행 단계로 복사합니다.
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
# Render의 포트 설정을 적용하여 실행합니다.
CMD ["java", "-jar", "-Dserver.port=${PORT}", "app.jar"]
