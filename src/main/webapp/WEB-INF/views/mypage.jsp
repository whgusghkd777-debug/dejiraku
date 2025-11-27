<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <title>マイページ | DejiRaku Hotel</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
  <style>
    .mypage-wrap{padding-top:40px;padding-bottom:80px}
    .sidebar{min-height:60vh}
    .list-group-item.active{background-color:#dec3a5;border-color:#dec3a5;color:#000;font-weight:600}
    .card + .card{margin-top:16px}
    .highlight-resv{outline:2px solid #ceb597;border-radius:.5rem;animation:flash .9s ease-in-out 2}
    @keyframes flash{50%{outline-color:#ffd9a8}}
  </style>
</head>
<body class="d-flex flex-column min-vh-100">
<div class="page">
  <c:set var="isMain" value="false" scope="request"/>
  <%@ include file="/WEB-INF/views/inc/header.jspf" %>

  <main class="container mypage-wrap flex-grow-1">
    <div class="row">
      <aside class="col-lg-3 mb-3 mb-lg-0">
        <div class="sidebar list-group">
          <button type="button" class="list-group-item list-group-item-action active" data-target="#section-info">マイ情報</button>
          <button type="button" class="list-group-item list-group-item-action" data-target="#section-resv">マイ予約</button>
        </div>
        <div class="mt-3">
          <a class="btn btn-outline-danger w-100" href="${pageContext.request.contextPath}/member/withdraw">会員脱退</a>
        </div>
      </aside>

      <section class="col-lg-9">
        <div id="section-info" class="content-section">
          <div class="card">
            <div class="card-header fw-bold">マイ情報</div>
            <div class="card-body">
              <div class="row g-3">
                <div class="col-sm-6"><div class="text-secondary small">名前</div><div class="fs-6">${sessionScope.loginUser.name}</div></div>
                <div class="col-sm-6"><div class="text-secondary small">性別</div><div class="fs-6">
                  <c:choose><c:when test="${sessionScope.loginUser.gender == 'M'}">M</c:when><c:when test="${sessionScope.loginUser.gender == 'F'}">F</c:when><c:otherwise>-</c:otherwise></c:choose>
                </div></div>
                <div class="col-sm-6"><div class="text-secondary small">生年月日</div><div class="fs-6">${sessionScope.loginUser.birthdate}</div></div>
                <div class="col-sm-6"><div class="text-secondary small">メールアドレス</div><div class="fs-6">${sessionScope.loginUser.email}</div></div>
                <div class="col-sm-6"><div class="text-secondary small">携帯電話</div><div class="fs-6">${sessionScope.loginUser.phone}</div></div>
                <div class="col-sm-6"><div class="text-secondary small">ID</div><div class="fs-6">${sessionScope.loginUser.userid}</div></div>
              </div>
              <div class="text-end mt-4">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/mypage/edit">情報修正</a>
              </div>
            </div>
          </div>
        </div>

        <div id="section-resv" class="content-section d-none">
          <div class="card">
            <div class="card-header fw-bold">マイ予約</div>
            <div class="card-body">
              <c:if test="${empty reservations}">
                <p class="text-muted mb-0">予約履歴がありません。</p>
              </c:if>
              <c:if test="${not empty reservations}">
                <div class="list-group">
                  <c:forEach var="r" items="${reservations}">
                    <div class="list-group-item d-flex justify-content-between align-items-center" data-id="${r.id}">
                      <div>
                        <div class="fw-semibold">
                          <a href="${pageContext.request.contextPath}/reservation/${r.id}" class="text-decoration-none">${r.hotelName} · ${r.roomType}</a>
                        </div>
                        <div class="text-secondary small">
                          チェックイン ${r.checkin} ~ チェックアウト ${r.checkout} · 人員 ${r.guests}名 · 金額 <fmt:formatNumber value="${r.totalPrice}" type="number"/>円
                        </div>
                      </div>
                      <div class="d-flex align-items-center gap-2">
                        <span class="badge text-bg-light">${r.status}</span>
                        <c:if test="${r.status == 'PAID'}">
                          <form method="post" action="${pageContext.request.contextPath}/reservation/${r.id}/cancel" onsubmit="return confirm('この予約を取り消しますか？');">
                            <button type="submit" class="btn btn-danger btn-sm">取り消し</button>
                          </form>
                        </c:if>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </div>
        </div>

      </section>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/inc/footer.jspf" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.querySelectorAll('.sidebar .list-group-item').forEach(btn=>{
    btn.addEventListener('click',function(){
      document.querySelectorAll('.sidebar .list-group-item').forEach(el=>el.classList.remove('active'));
      this.classList.add('active');
      const target=this.getAttribute('data-target');
      document.querySelectorAll('.content-section').forEach(sec=>sec.classList.add('d-none'));
      document.querySelector(target).classList.remove('d-none');
      const url=new URL(location.href), params=url.searchParams;
      if(target==='#section-resv') params.set('tab','resv'); else params.delete('tab');
      const qs=params.toString(); history.replaceState(null,'',url.pathname+(qs?('?'+qs):''));
    });
  });
  (function(){
    const params=new URLSearchParams(location.search);
    if(params.get('tab')==='resv'){ document.querySelector('.sidebar [data-target="#section-resv"]').click(); }
    const hi=params.get('highlight');
    if(hi){
      const el=document.querySelector('.list-group [data-id="'+hi+'"]');
      if(el){ el.classList.add('highlight-resv'); el.scrollIntoView({behavior:'smooth',block:'center'}); setTimeout(()=>el.classList.remove('highlight-resv'),1800); }
    }
  })();
</script>
</body>
</html>
