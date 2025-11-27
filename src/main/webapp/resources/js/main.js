// 체크인/아웃 최소 날짜 제어
(function(){
  const today = new Date();
  const fmt = d => d.toISOString().slice(0,10);

  const checkin = document.getElementById('checkin');
  const checkout = document.getElementById('checkout');
  if(!checkin || !checkout) return;

  checkin.min = fmt(today);
  checkin.addEventListener('change', () => {
    const inDate = new Date(checkin.value || fmt(today));
    const outMin = new Date(inDate); outMin.setDate(inDate.getDate()+1);
    checkout.min = fmt(outMin);
    if(!checkout.value || new Date(checkout.value) <= inDate){
      checkout.value = fmt(outMin);
    }
  });

  // 초기값
  checkin.value = fmt(today);
  checkin.dispatchEvent(new Event('change'));
})();