<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${param.name} | ホテル詳細</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
  <style>
    body{background:#fafafa}
    .detail-wrap{display:grid;grid-template-columns:1fr 360px;gap:20px;margin:20px 0 32px}
    .gallery-box{background:#fff;border:1px solid #eceff3;border-radius:12px;padding:16px}
    .bigimage-frame{width:100%;height:360px;border-radius:10px;background:#f3f4f6;border:1px solid #eceff3;padding:.3cm;box-sizing:border-box;display:flex;align-items:center;justify-content:center;overflow:hidden}
    .bigimage-frame img{max-width:100%;max-height:100%;object-fit:contain;display:block}
    .side-panel{background:#fff;border:1px solid #eceff3;border-radius:12px;padding:16px}
    .kv{display:grid;grid-template-columns:80px 1fr;row-gap:10px;column-gap:12px;font-size:14px;line-height:1.4}
    .kv dt{color:#6b7280}.kv dd{margin:0;color:#111;word-break:keep-all}
    .action-row{display:flex;align-items:flex-start;flex-wrap:wrap;gap:12px;margin-top:16px}
    .btn-toggle{border:1px solid #cfd6e3;background:#fff;border-radius:8px;height:38px;padding:0 12px;cursor:pointer;font-size:14px;display:flex;align-items:center;gap:6px}
    .chev{transition:transform .2s;font-size:12px}
    .reserve-form{margin-left:auto;display:flex;align-items:center}
    .btn-primary{background:#0b75ff;color:#fff;border:0;border-radius:8px;height:38px;padding:0 16px;cursor:pointer;font-size:14px;font-weight:600}
    .btn-primary[disabled]{opacity:.5;cursor:not-allowed}
    .slide{overflow:hidden;max-height:0;transition:max-height .25s ease}
    .slide.show{max-height:900px}
    .room-choices{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-top:16px}
    .room-card{border:1px solid #e5e7eb;border-radius:10px;background:#fff;padding:10px 12px;cursor:pointer;font-size:14px}
    .room-card:hover{background:#fafcff}
    .room-card input{margin-right:6px}
    .room-name{font-weight:600;color:#111;display:flex;align-items:center}
    .room-meta{color:#6b7280;font-size:12px;margin-top:4px;line-height:1.4}
    .room-price{margin-top:6px;font-size:13px;font-weight:600;color:#111}
    .thumb4{display:none;grid-template-columns:repeat(4,1fr);gap:10px;margin-top:16px}
    .thumb-cell{border:1px solid #eceff3;border-radius:10px;background:#fff;padding:.3cm;height:140px;box-sizing:border-box;display:flex;align-items:center;justify-content:center;overflow:hidden}
    .thumb-cell img{max-width:100%;max-height:100%;object-fit:contain;display:block}
    .ad-box{margin-top:24px;background:#f3f4f6;border:1px solid #eceff3;border-radius:10px;padding:22px;text-align:center;color:#666;font-size:14px}
    @media(max-width:900px){.detail-wrap{grid-template-columns:1fr}.room-choices{grid-template-columns:1fr}.thumb4{grid-template-columns:repeat(2,1fr)}.reserve-form{width:100%;margin-left:0;justify-content:flex-start}}
  </style>
</head>
<body>
<div class="page">
  <c:set var="isMain" value="false" scope="request"/>
  <%@ include file="/WEB-INF/views/inc/header.jspf" %>

  <main class="container" style="margin-top:8px;">
    <h2 style="margin:16px 0 8px;font-size:20px;color:#111;font-weight:600;">${param.name}</h2>

    <div style="color:#6b7280;font-size:14px;line-height:1.5;margin-bottom:16px;">
      地域:
      <c:choose>
        <c:when test="${param.region=='tokyo'}">東京</c:when>
        <c:when test="${param.region=='kyoto'}">京都</c:when>
        <c:when test="${param.region=='fukuoka'}">福岡</c:when>
        <c:when test="${param.region=='osaka'}">大阪</c:when>
        <c:otherwise>地域無関</c:otherwise>
      </c:choose>
      ・ チェックイン <strong>${param.checkin}</strong>
      ・ チェックアウト <strong>${param.checkout}</strong>
      ・ 宿泊人数 <strong>${param.guests}名</strong>
    </div>

    <div class="detail-wrap">
      <section class="gallery-box">
        <div class="bigimage-frame">
          <img src="${pageContext.request.contextPath}/resources/img/${param.region}.jpg" alt="${param.name}">
        </div>

        <div class="action-row" style="margin-top:16px;">
          <button type="button" class="btn-toggle" id="btnRooms">客室選択 <span class="chev" id="chevIcon">▾</span></button>

          <form action="${pageContext.request.contextPath}/payment" method="get" class="reserve-form">
            <input type="hidden" name="hotelId"   value="${param.hotelId}">
            <input type="hidden" name="hotelName" value="${param.name}">
            <input type="hidden" name="region"    value="${param.region}">
            <input type="hidden" name="checkin"   value="${param.checkin}">
            <input type="hidden" name="checkout"  value="${param.checkout}">
            <input type="hidden" name="guests"    value="${param.guests}">
            <input type="hidden" name="roomType"  id="roomType">
            <input type="hidden" name="price"     id="price">
            <button type="submit" class="btn-primary" id="btnReserve" disabled>この条件で予約</button>
          </form>
        </div>

        <div id="roomSlide" class="slide">
          <div class="room-choices">
            <label class="room-card">
              <input type="radio" name="room" value="BUSINESS" data-room-type="business" data-price="12000" data-region="${param.region}">
              <div class="room-name">ビジネス</div>
              <div class="room-meta">禁煙, デスク, 無料Wi-Fi</div>
              <div class="room-price">12,000 円 / 泊</div>
            </label>
            <label class="room-card">
              <input type="radio" name="room" value="PAIR" data-room-type="pair" data-price="15000" data-region="${param.region}">
              <div class="room-name">ペア</div>
              <div class="room-meta">クイーン, 朝食</div>
              <div class="room-price">15,000 円 / 泊</div>
            </label>
            <label class="room-card">
              <input type="radio" name="room" value="FAMILY" data-room-type="family" data-price="19000" data-region="${param.region}">
              <div class="room-name">ファミリー</div>
              <div class="room-meta">4名, キッチン</div>
              <div class="room-price">19,000 円 / 泊</div>
            </label>
          </div>

          <div id="thumbs" class="thumb4">
            <div class="thumb-cell"><img alt=""></div>
            <div class="thumb-cell"><img alt=""></div>
            <div class="thumb-cell"><img alt=""></div>
            <div class="thumb-cell"><img alt=""></div>
          </div>
        </div>

        <div class="ad-box">広告</div>
      </section>

      <aside class="side-panel">
        <dl class="kv">
          <dt>支店名</dt><dd>${param.name}</dd>
          <dt>価格</dt><dd id="detail-price"><strong><fmt:formatNumber value="${param.price}" type="number"/></strong> 円 / 泊</dd>
          <dt>オプション</dt><dd>${param.options}</dd>
        </dl>
      </aside>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/inc/footer.jspf" %>
</div>

<script>
(function(){
  const cpath='${pageContext.request.contextPath}', region='${param.region}';
  const btnRooms=document.getElementById('btnRooms'), roomSlide=document.getElementById('roomSlide'), chevIcon=document.getElementById('chevIcon');
  const thumbs=document.getElementById('thumbs'), reserveBtn=document.getElementById('btnReserve'), hiddenType=document.getElementById('roomType'), hiddenPrice=document.getElementById('price'), detailPrice=document.getElementById('detail-price');

  btnRooms.addEventListener('click',function(){
    roomSlide.classList.toggle('show');
    chevIcon.style.transform = roomSlide.classList.contains('show') ? 'rotate(180deg)' : 'rotate(0deg)';
  });

  function onRoomChoose(e){
    const r=e.target; if(!r||r.name!=='room') return;
    const type=r.dataset.roomType, price=r.dataset.price, folder=region;
    const urls=[1,2,3,4].map(i=> cpath+'/resources/img/rooms/'+folder+'/'+type+i+'.jpg');
    const imgEls=thumbs.querySelectorAll('img');
    urls.forEach((u,i)=>{ if(imgEls[i]){ imgEls[i].src=u; imgEls[i].alt=type+' '+(i+1);} });
    thumbs.style.display='grid';
    if(detailPrice){ detailPrice.innerHTML='<strong>'+parseInt(price,10).toLocaleString('ja-JP')+'</strong> 円 / 泊'; }
    hiddenType.value=type; hiddenPrice.value=price; reserveBtn.disabled=false;
  }
  document.querySelectorAll('input[name="room"]').forEach(r=> r.addEventListener('change',onRoomChoose));
})();
</script>
</body>
</html>
