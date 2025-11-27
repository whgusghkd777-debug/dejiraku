<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>会員登録</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 외부 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/join.css">

    <style>
      /* 필요하면 여기에 */
    </style>
</head>
<body>

<div class="register-container">
    <h2>会員登録</h2>

    <form action="${pageContext.request.contextPath}/login/join" method="post">
        <!-- (Spring Security를 쓰고 있으면 CSRF 토큰도 추가)
        <c:if test="${not empty _csrf}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>
        -->

        <div class="mb-3">
            <label for="userid" class="form-label">ID</label>
            <input type="text" class="form-control" id="userid" name="userid" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">PASSWORD</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>

        <div class="mb-3">
            <label for="name" class="form-label">名前</label>
            <input type="text" class="form-control" id="name" name="name" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">メールアドレス</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>

        <div class="mb-3">
            <label for="phone" class="form-label">携帯番号</label>
            <input type="text" class="form-control" id="phone" name="phone" required>
        </div>

        <div class="mb-3">
            <label for="birth" class="form-label">生年月日</label>
            <input type="date" class="form-control" id="birth" name="birth">
        </div>

        <div class="mb-4">
            <label class="form-label d-block">性別</label>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="male" value="M" required>
                <label class="form-check-label" for="male">男性</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="female" value="F" required>
                <label class="form-check-label" for="female">女性</label>
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 py-2">登録する</button>
    </form>
</div>

</body>
</html>