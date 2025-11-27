<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>ホテル予約</title>

  <!-- 분리된 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

  <!-- JS -->
  <script defer src="${pageContext.request.contextPath}/resources/js/main.js"></script>

  <!-- 로그아웃 링크 스타일 보조 -->
  <style>
    .inline-form { display:inline; margin:0; }
    .link-btn { background:none; border:none; padding:0; margin-left:20px; color:#333; font:inherit; cursor:pointer; }
    .link-btn:hover { color:#ceb597; }
    .welcome { margin-left:12px; color:#666; font-weight:500; white-space:nowrap; }
  </style>
</head>
<body>
  <!-- 헤더 -->
  <header class="site-header">
    <div class="container header-inner">

      <!-- 로고 + 환영 문구 -->
      <div class="brand">
       デジ楽　ホテル
        <c:if test="${not empty sessionScope.loginUser}">
          <span class="welcome">
            ${sessionScope.loginUser.name} 様、歓迎します。
          </span>
        </c:if>
      </div>

      <!-- 우측 네비 -->
      <nav class="nav">
        <c:if test="${not empty sessionScope.loginUser}">
          <a href="${pageContext.request.contextPath}/mypage">マイページ</a>
        </c:if>
        <c:choose>
          <c:when test="${not empty sessionScope.loginUser}">
            <form action="${pageContext.request.contextPath}/logout" method="post" class="inline-form">
              <button type="submit" class="link-btn">ログアウト</button>
            </form>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login">ログイン</a>
          </c:otherwise>
        </c:choose>
      </nav>
    </div>
  </header>

  <!-- 히어로 -->
  <section class="hero">
    <div class="hero-overlay"></div>
    <div class="container hero-content">
      <h1>世界は、すぐそこ。</h1>
      <p>旅行をもっと身近に。</p>

      <!-- ✅ 단일 폼 + 地域 최상단 '地域武官' 추가 -->
      <form class="search-form" action="${pageContext.request.contextPath}/hotels" method="get">
        <!-- 地域選択 -->
        <div class="field">
          <label for="region">地域</label>
          <select id="region" name="region" required>
            <!-- 최상단 탭: 지역 무관 -->

            <option value="tokyo">東京</option>
            <option value="kyoto">京都</option>
            <option value="fukuoka">福岡</option>
            <option value="osaka">大阪</option>
          </select>
        </div>

        <div class="field">
          <label>チェックイン</label>
          <input type="date" id="checkin" name="checkin" required>
        </div>
        <div class="field">
          <label>チェックアウト</label>
          <input type="date" id="checkout" name="checkout" required>
        </div>
        <div class="field">
          <label>宿泊人数</label>
          <select id="guests" name="guests">
            <option value="1">1名</option>
            <option value="2" selected>2名</option>
            <option value="3">3名</option>
            <option value="4">4名</option>
          </select>
        </div>

        <button type="submit" class="btn-primary">検索</button>
      </form>
    </div>
  </section>

  <!-- 추천 호텔 섹션 (껍데기 유지) -->
  <section class="container section">
    <h2 class="section-title">おすすめのホテル</h2>
    <div class="card-grid">
      <article class="card">
        <div class="card-media" style="background-image:url('${pageContext.request.contextPath}/resources/img/이미지1.jpg');"></div>
        <div class="card-body">
          <h3>デジ楽　東京本店</h3>
          <p class="muted">地下鉄：東京駅(300m) · 公共駐車場 · 14㎡</p>
          <div class="card-bottom">
            <div class="price"><strong>120,000円</strong> /泊~</div>
          </div>
        </div>
      </article>
      <article class="card">
        <div class="card-media" style="background-image:url('${pageContext.request.contextPath}/resources/img/이미지2.jpg');"></div>
        <div class="card-body">
          <h3>デジ楽　京都支店</h3>
          <p class="muted">地下鉄：京都駅(500m) · 禁煙 · 17㎡</p>
          <div class="card-bottom">
            <div class="price"><strong>180,000円</strong> /泊~</div>
          </div>
        </div>
      </article>
      <article class="card">
        <div class="card-media" style="background-image:url('${pageContext.request.contextPath}/resources/img/이미지3.jpg');"></div>
        <div class="card-body">
          <h3>デジ楽　福岡支店</h3>
          <p class="muted">地下鉄：博多駅(400m) · Wi-Fi（無料） · 20㎡</p>
          <div class="card-bottom">
            <div class="price"><strong>240,000円</strong> /泊~</div>
          </div>
        </div>
      </article>
    </div>
  </section>

  <!-- 푸터 -->
  <footer class="site-footer">
    <div class="container footer-inner">
      <div>© 2025 DejiRaku Hotel</div>
      <div class="muted">CSセンター: 1234-5678 · 東京都港区六本木</div>
    </div>
  </footer>
</body>
</html>
