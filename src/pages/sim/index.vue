<template>
  <div class="sim-hub" data-sim-hub="light-first">
    <div class="hub-head">
      <h1>Sim Hub</h1>
      <p>Prototipe terang dulu. Gelap nanti sebagai lapisan mood, bukan default.</p>
    </div>

    <div class="hub-grid">
      <a class="hub-card sim-card spr-pop" href="/sim/match">
        <span class="presence-dot pulse"></span>
        <h2>Kencan</h2>
        <p>Swipe deck, match, coupon pair.</p>
        <div class="wallet-chip">Masuk /sim/match</div>
      </a>

      <a class="hub-card sim-card spr-pop" href="/sim/stage">
        <span class="presence-dot pulse"></span>
        <h2>Stage</h2>
        <p>Dunia simulasi, badge harian, reward stub.</p>
        <div class="wallet-chip">Masuk /sim/stage</div>
      </a>

      <a class="hub-card sim-card spr-pop" href="/sim/wallet">
        <span class="presence-dot pulse"></span>
        <h2>Dompet</h2>
        <p>Saldo, pending reward, transaksi stub.</p>
        <div class="wallet-chip">Masuk /sim/wallet</div>
      </a>

      <a class="hub-card sim-card spr-pop" href="/sim/commerce">
        <span class="presence-dot pulse"></span>
        <h2>Commerce</h2>
        <p>Feed affiliate, keranjang, voucher, coupon pair.</p>
        <div class="wallet-chip">Masuk /sim/commerce</div>
      </a>

      <a class="hub-card sim-card spr-pop" href="/sim/profile">
        <span class="presence-dot pulse"></span>
        <h2>Profil</h2>
        <p>Identitas sim, presence, social rail.</p>
        <div class="wallet-chip">Masuk /sim/profile</div>
      </a>
    </div>
  </div>
</template>

<style scoped>
.sim-hub{
  background:#FFF7EC;
  color:#222;
  min-height:70vh;
  padding:18px 14px 28px;
}
.hub-head h1{
  margin:0 0 6px;
  font-size:28px;
  line-height:1.15;
  color:#FF7A45;
}
.hub-head p{
  margin:0 0 16px;
  color:#5b5b5b;
  font-size:14px;
}
.hub-grid{
  display:grid;
  grid-template-columns:1fr;
  gap:12px;
}
@media (min-width:720px){
  .hub-grid{grid-template-columns:repeat(2,minmax(0,1fr));}
}
.hub-card{
  display:block;
  text-decoration:none;
  color:inherit;
  background:#fff;
  border:1px solid rgba(255,122,69,.18);
  border-radius:22px;
  padding:14px;
  box-shadow:0 8px 24px rgba(34,34,34,.06);
  position:relative;
}
.hub-card h2{
  margin:8px 0 4px;
  font-size:20px;
  color:#222;
}
.hub-card p{
  margin:0 0 10px;
  font-size:14px;
  color:#666;
}
.hub-card .wallet-chip{
  display:inline-flex;
  align-items:center;
  gap:6px;
  background:rgba(0,184,169,.10);
  color:#00796f;
  border-radius:9999px;
  padding:6px 10px;
  font-size:12px;
  font-weight:700;
}
.hub-card .presence-dot{
  position:absolute;
  right:14px;
  top:14px;
  width:10px;
  height:10px;
  border-radius:9999px;
  background:#00B8A9;
}
</style>
