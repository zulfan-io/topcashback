<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const router=useRouter()
const state=ref('load'); const daily=ref([]); const funnel=ref([]); const top=ref([]); const orang=ref([]); const sesi=ref(null)
const tot=computed(()=>{const t={views:0,clicks:0,buys:0,orang:0};for(const d of daily.value){t.views+=d.views||0;t.clicks+=d.clicks||0;t.buys+=d.buys||0;t.orang=Math.max(t.orang,d.orang||0)}return t})
async function load(){
  state.value='load'
  try{
    const {data}=await supabase.auth.getSession(); sesi.value=data.session||null
    if(!sesi.value){state.value='guest';return}
    const [a,b,c,d]=await Promise.all([
      supabase.from('crm_daily').select('*').limit(14),
      supabase.from('crm_funnel').select('*'),
      supabase.from('crm_top').select('*').limit(20),
      supabase.from('crm_orang').select('*').limit(20)])
    if(a.error){state.value='locked';return}
    daily.value=a.data||[]; funnel.value=b.data||[]; top.value=c.data||[]; orang.value=d.data||[]
    state.value=(daily.value.length||funnel.value.length)?'ok':'empty'
  }catch(_){state.value='locked'}
}
onMounted(load)
function f(n){return Number(n||0).toLocaleString('id-ID')}
function d(x){return x?new Date(x).toLocaleDateString('id-ID',{day:'2-digit',month:'short'}):'-'}
</script>
<template>
<main class="crm">
  <header class="bar"><button class="ib" @click="router.push('/')" aria-label="Beranda"><Icon name="back" :size="18"/></button><b>CRM · Emas</b><span class="sp"/><button class="ib" @click="load" aria-label="Segarkan"><Icon name="refresh" :size="17"/></button></header>
  <div v-if="state==='load'" class="msg">Memuat…</div>
  <div v-else-if="state==='guest'" class="msg"><Icon name="users" :size="22"/><b>Masuk dulu</b><small>CRM cuma buat owner. Login di /akun, lalu daftarkan diri lewat crm_owner.txt di SQL editor.</small><button class="btn" @click="router.push('/akun')">Ke /akun</button></div>
  <div v-else-if="state==='locked'" class="msg"><Icon name="check" :size="22"/><b>Belum jadi owner</b><small>Login sudah, tapi uid belum terdaftar. Run crm_owner.txt sekali di SQL editor, lalu segarkan.</small><button class="btn" @click="load">Segarkan</button></div>
  <div v-else-if="state==='empty'" class="msg"><Icon name="sparkle" :size="22"/><b>NOL event</b><small>Buka katalog, tap kartu, tap pesan — event langsung ngalir ke sini.</small><button class="btn" @click="router.push('/travel')">Buka katalog</button></div>
  <template v-else>
    <section class="kpi">
      <div><b>{{f(tot.views)}}</b><span>Lihat</span></div>
      <div><b>{{f(tot.clicks)}}</b><span>Masuk</span></div>
      <div><b>{{f(tot.buys)}}</b><span>Pesan</span></div>
      <div><b>{{f(tot.orang)}}</b><span>Orang/hari</span></div>
    </section>
    <section class="blk"><h3>Corong per katalog</h3>
      <table><thead><tr><th>Katalog</th><th>Lihat</th><th>Pesan</th><th>%</th></tr></thead>
      <tbody><tr v-for="r in funnel" :key="r.network"><td>{{r.network}}</td><td>{{f(r.views)}}</td><td>{{f(r.buys)}}</td><td>{{r.konversi_pct||0}}</td></tr></tbody></table>
    </section>
    <section class="blk"><h3>Item paling dilirik & dipesan</h3>
      <table><thead><tr><th>Item</th><th>Lihat</th><th>Pesan</th></tr></thead>
      <tbody><tr v-for="r in top" :key="r.offer_id"><td class="t">{{r.title||r.offer_id}}</td><td>{{f(r.views)}}</td><td>{{f(r.buys)}}</td></tr></tbody></table>
    </section>
    <section class="blk"><h3>Harian</h3>
      <table><thead><tr><th>Hari</th><th>Lihat</th><th>Pesan</th><th>Orang</th></tr></thead>
      <tbody><tr v-for="r in daily" :key="r.hari"><td>{{d(r.hari)}}</td><td>{{f(r.views)}}</td><td>{{f(r.buys)}}</td><td>{{f(r.orang)}}</td></tr></tbody></table>
    </section>
    <section class="blk"><h3>Orang (first-party)</h3>
      <table><thead><tr><th>Siapa</th><th>Event</th><th>Pesan</th><th>Hari aktif</th></tr></thead>
      <tbody><tr v-for="r in orang" :key="r.siapa"><td class="t">{{String(r.siapa).slice(0,10)}}</td><td>{{f(r.event)}}</td><td>{{f(r.buys)}}</td><td>{{f(r.hari_aktif)}}</td></tr></tbody></table>
      <small class="note">Data perilaku milik sendiri buat retensi & rekomendasi. NOL diperjualbelikan (UU PDP 27/2022).</small>
    </section>
  </template>
</main>
</template>
<style scoped>
.crm{min-height:100vh;background:#FFF7EC;color:#1a1a1a;font-family:system-ui,sans-serif;padding-bottom:40px}
.bar{position:sticky;top:0;z-index:20;display:flex;gap:10px;align-items:center;padding:calc(10px + env(safe-area-inset-top)) 14px 10px;background:rgba(255,247,236,.92);backdrop-filter:blur(12px);border-bottom:1px solid #eadfd0}
.bar b{font-size:15px}.sp{flex:1}
.ib{width:36px;height:36px;display:grid;place-items:center;border:1px solid #eadfd0;border-radius:11px;background:#fff;cursor:pointer;color:#1a1a1a}
.msg{display:flex;flex-direction:column;align-items:center;gap:9px;text-align:center;padding:50px 24px;color:#7b7268}
.msg b{font-size:15px;color:#1a1a1a}.msg small{font-size:12px;max-width:300px;line-height:1.5}
.btn{margin-top:5px;border:0;border-radius:999px;padding:10px 20px;font-weight:900;font-size:12px;color:#fff;background:linear-gradient(135deg,#FF7A45,#FF4D3D);cursor:pointer}
.kpi{display:grid;grid-template-columns:repeat(4,1fr);gap:8px;padding:14px}
.kpi div{background:#fff;border:1px solid #eadfd0;border-radius:13px;padding:10px 8px;text-align:center}
.kpi b{display:block;font-size:17px;color:#FF4D3D}.kpi span{font-size:9px;color:#7b7268;font-weight:700}
.blk{margin:0 14px 14px;background:#fff;border:1px solid #eadfd0;border-radius:15px;padding:12px}
.blk h3{margin:0 0 9px;font-size:13px}
table{width:100%;border-collapse:collapse;font-size:11.5px}
th{text-align:left;color:#7b7268;font-size:10px;font-weight:800;padding:5px 6px;border-bottom:1px solid #f3e9dc}
td{padding:7px 6px;border-bottom:1px solid #f7efe4}
td.t{max-width:150px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
tr:last-child td{border-bottom:0}
.note{display:block;margin-top:9px;font-size:10px;color:#9a8f82;line-height:1.4}
</style>
