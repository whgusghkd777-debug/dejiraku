FROM eclipse-temurin:17-jdk
WORKDIR /app

# [수정 1] 파일 이름이 조금 달라도 잘 찾을 수 있게 별표(*)를 사용합니다.
COPY target/*.jar app.jar

EXPOSE 8080

# [수정 2] Render가 부여하는 포트(PORT)를 서버가 인식하도록 설정을 추가합니다.
CMD ["java", "-jar", "-Dserver.port=${PORT}", "app.jar"]
