<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap"
	rel="stylesheet">


<title>Login</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/css/login.css">
</head>
<body>

	<!-- 로그인 박스 바로 위에 이미지 추가 -->
	<div class="top-image">
		<img src="${pageContext.request.contextPath}/resources/img/데라.jpg"
			alt="로고">
	</div>
	
	<div class="login-container">
			<h2>Login</h2>
			<form action="${pageContext.request.contextPath}/login" method="post">
			    <input type="text" name="username" placeholder="ID" required />
			    <input type="password" name="password" placeholder="PASSWORD" required />

			    <!-- ✅ 로그인 후 돌아갈 위치(next)를 함께 보냄 -->
			    <input type="hidden" name="next" value="${not empty param.next ? param.next : next}"/>

			    <!-- 로그인 상태 유지 체크박스 -->
			    <div class="remember-me">
			        <input type="checkbox" id="rememberMe" name="rememberMe" />
			        <label for="rememberMe">ログイン状態を維持</label>
			    </div>

			    <div class="login-links">
			        <a href="${pageContext.request.contextPath}/login/join">会員登録</a> |
			        <a href="${pageContext.request.contextPath}/login/find">ID/PW 探す</a>
			    </div>
			    <button type="submit">Login</button>
			</form>
		<c:if test="${not empty errorMsg}">
			<p class="IDまたはPasswordが正しくありません。">${errorMsg}</p>
		</c:if>
	</div>
<!-- 페이지 아래쪽에 광고 이미지 추가 -->
<div class="bottom-ad">
  <img src="${pageContext.request.contextPath}/resources/img/광고2.png" 
  alt="광고.png">
</div>

</body>
</html>

