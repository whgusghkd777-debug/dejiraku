<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>マイページ - 情報編集</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
  <style>.form-hint{font-size:.875rem;color:#6c757d}</style>
</head>
<body>
<div class="page">
  <c:set var="isMain" value="false" scope="request"/>
  <%@ include file="/WEB-INF/views/inc/header.jspf" %>

  <main class="container py-4">
    <h3 class="mb-4">情報修正</h3>

    <c:if test="${not empty msg}"><div class="alert alert-success">${msg}</div></c:if>
    <c:set var="u" value="${empty user ? sessionScope.loginUser : user}" />
    <fmt:formatDate value="${u.birthdate}" pattern="yyyy-MM-dd" var="birthStr"/>

    <div class="card">
      <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/mypage/edit">
          <div class="mb-3">
            <label class="form-label">名前</label>
            <input type="text" name="name" class="form-control" value="${u.name != null ? u.name : ''}" maxlength="50" placeholder="お名前">
          </div>
          <div class="mb-3">
            <label class="form-label">メール</label>
            <input type="email" name="email" class="form-control" value="${u.email != null ? u.email : ''}" maxlength="100" placeholder="example@email.com">
            <div class="form-hint">ログインIDは変更不可。メールは連絡用で使用されます。</div>
          </div>
          <div class="mb-3">
            <label class="form-label">携帯番号</label>
            <input type="text" name="phone" class="form-control" value="${u.phone != null ? u.phone : ''}" maxlength="20" pattern="[\d\-+ ]{7,20}" placeholder="090-1234-5678">
          </div>
          <div class="mb-3">
            <label class="form-label">生年月日</label>
            <input type="date" name="birthdate" class="form-control" value="${birthStr != null ? birthStr : ''}">
            <div class="form-hint">yyyy-MM-dd 形式</div>
          </div>
            <div class="mb-3">
              <label class="form-label d-block">性別</label>
              <div class="form-check form-check-inline">
                <input class="form-check-input" id="genderM" type="radio" name="gender" value="M" <c:if test="${u.gender == 'M'}">checked</c:if> >
                <label class="form-check-label" for="genderM">男性</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" id="genderF" type="radio" name="gender" value="F" <c:if test="${u.gender == 'F'}">checked</c:if> >
                <label class="form-check-label" for="genderF">女性</label>
              </div>
            </div>
          <div class="d-flex gap-2">
            <button type="submit" class="btn btn-primary">保存</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/mypage?tab=info">キャンセル</a>
          </div>
        </form>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/inc/footer.jspf" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
