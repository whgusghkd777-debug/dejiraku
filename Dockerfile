# 1단계: 빌드 환경 (메이븐과 자바 17 설치된 주방)
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
# pom.xml 설정대로 빌드해서 JAR 파일을 만듭니다.
RUN mvn clean package -DskipTests

# 2단계: 실행 환경 (가볍고 빠른 서빙용 테이블)
FROM openjdk:17-jdk-slim
WORKDIR /app
# 빌드 단계에서 만들어진 JAR 파일을 app.jar라는 이름으로 가져옵니다.
COPY --from=build /app/target/*.jar app.jar

# 서버 실행! (포트는 Render 기본값인 8080 사용)
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
