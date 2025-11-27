<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>会員退会確認 | DejiRaku Hotel</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body>
<div class="page">
  <c:set var="isMain" value="false" scope="request"/>
  <%@ include file="/WEB-INF/views/inc/header.jspf" %>

  <main class="container py-4" style="max-width:720px;">
    <h3 class="mb-3">会員脱退</h3>

    <div class="alert alert-warning">
      <strong>${sessionScope.loginUser.name}</strong> 様, 会員退会をするとアカウント及び予約情報が削除(または照会不可)されます。 この作業は元に戻すことはできません。
    </div>

    <form method="post" action="${pageContext.request.contextPath}/member/withdraw" id="withdrawForm">
      <div class="form-check mb-3">
        <input class="form-check-input" type="checkbox" id="agree">
        <label class="form-check-label" for="agree">案内事項をすべて確認し、会員脱退に同意します。</label>
      </div>
      <div class="d-flex gap-2">
        <button type="submit" class="btn btn-danger" id="submitBtn" disabled>退会</button>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/mypage">キャンセル</a>
      </div>
    </form>
  </main>

  <%@ include file="/WEB-INF/views/inc/footer.jspf" %>
</div>

<script>
  const agree=document.getElementById('agree'), submitBtn=document.getElementById('submitBtn');
  agree.addEventListener('change',()=> submitBtn.disabled=!agree.checked);
</script>
</body>
</html>
