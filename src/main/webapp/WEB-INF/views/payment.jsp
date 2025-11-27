<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>決済ページ</title>
<style>
  :root { --brand:#ceb597; --brand-dark:#b99e73; --bg:#f9f8f6; --border:#e5dfd6; --text:#333; }
  *{box-sizing:border-box}
  body{font-family:"Noto Sans JP","맑은 고딕",sans-serif;background-color:var(--bg);margin:0;display:flex;flex-direction:column;align-items:center;color:var(--text)}
  .brand{font-size:42px;font-weight:bold;color:var(--brand);margin:30px 0 18px}
  .card{width:460px;background:#fff;border-radius:16px;box-shadow:0 8px 22px rgba(0,0,0,.08);padding:28px 32px;text-align:center}
  .title{font-size:22px;font-weight:bold;margin-bottom:22px;color:#444}
  .info-box{text-align:left;border:1px solid var(--border);border-radius:12px;padding:18px 22px;background:#fcfbfa;margin-bottom:18px}
  .info-item{margin-bottom:10px;font-size:15px}
  .info-label{font-weight:bold;color:#666;display:inline-block;width:120px}
  .info-value{color:#222}
  .price{background:#f6f2ed;border-radius:10px;padding:12px;font-size:18px;font-weight:bold;color:var(--brand-dark);margin:10px 0 18px}
  .payment-options{text-align:left;margin-top:10px}
  .option-title{font-weight:bold;margin-bottom:10px;color:#444}
  .option-list{display:flex;flex-wrap:wrap;gap:10px}
  .pay-btn{flex:1;min-width:120px;padding:10px 12px;border:1.5px solid var(--brand);border-radius:10px;background:#fff;cursor:pointer;font-weight:bold;color:#7c6a52;transition:all .2s}
  .pay-btn:hover{background:var(--brand);color:#fff}
  .btn-confirm{width:100%;margin-top:20px;background:var(--brand);color:#fff;border:none;border-radius:10px;padding:12px 0;font-size:16px;font-weight:bold;cursor:pointer;transition:background .2s}
  .btn-confirm:disabled{opacity:.6;cursor:not-allowed}
  .btn-confirm:hover{background:var(--brand-dark)}
  .toast{position:fixed;top:18px;left:50%;transform:translateX(-50%);background:#fff3cd;border:1px solid #ffe69c;color:#7a5d00;padding:10px 14px;border-radius:8px;box-shadow:0 6px 18px rgba(0,0,0,.08);font-size:14px;display:none;z-index:999}
  .toast.show{display:block;animation:fade .25s ease}
    .pay-btn:hover{background:var(--brand);color:#fff}
  .pay-btn.active {
  background: var(--brand);
  color: #fff;
  border-color: #000; /* 눌린 버튼 테두리를 좀 더 진하게 */
}
  @keyframes fade{from{opacity:0;transform:translate(-50%,-6px)}to{opacity:1;transform:translate(-50%,0)}}
</style>
</head>
<body>

  <div class="toast" id="toast">選択した決済方法は現在メンテナンス中です。</div>

  <div class="brand">デジ楽</div>

  <div class="card">
    <div class="title">決済情報の確認</div>

    <!-- 예약정보 표시 -->
    <div class="info-box">
      <div class="info-item"><span class="info-label">ホテル名：</span><span class="info-value">${param.hotelName}</span></div>
      <div class="info-item"><span class="info-label">チェックイン：</span><span class="info-value">${param.checkin}</span></div>
      <div class="info-item"><span class="info-label">チェックアウト：</span><span class="info-value">${param.checkout}</span></div>
      <div class="info-item"><span class="info-label">宿泊人数：</span><span class="info-value">${param.guests}名</span></div>
      <div class="info-item"><span class="info-label">客室タイプ：</span><span class="info-value">${param.roomType}</span></div>
    </div>

    <div class="price">支払い金額：¥${param.price}（税込）</div>

    <!-- 결제 수단 -->
    <div class="payment-options">
      <div class="option-title">決済方法を選択</div>
      <div class="option-list">
        <button type="button" class="pay-btn" data-method="VISA">VISA</button>
        <button type="button" class="pay-btn" data-method="MasterCard">MasterCard</button>
        <button type="button" class="pay-btn" data-method="Apple Pay">Apple Pay</button>
        <button type="button" class="pay-btn" data-method="Naver Pay">Naver Pay</button>
        <button type="button" class="pay-btn" data-method="PayPay">PayPay</button>
      </div>
    </div>

    <!-- 결제 확정 POST -->
    <form id="confirmForm" action="${pageContext.request.contextPath}/payment/confirm" method="post">
      <!-- hotel_detail.jsp에서 받은 값들을 다시 POST로 전달 -->
      <input type="hidden" name="hotelId"   value="${param.hotelId}">
      <input type="hidden" name="hotelName" value="${param.hotelName}">
      <input type="hidden" name="region"    value="${param.region}">
      <input type="hidden" name="checkin"   value="${param.checkin}">
      <input type="hidden" name="checkout"  value="${param.checkout}">
      <input type="hidden" name="guests"    value="${param.guests}">
      <input type="hidden" name="roomType"  value="${param.roomType}">
      <input type="hidden" name="amount"    value="${param.price}">
      <input type="hidden" name="paymentMethod" id="paymentMethod">
      <button type="submit" class="btn-confirm" id="btnConfirm" disabled>決済を確定する</button>
    </form>
  </div>

<script>
(function(){
  const toast = document.getElementById('toast');
  const btns  = document.querySelectorAll('.pay-btn');
  const methodInput = document.getElementById('paymentMethod');
  const btnConfirm  = document.getElementById('btnConfirm');

  function showToast(msg){
    toast.textContent = msg;
    toast.classList.add('show');
    setTimeout(()=> toast.classList.remove('show'), 1800);
  }

  btns.forEach(b=>{
    b.addEventListener('click', ()=>{
      const m = b.dataset.method;

      // ✅ 이미 선택된 버튼을 다시 클릭하면 취소
      if (b.classList.contains('active')) {
        b.classList.remove('active');
        methodInput.value = '';
        btnConfirm.disabled = true;
        return; // 더 이상 실행하지 않음
      }

      // 다른 버튼들 active 해제
      btns.forEach(x=>x.classList.remove('active'));
      // 현재 클릭한 버튼 활성화
      b.classList.add('active');

      // 결제수단 설정
      methodInput.value = m;
      btnConfirm.disabled = false;

      // VISA 외에는 토스트 표시
      if (m.toUpperCase() !== 'VISA') {
        showToast('選択した決済方法は現在メンテナンス中です。');
      }
    });
  });
})();
</script>
</body>
</html>

</body>
</html>

