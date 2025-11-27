<%@ page contentType="text/html; charset=UTF-8" language="java" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ID / PW 探す</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 기존 CSS 유지 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/find.css">
    <style>
      /* 접근성 보완 */
      .btn-main:focus { outline: 2px solid rgba(206,181,151,.5); outline-offset: 2px; }

      /* ===== Toast ===== */
      .toast-wrap{
        position: fixed;
        top: 24px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 9999;
        width: min(92vw, 520px);
      }
      .toast-card{
        display: none;
        background: #fff;
        border: 1px solid #e5e7eb;
        box-shadow: 0 10px 26px rgba(0,0,0,.10);
        border-radius: 12px;
        padding: 14px 16px;
        font-size: 14px;
        line-height: 1.5;
      }
      .toast-card.show{ display:block; animation: fadein .18s ease-out; }
      .toast-title{ font-weight:700; margin-bottom:6px; }
      .toast-msg{ color:#111; word-break: keep-all; }
      .toast-row{ display:flex; justify-content:space-between; align-items:center; gap:12px; }
      .toast-btn{
        border: none; background:#f3f4f6; padding:6px 10px; border-radius:8px; cursor:pointer; font-size:13px;
      }
      .toast-btn:hover{ background:#ebeef3; }
      .toast-progress{
        height: 4px; border-radius: 999px; background: #f1f5f9; overflow:hidden; margin-top:10px;
      }
      .toast-bar{ height:100%; width:100%; background:#22c55e; transition: width linear; }
      .toast-card.error .toast-bar{ background:#ef4444; }
      @keyframes fadein{ from{ opacity:0; transform: translate(-50%,-6px);} to{ opacity:1; transform: translate(-50%,0);} }
    </style>
</head>
<body>

<div class="find-container">
    <h3 class="text-center mb-4">ID/PW　探す</h3>

    <!-- 탭 메뉴 (기존 유지) -->
    <ul class="nav nav-tabs mb-4" id="findTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="findId-tab" data-bs-toggle="tab" data-bs-target="#findId" type="button" role="tab">ID探す</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="findPw-tab" data-bs-toggle="tab" data-bs-target="#findPw" type="button" role="tab">PW探す</button>
        </li>
    </ul>

    <div class="tab-content" id="findTabContent">
        <!-- 아이디 찾기 -->
        <div class="tab-pane fade show active" id="findId" role="tabpanel">
            <form id="formFindId" action="${pageContext.request.contextPath}/member/find/id" method="post">
                <div class="mb-3">
                    <label class="form-label">名前</label>
                    <input type="text" name="name" class="form-control" placeholder="お名前を入力してください" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">メール</label>
                    <input type="email" name="email" class="form-control" placeholder="メールを入力してください" required>
                </div>
                <button type="submit" class="btn btn-main w-100 py-2">ID 探す</button>
            </form>
        </div>

        <!-- 비밀번호 찾기 -->
        <div class="tab-pane fade" id="findPw" role="tabpanel">
            <form id="formFindPw" action="${pageContext.request.contextPath}/member/find/pw" method="post">
                <div class="mb-3">
                    <label class="form-label">ID</label>
                    <input type="text" name="userid" class="form-control" placeholder="IDを入力してください" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">メール</label>
                    <input type="email" name="email" class="form-control" placeholder="メールを入力してください" required>
                </div>
                <button type="submit" class="btn btn-main w-100 py-2">パスワードを探す</button>
            </form>
        </div>
    </div>
</div>

<!-- 숨은 iframe: 서버 응답을 여기로 받아서 내용 파싱 후 토스트 출력 -->
<iframe id="hiddenFrame" name="hiddenFrame" style="display:none;width:0;height:0;border:0;"></iframe>

<!-- Toast container -->
<div class="toast-wrap">
  <div id="toast" class="toast-card" role="status" aria-live="polite">
    <div class="toast-row">
      <div>
        <div id="toastTitle" class="toast-title">結果</div>
        <div id="toastMsg" class="toast-msg"></div>
      </div>
      <button type="button" id="toastClose" class="toast-btn">閉じる</button>
    </div>
    <div class="toast-progress"><div id="toastBar" class="toast-bar"></div></div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
  var frame = document.getElementById('hiddenFrame');
  var toast = document.getElementById('toast');
  var toastTitle = document.getElementById('toastTitle');
  var toastMsg = document.getElementById('toastMsg');
  var toastClose = document.getElementById('toastClose');
  var toastBar = document.getElementById('toastBar');
  var TIMER = null;

  // 토스트 표시
  function showToast(message, isError){
    toast.classList.remove('error');
    if (isError) toast.classList.add('error');

    toastTitle.textContent = isError ? 'エラー' : '結果';
    toastMsg.textContent = message || '';
    toast.classList.add('show');

    // 60초 프로그레스
    var DURATION = 60000; // 1분
    toastBar.style.transition = 'none';
    toastBar.style.width = '100%';
    // 리플로우 후 전환 시작
    requestAnimationFrame(function(){
      toastBar.style.transition = 'width ' + DURATION + 'ms linear';
      toastBar.style.width = '0%';
    });

    clearTimeout(TIMER);
    TIMER = setTimeout(hideToast, DURATION);
  }

  function hideToast(){
    toast.classList.remove('show');
    clearTimeout(TIMER);
  }

  toastClose.addEventListener('click', hideToast);

  // 응답 파싱 (process JSP가 반환한 HTML에서 .alert-success/.alert-danger를 찾아 메시지로 사용)
  function parseAndToast(doc){
    if (!doc) { showToast('処理に失敗しました。', true); return; }

    // 우선 Bootstrap alert 우선 탐색
    var ok = doc.querySelector('.alert.alert-success');
    var ng = doc.querySelector('.alert.alert-danger');
    if (ok){
      showToast(ok.textContent.trim(), false);
      return;
    }
    if (ng){
      showToast(ng.textContent.trim(), true);
      return;
    }

    // 그 외: 본문 전체 텍스트에서 첫 줄만 사용 (fallback)
    var text = doc.body ? doc.body.textContent.trim() : '';
    if (text.length > 300) text = text.slice(0, 300) + ' ...';
    showToast(text || '処理が完了しました。', false);
  }

  // iframe 로드 시 콜백
  frame.addEventListener('load', function(){
    try{
      var doc = frame.contentDocument || frame.contentWindow.document;
      parseAndToast(doc);
    } catch(e){
      showToast('応答を読み取れませんでした。', true);
    }
  });

  // 공통: 폼을 hiddenFrame으로 전송
  function hookForm(form){
    if (!form) return;
    form.addEventListener('submit', function(e){
      e.preventDefault();
      // 대상 프레임 설정
      form.setAttribute('target', 'hiddenFrame');
      form.submit();

      // 다음 제출을 위해 원복
      setTimeout(function(){ form.removeAttribute('target'); }, 50);
    });
  }

  hookForm(document.getElementById('formFindId'));
  hookForm(document.getElementById('formFindPw'));
})();
</script>
</body>
</html>
