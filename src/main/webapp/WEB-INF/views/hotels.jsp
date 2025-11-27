<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>ホテル一覧</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
  <style>
    .layout{display:grid;grid-template-columns:220px 1fr;gap:16px;margin:16px 0 32px}
    .side{background:#f3f4f6;border:1px solid #eceff3;border-radius:10px;padding:16px}
    .side h3{margin:0 0 12px}
    .side a{display:block;padding:10px 8px;color:#333;border-radius:8px;text-decoration:none}
    .side a:hover,.side a.active{background:#eef2ff;color:#0b75ff}
    .list{background:#fff;border:1px solid #eceff3;border-radius:10px;overflow:hidden;width:100%}
    .list-header,.list-row{display:grid;grid-template-columns:2fr 1fr 2fr;align-items:center;text-align:left;border-bottom:1px solid #f1f5f9}
    .list-header{background:#fafafa;font-weight:600;border-bottom:2px solid #e3e6eb}
    .list-header div:not(:last-child),.list-row div:not(:last-child){border-right:1px solid #e5e7eb}
    .list-header div,.list-row div{padding:10px 16px;display:flex;align-items:center}
    .list-row:hover{background:#fafcff}
    .list-row a{display:contents;color:inherit;text-decoration:none}
    .ad{margin-top:16px;background:#f3f4f6;border:1px solid #eceff3;border-radius:10px;padding:24px;text-align:center}
  </style>
</head>
<body>
<div class="page">
  <c:set var="isMain" value="false" scope="request"/>
  <%@ include file="/WEB-INF/views/inc/header.jspf" %>

  <main class="container">
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
    <c:set var="regionParam" value="${empty param.region ? 'all' : param.region}" />

    <div style="margin:16px 0;color:#666;font-size:14px;">
      条件:
      <strong>
        <c:choose>
          <c:when test="${regionParam=='tokyo'}">東京</c:when>
          <c:when test="${regionParam=='kyoto'}">京都</c:when>
          <c:when test="${regionParam=='fukuoka'}">福岡</c:when>
          <c:when test="${regionParam=='osaka'}">大阪</c:when>
          <c:otherwise>地域無関</c:otherwise>
        </c:choose>
      </strong>
      ・ チェックイン: <strong>${param.checkin}</strong>
      ・ チェックアウト: <strong>${param.checkout}</strong>
      ・ 宿泊人数: <strong>${param.guests}名</strong>
    </div>

    <div class="layout">
      <aside class="side">
        <h3>ホテル情報</h3>



        <a href="<c:url value='/hotels'><c:param name='region' value='tokyo'/><c:param name='checkin' value='${param.checkin}'/><c:param name='checkout' value='${param.checkout}'/><c:param name='guests' value='${param.guests}'/></c:url>"
           class="${regionParam=='tokyo'?'active':''}">東京</a>

        <a href="<c:url value='/hotels'><c:param name='region' value='kyoto'/><c:param name='checkin' value='${param.checkin}'/><c:param name='checkout' value='${param.checkout}'/><c:param name='guests' value='${param.guests}'/></c:url>"
           class="${regionParam=='kyoto'?'active':''}">京都</a>

        <a href="<c:url value='/hotels'><c:param name='region' value='fukuoka'/><c:param name='checkin' value='${param.checkin}'/><c:param name='checkout' value='${param.checkout}'/><c:param name='guests' value='${param.guests}'/></c:url>"
           class="${regionParam=='fukuoka'?'active':''}">福岡</a>

        <a href="<c:url value='/hotels'><c:param name='region' value='osaka'/><c:param name='checkin' value='${param.checkin}'/><c:param name='checkout' value='${param.checkout}'/><c:param name='guests' value='${param.guests}'/></c:url>"
           class="${regionParam=='osaka'?'active':''}">大阪</a>
      </aside>

      <section>
        <div class="list">
          <div class="list-header">
            <div>ホテル支店</div><div>価格</div><div>オプション</div>
          </div>

          <c:url var="tokyoUrl" value="/hotel">
            <c:param name="hotelId" value="1"/>
            <c:param name="name" value="${fn:escapeXml('デジ楽 東京新宿店')}"/>
            <c:param name="region" value="tokyo"/>
            <c:param name="price" value="12000"/>
            <c:param name="options" value="${fn:escapeXml('室内喫煙, 自動駐車場')}"/>
            <c:param name="checkin" value="${param.checkin}"/>
            <c:param name="checkout" value="${param.checkout}"/>
            <c:param name="guests" value="${param.guests}"/>
          </c:url>
          <div class="list-row">
            <a href="${tokyoUrl}">
              <div>デジ楽 東京新宿店</div>
              <div><fmt:formatNumber value="12000" type="number"/> 円 / 泊</div>
              <div>室内喫煙, 自動駐車場</div>
            </a>
          </div>

          <c:url var="kyotoUrl" value="/hotel">
            <c:param name="hotelId" value="2"/>
            <c:param name="name" value="${fn:escapeXml('デジ楽 京都四条店')}"/>
            <c:param name="region" value="kyoto"/>
            <c:param name="price" value="18000"/>
            <c:param name="options" value="${fn:escapeXml('禁煙, ラウンジ')}"/>
            <c:param name="checkin" value="${param.checkin}"/>
            <c:param name="checkout" value="${param.checkout}"/>
            <c:param name="guests" value="${param.guests}"/>
          </c:url>
          <div class="list-row">
            <a href="${kyotoUrl}">
              <div>デジ楽 京都四条店</div>
              <div><fmt:formatNumber value="18000" type="number"/> 円 / 泊</div>
              <div>禁煙, ラウンジ</div>
            </a>
          </div>

          <c:url var="fukuokaUrl" value="/hotel">
            <c:param name="hotelId" value="3"/>
            <c:param name="name" value="${fn:escapeXml('デジ楽 福岡博多店')}"/>
            <c:param name="region" value="fukuoka"/>
            <c:param name="price" value="14000"/>
            <c:param name="options" value="${fn:escapeXml('無料Wi-Fi, 駐車場')}"/>
            <c:param name="checkin" value="${param.checkin}"/>
            <c:param name="checkout" value="${param.checkout}"/>
            <c:param name="guests" value="${param.guests}"/>
          </c:url>
          <div class="list-row">
            <a href="${fukuokaUrl}">
              <div>デジ楽 福岡博多店</div>
              <div><fmt:formatNumber value="14000" type="number"/> 円 / 泊</div>
              <div>無料Wi-Fi, 駐車場</div>
            </a>
          </div>

          <c:url var="osakaUrl" value="/hotel">
            <c:param name="hotelId" value="4"/>
            <c:param name="name" value="${fn:escapeXml('デジ楽 大阪梅田店')}"/>
            <c:param name="region" value="osaka"/>
            <c:param name="price" value="16000"/>
            <c:param name="options" value="${fn:escapeXml('フィットネス, 禁煙')}"/>
            <c:param name="checkin" value="${param.checkin}"/>
            <c:param name="checkout" value="${param.checkout}"/>
            <c:param name="guests" value="${param.guests}"/>
          </c:url>
          <div class="list-row">
            <a href="${osakaUrl}">
              <div>デジ楽 大阪梅田店</div>
              <div><fmt:formatNumber value="16000" type="number"/> 円 / 泊</div>
              <div>フィットネス, 禁煙</div>
            </a>
          </div>
        </div>

        <div class="ad">広告</div>
      </section>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/inc/footer.jspf" %>
</div>
</body>
</html>
