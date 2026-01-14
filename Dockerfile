FROM eclipse-temurin:17-jdk
WORKDIR /app

# 빌드 결과물을 app.jar로 복사
# Render 빌드 환경에서 생성된 jar 파일을 실행 준비합니다.
COPY target/*.jar app.jar

# Render가 부여하는 포트를 사용하도록 강제 설정
EXPOSE 8080
CMD ["java", "-jar", "-Dserver.port=${PORT}", "app.jar"]
