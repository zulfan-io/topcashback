<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const route=useRoute(); const router=useRouter()
const rows=ref([]); const state=ref('load'); const q=ref(''); const cat=ref('all'); const geo=ref('all')
const sort=ref('pop'); const view=ref('all'); const saved=ref([]); const detail=ref(null); const qty=ref(1)
const pick=ref(false); const sel=ref([]); const limit=ref(24); const toast=ref(null); const now=ref(Date.now())
const gridEl=ref(null); const sheetY=ref(0); const dragY=ref(null)
const RATE=0.1261; const KEY='tv_saved_v1'
let clock=null; let tT=null; let io=null; let undoBuf=null
const CATS=[['all','grid','Semua'],['ATTRACTION','compass','Atraksi'],['ENTERTAINMENT','ticket','Hiburan'],['PLAYGROUNDS','sparkle','Arena Anak'],['OTHER','globe','Lainnya']]
function rp(n){return 'Rp'+Number(n||0).toLocaleString('id-ID')}
function cb(n){return Math.round(Number(n||0)*RATE)}
function pad(n){return String(n).padStart(2,'0')}
const midnight=computed(()=>{const d=new Date(now.value);d.setHours(24,0,0,0);return d.getTime()})
const left=computed(()=>Math.max(0,midnight.value-now.value))
const cd=computed(()=>{const s=Math.floor(left.value/1000);return pad(Math.floor(s/3600))+':'+pad(Math.floor(s%3600/60))+':'+pad(s%60)})
function rng(seed){let t=seed>>>0;return()=>{t+=0x6D2B79F5;let r=Math.imul(t^t>>>15,1|t);r^=r+Math.imul(r^r>>>7,61|r);return((r^r>>>14)>>>0)/4294967296}}
async function load(){
  state.value='load'
  const {data,error}=await supabase.from('shoper_offers').select('*').eq('network','traveloka').eq('active',true).limit(400)
  if(error){state.value='error';return}
  rows.value=(data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{})
    return {...r,cat:(m.cat||'OTHER').toUpperCase(),city:m.city||m.region||'',country:m.country||m.region||'Global',brief:m.brief||'',region:m.region||''}})
  state.value=rows.value.length?'ok':'empty'
}
onMounted(async()=>{
  try{const s=localStorage.getItem(KEY);if(s)saved.value=JSON.parse(s)||[]}catch(_){}
  await load()
  const p=route.query.p
  if(p){const hit=rows.value.find(r=>r.external_id===String(p));if(hit)openDetail(hit)}
  clock=setInterval(()=>now.value=Date.now(),1000)
  await nextTick(); reveal()
})
onUnmounted(()=>{clearInterval(clock);clearTimeout(tT);io&&io.disconnect();document.body.style.overflow=''})
function persist(){try{localStorage.setItem(KEY,JSON.stringify(saved.value))}catch(_){}}
function flash(msg,undo){clearTimeout(tT);toast.value={msg,undo:!!undo};tT=setTimeout(()=>{toast.value=null;undoBuf=null},4200)}
function isSaved(id){return saved.value.includes(id)}
function toggleSave(o){
  if(isSaved(o.id)){saved.value=saved.value.filter(x=>x!==o.id);flash('Dihapus dari simpanan')}
  else{saved.value=[...saved.value,o.id];flash('Tersimpan · '+o.title.slice(0,28))}
  persist()
}
const catCount=computed(()=>{const m={all:rows.value.length};for(const r of rows.value){const k=CATS.some(c=>c[0]===r.cat)?r.cat:'OTHER';m[k]=(m[k]||0)+1}return m})
const geoList=computed(()=>{const m={};for(const r of rows.value)m[r.country]=(m[r.country]||0)+1
  return Object.keys(m).sort((a,b)=>m[b]-m[a]).slice(0,7).map(k=>({k,n:m[k]}))})
const dealRows=computed(()=>{
  if(!rows.value.length)return []
  const day=Math.floor(now.value/86400000); const r=rng(day+7)
  return [...rows.value].map(x=>({x,k:r()})).sort((a,b)=>(a.x.price-b.x.price)||a.k-b.k).slice(0,14).map(o=>o.x)})
const base=computed(()=>{
  let a=rows.value
  if(view.value==='saved')a=a.filter(r=>isSaved(r.id))
  if(view.value==='deal'){const ids=new Set(dealRows.value.map(r=>r.id));a=a.filter(r=>ids.has(r.id))}
  if(cat.value!=='all')a=a.filter(r=>(CATS.some(c=>c[0]===r.cat)?r.cat:'OTHER')===cat.value)
  if(geo.value!=='all')a=a.filter(r=>r.country===geo.value)
  const t=q.value.trim().toLowerCase()
  if(t)a=a.filter(r=>(r.title+' '+r.city+' '+r.country+' '+r.brief+' '+r.cat).toLowerCase().includes(t))
  if(sort.value==='cheap')a=[...a].sort((x,y)=>x.price-y.price)
  else if(sort.value==='high')a=[...a].sort((x,y)=>y.price-x.price)
  else if(sort.value==='az')a=[...a].sort((x,y)=>x.title.localeCompare(y.title))
  return a})
const shown=computed(()=>base.value.slice(0,limit.value))
const minP=computed(()=>base.value.length?Math.min.apply(null,base.value.map(r=>r.price)):0)
watch([q,cat,geo,sort,view],()=>{limit.value=24;sel.value=[];nextTick(reveal)})
watch(shown,()=>nextTick(reveal))
function reveal(){
  if(!gridEl.value)return
  io&&io.disconnect()
  io=new IntersectionObserver(es=>es.forEach(e=>{if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target)}}),{rootMargin:'120px'})
  gridEl.value.querySelectorAll('.pc:not(.in)').forEach(el=>io.observe(el))
}
function openDetail(o){detail.value=o;qty.value=1;sheetY.value=0;document.body.style.overflow='hidden'}
function closeDetail(){detail.value=null;document.body.style.overflow='';if(route.query.p)router.replace('/travel')}
function buy(o){window.open(o.url,'_blank','noopener')}
async function share(o){
  const url=location.origin+'/travel?p='+encodeURIComponent(o.external_id)
  try{if(navigator.share){await navigator.share({title:o.title,text:o.title+' · '+rp(o.price),url});return}}catch(_){}
  try{await navigator.clipboard.writeText(url);flash('Tautan disalin')}catch(_){flash('Tautan: '+url)}
}
function tapCard(o){ if(pick.value){toggleSel(o.id)} else openDetail(o) }
function toggleSel(id){sel.value=sel.value.includes(id)?sel.value.filter(x=>x!==id):[...sel.value,id]}
function bulkSave(){
  const add=sel.value.filter(id=>!isSaved(id))
  saved.value=[...saved.value,...add];persist();flash(add.length+' destinasi disimpan');sel.value=[];pick.value=false
}
function bulkRemove(){
  undoBuf=[...saved.value]
  saved.value=saved.value.filter(id=>!sel.value.includes(id));persist()
  flash(sel.value.length+' dihapus dari simpanan',true);sel.value=[];pick.value=false
}
function undo(){ if(undoBuf){saved.value=undoBuf;persist();undoBuf=null;flash('Dikembalikan')} }
function setView(v){view.value=v;window.scrollTo({top:0,behavior:'smooth'})}
function reset(){q.value='';cat.value='all';geo.value='all';sort.value='pop';view.value='all'}
function sheetDown(e){dragY.value=e.clientY}
function sheetMove(e){if(dragY.value===null)return;sheetY.value=Math.max(0,e.clientY-dragY.value)}
function sheetUp(){if(sheetY.value>120)closeDetail();sheetY.value=0;dragY.value=null}
</script>
<template>
<main class="tp">
  <header class="bar">
    <button class="ib" @click="router.push('/')" aria-label="Kembali"><Icon name="back" :size="19"/></button>
    <label class="sb"><Icon name="search" :size="15"/>
      <input v-model="q" type="search" placeholder="Cari atraksi, kota, tiket…" aria-label="Cari destinasi"/>
      <button v-if="q" class="clr" @click="q=''" aria-label="Bersihkan"><Icon name="x" :size="13"/></button>
    </label>
    <button class="ib rel" @click="setView('saved')" aria-label="Simpanan">
      <Icon name="bookmark" :size="19"/><i v-if="saved.length" class="dot">{{saved.length}}</i>
    </button>
  </header>

  <section class="hero">
    <div class="hg"/>
    <div class="hi">
      <span class="eyebrow"><Icon name="globe" :size="12"/>Xperience · tiket resmi</span>
      <h1>Jelajah hemat,<br/><em>cashback jalan.</em></h1>
      <p>{{rows.length}} destinasi terkurasi · mulai <b>{{rp(minP||0)}}</b> · cashback s/d 12,61% tiap pemesanan.</p>
      <div class="hstats">
        <div><b>{{rows.length}}</b><span>Destinasi</span></div>
        <div><b>{{geoList.length}}</b><span>Negara</span></div>
        <div><b>{{saved.length}}</b><span>Disimpan</span></div>
      </div>
    </div>
  </section>

  <nav class="rail" aria-label="Kategori">
    <button v-for="[k,ic,label] in CATS" :key="k" :class="{on:cat===k}" @click="cat=k">
      <span class="ri"><Icon :name="ic" :size="18"/></span>
      <span class="rl">{{label}}</span><i class="rn">{{catCount[k]||0}}</i>
    </button>
  </nav>

  <section class="deal">
    <div class="dh">
      <h2><Icon name="flame" :size="16"/>Deal Harian</h2>
      <span class="timer"><Icon name="clock" :size="12"/>{{cd}}</span>
    </div>
    <div class="dstrip">
      <button v-for="o in dealRows" :key="'d'+o.id" class="dc" @click="openDetail(o)">
        <img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/>
        <span class="dp">{{rp(o.price)}}</span>
        <span class="dn">{{o.title}}</span>
        <em class="dcb">+{{rp(cb(o.price))}}</em>
      </button>
    </div>
  </section>

  <div class="tools">
    <div class="chips">
      <button :class="{on:geo==='all'}" @click="geo='all'">Semua negara</button>
      <button v-for="g in geoList" :key="g.k" :class="{on:geo===g.k}" @click="geo=g.k">{{g.k}}<i>{{g.n}}</i></button>
    </div>
    <div class="sorts">
      <label class="sel"><Icon name="sliders" :size="14"/>
        <select v-model="sort" aria-label="Urutkan">
          <option value="pop">Populer</option><option value="cheap">Termurah</option>
          <option value="high">Termahal</option><option value="az">A–Z</option>
        </select>
      </label>
      <button class="pickb" :class="{on:pick}" @click="pick=!pick;sel=[]"><Icon name="check" :size="14"/>{{pick?'Selesai':'Pilih'}}</button>
    </div>
  </div>

  <div class="resline">
    <span><b>{{base.length}}</b> destinasi<template v-if="q"> · “{{q}}”</template></span>
    <button v-if="q||cat!=='all'||geo!=='all'||sort!=='pop'" class="rst" @click="reset">Reset</button>
  </div>

  <div v-if="state==='load'" class="grid">
    <div v-for="n in 8" :key="'s'+n" class="pc skel"><div class="si"/><div class="sl"/><div class="sl short"/></div>
  </div>
  <div v-else-if="state==='error'" class="state">
    <Icon name="refresh" :size="24"/><b>Katalog gagal dimuat</b>
    <small>Koneksi terputus. Simpanan lo tetap aman di perangkat.</small>
    <button class="btn" @click="load().then(()=>nextTick(reveal))">Muat ulang</button>
  </div>
  <div v-else-if="!base.length" class="state">
    <Icon name="search" :size="24"/><b>NOL hasil</b>
    <small v-if="view==='saved'">Belum ada destinasi tersimpan. Tap ikon simpan di kartu.</small>
    <small v-else>Tidak ada yang cocok dengan filter ini.</small>
    <button class="btn" @click="reset">Reset filter</button>
  </div>
  <div v-else class="grid" ref="gridEl">
    <article v-for="o in shown" :key="o.id" class="pc" :class="{sel:sel.includes(o.id)}" @click="tapCard(o)">
      <div class="pw">
        <img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/>
        <span class="pcat">{{o.cat==='PLAYGROUNDS'?'Arena Anak':o.cat==='ENTERTAINMENT'?'Hiburan':o.cat==='ATTRACTION'?'Atraksi':'Destinasi'}}</span>
        <button class="psave" :class="{on:isSaved(o.id)}" @click.stop="toggleSave(o)" :aria-label="isSaved(o.id)?'Hapus simpanan':'Simpan'">
          <Icon name="bookmark" :size="14"/>
        </button>
        <span v-if="pick" class="pcheck"><Icon v-if="sel.includes(o.id)" name="check" :size="13"/></span>
      </div>
      <div class="pb">
        <h3>{{o.title}}</h3>
        <span class="ploc"><Icon name="pin" :size="10"/>{{o.city||o.country}}</span>
        <div class="prow"><span class="pprice">{{rp(o.price)}}</span><span class="pcb">+{{rp(cb(o.price))}}</span></div>
        <span class="pnote">e-voucher · konfirmasi cepat</span>
      </div>
    </article>
  </div>

  <button v-if="shown.length<base.length" class="more" @click="limit+=24">Muat {{Math.min(24,base.length-shown.length)}} lagi · sisa {{base.length-shown.length}}</button>

  <nav class="tabs">
    <button :class="{on:view==='all'}" @click="setView('all')"><Icon name="grid" :size="18"/><span>Jelajah</span></button>
    <button :class="{on:view==='deal'}" @click="setView('deal')"><Icon name="flame" :size="18"/><span>Deal</span></button>
    <button :class="{on:view==='saved'}" @click="setView('saved')"><Icon name="bookmark" :size="18"/><span>Simpanan</span><i v-if="saved.length">{{saved.length}}</i></button>
    <button @click="router.push('/')"><Icon name="home" :size="18"/><span>Beranda</span></button>
  </nav>

  <div v-if="pick&&sel.length" class="bulk">
    <span>{{sel.length}} dipilih</span>
    <button @click="bulkSave"><Icon name="bookmark" :size="14"/>Simpan</button>
    <button class="danger" @click="bulkRemove"><Icon name="trash" :size="14"/>Hapus</button>
    <button class="ghost" @click="sel=[];pick=false">Batal</button>
  </div>

  <transition name="fade">
    <div v-if="toast" class="toast"><span>{{toast.msg}}</span><button v-if="toast.undo" @click="undo">Urungkan</button></div>
  </transition>

  <transition name="sheet">
    <div v-if="detail" class="ov" @click.self="closeDetail">
      <div class="sheet" :style="{transform:'translateY('+sheetY+'px)'}">
        <div class="grab" @pointerdown="sheetDown" @pointermove="sheetMove" @pointerup="sheetUp" @pointercancel="sheetUp"><i/></div>
        <button class="sx" @click="closeDetail" aria-label="Tutup"><Icon name="x" :size="17"/></button>
        <div class="simg"><img :src="detail.image_url" :alt="detail.title"/></div>
        <div class="sbody">
          <span class="scat">{{detail.cat==='PLAYGROUNDS'?'Arena Bermain Anak':detail.cat==='ENTERTAINMENT'?'Hiburan & Escape Room':detail.cat==='ATTRACTION'?'Atraksi & Wisata':'Destinasi'}} · {{detail.country}}</span>
          <h2>{{detail.title}}</h2>
          <div class="sloc"><Icon name="pin" :size="13"/>{{detail.city||detail.region||detail.country}}</div>
          <div class="sprice">
            <div><span class="spl">Harga per tiket</span><b>{{rp(detail.price)}}</b></div>
            <span class="scb"><Icon name="sparkle" :size="12"/>cashback s/d {{rp(cb(detail.price))}}</span>
          </div>
          <p class="sdesc">{{detail.brief||'Tiket resmi mitra. E-voucher dikirim setelah pembayaran, tunjukkan saat masuk lokasi.'}}</p>
          <div class="sqty">
            <span>Jumlah</span>
            <div class="stp">
              <button @click="qty=Math.max(1,qty-1)" aria-label="Kurangi"><Icon name="minus" :size="14"/></button>
              <b>{{qty}}</b>
              <button @click="qty=Math.min(10,qty+1)" aria-label="Tambah"><Icon name="plus" :size="14"/></button>
            </div>
          </div>
          <div class="stotal"><span>Perkiraan total</span><b>{{rp(detail.price*qty)}}</b></div>
          <div class="stotal cb2"><span>Perkiraan cashback</span><b>+{{rp(cb(detail.price*qty))}}</b></div>
          <ul class="slist">
            <li><Icon name="check" :size="13"/>E-voucher resmi, tanpa antre loket</li>
            <li><Icon name="check" :size="13"/>Konfirmasi & pembayaran di mitra terpercaya</li>
            <li><Icon name="check" :size="13"/>Cashback masuk saldo setelah transaksi tervalidasi</li>
          </ul>
        </div>
        <div class="sact">
          <button class="sico" :class="{on:isSaved(detail.id)}" @click="toggleSave(detail)" aria-label="Simpan"><Icon name="bookmark" :size="18"/></button>
          <button class="sico" @click="share(detail)" aria-label="Bagikan"><Icon name="share" :size="18"/></button>
          <button class="sbuy" @click="buy(detail)">Pesan Sekarang · {{rp(detail.price*qty)}}</button>
        </div>
      </div>
    </div>
  </transition>
</main>
</template>
<style scoped>
.tp{--deep:#04222B;--surf:#0C333D;--surf2:#10404B;--teal:#00B8A9;--mint:#7CF5D8;--sky:#2F6BFF;--amber:#FFB300;--coral:#FF5A4E;--ink:#EAF7F7;--mute:#8FC7C2;
 min-height:100vh;background:var(--deep);color:var(--ink);padding-bottom:132px;font-family:system-ui,-apple-system,sans-serif;overflow-x:hidden}
.tp::-webkit-scrollbar,.dstrip::-webkit-scrollbar,.rail::-webkit-scrollbar,.chips::-webkit-scrollbar,.sbody::-webkit-scrollbar{width:6px;height:6px}
.tp::-webkit-scrollbar-track,.dstrip::-webkit-scrollbar-track,.rail::-webkit-scrollbar-track,.chips::-webkit-scrollbar-track,.sbody::-webkit-scrollbar-track{background:rgba(255,255,255,.05)}
.tp::-webkit-scrollbar-thumb,.dstrip::-webkit-scrollbar-thumb,.rail::-webkit-scrollbar-thumb,.chips::-webkit-scrollbar-thumb,.sbody::-webkit-scrollbar-thumb{background:linear-gradient(180deg,var(--teal),var(--sky));border-radius:99px}
.bar{position:sticky;top:0;z-index:40;display:flex;gap:9px;align-items:center;padding:calc(9px + env(safe-area-inset-top)) 12px 9px;
 background:rgba(4,34,43,.88);backdrop-filter:blur(14px);border-bottom:1px solid rgba(0,184,169,.18)}
.ib{position:relative;flex:0 0 auto;width:38px;height:38px;display:grid;place-items:center;border:1px solid rgba(255,255,255,.12);border-radius:12px;background:rgba(255,255,255,.05);color:var(--ink);cursor:pointer}
.ib:active{transform:scale(.93)}
.dot{position:absolute;top:-5px;right:-5px;min-width:17px;height:17px;padding:0 4px;border-radius:99px;background:var(--coral);color:#fff;font-size:9px;font-weight:900;font-style:normal;display:grid;place-items:center;border:2px solid var(--deep)}
.sb{flex:1;display:flex;gap:8px;align-items:center;background:rgba(255,255,255,.07);border:1px solid rgba(0,184,169,.32);border-radius:12px;padding:9px 11px;color:var(--mute);min-width:0}
.sb input{flex:1;min-width:0;background:none;border:0;outline:none;color:var(--ink);font-size:13px}
.sb input::placeholder{color:#6f9ea3}
.clr{border:0;background:none;color:var(--mute);cursor:pointer;display:grid;place-items:center}
.hero{position:relative;padding:20px 16px 18px;overflow:hidden}
.hg{position:absolute;inset:0;background:
 radial-gradient(70% 90% at 12% 0%,rgba(0,184,169,.30),transparent 62%),
 radial-gradient(60% 80% at 92% 12%,rgba(47,107,255,.28),transparent 65%),
 linear-gradient(160deg,#052a34,#04222B)}
.hg::after{content:'';position:absolute;inset:0;opacity:.35;background-image:radial-gradient(rgba(124,245,216,.16) 1px,transparent 1px);background-size:16px 16px}
.hi{position:relative;max-width:1280px;margin:0 auto}
.eyebrow{display:inline-flex;gap:6px;align-items:center;font-size:10px;font-weight:800;letter-spacing:.4px;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));padding:4px 10px;border-radius:999px}
.hi h1{margin:11px 0 7px;font-size:29px;line-height:1.08;font-weight:900;letter-spacing:-.6px;color:#fff}
.hi h1 em{font-style:normal;background:linear-gradient(100deg,var(--amber),var(--coral));-webkit-background-clip:text;background-clip:text;color:transparent}
.hi p{margin:0;font-size:12.5px;line-height:1.5;color:#b8ded9;max-width:440px}
.hi p b{color:var(--amber)}
.hstats{display:flex;gap:9px;margin-top:14px}
.hstats div{flex:1;background:rgba(255,255,255,.05);border:1px solid rgba(0,184,169,.22);border-radius:13px;padding:9px 11px}
.hstats b{display:block;font-size:17px;font-weight:900;color:var(--mint)}
.hstats span{font-size:9.5px;color:var(--mute);font-weight:700}
.rail{display:flex;gap:8px;overflow-x:auto;padding:14px 14px 12px;scroll-snap-type:x proximity;max-width:1280px;margin:0 auto}
.rail button{flex:0 0 82px;scroll-snap-align:start;display:flex;flex-direction:column;align-items:center;gap:5px;border:0;background:none;color:var(--mute);cursor:pointer;padding:0}
.ri{width:52px;height:52px;display:grid;place-items:center;border-radius:17px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.10);color:var(--mint);transition:transform .16s,background .16s,box-shadow .16s}
.rail button:active .ri{transform:scale(.92)}
.rail button.on .ri{background:linear-gradient(140deg,var(--teal),var(--sky));color:#04222B;border-color:transparent;box-shadow:0 8px 20px rgba(0,184,169,.32)}
.rl{font-size:10.5px;font-weight:800;color:#cfe9e9;text-align:center;line-height:1.15}
.rail button.on .rl{color:#fff}
.rn{font-style:normal;font-size:9px;font-weight:800;color:#04222B;background:rgba(124,245,216,.85);border-radius:99px;padding:1px 6px}
.deal{margin:4px 0 6px;padding:12px 0 14px;background:linear-gradient(120deg,rgba(255,90,78,.14),rgba(255,179,0,.10));border-top:1px solid rgba(255,179,0,.22);border-bottom:1px solid rgba(255,179,0,.22)}
.dh{display:flex;justify-content:space-between;align-items:center;padding:0 14px 10px;max-width:1280px;margin:0 auto}
.dh h2{display:flex;gap:7px;align-items:center;margin:0;font-size:15px;font-weight:900;color:#fff}
.dh h2 :deep(svg){color:var(--coral)}
.timer{display:flex;gap:5px;align-items:center;font-size:12px;font-weight:900;font-variant-numeric:tabular-nums;color:#2b1600;background:linear-gradient(135deg,var(--amber),#FF8A3D);padding:4px 10px;border-radius:999px}
.dstrip{display:flex;gap:10px;overflow-x:auto;padding:0 14px 4px;scroll-snap-type:x mandatory;max-width:1280px;margin:0 auto}
.dc{flex:0 0 128px;scroll-snap-align:start;position:relative;border:1px solid rgba(255,179,0,.25);background:var(--surf);border-radius:14px;padding:7px;cursor:pointer;color:var(--ink);text-align:left;transition:transform .14s}
.dc:active{transform:scale(.95)}
.dc img{width:100%;height:82px;object-fit:cover;border-radius:10px;background:#0a2c35}
.dp{display:block;font-size:12.5px;font-weight:900;color:var(--amber);margin-top:6px}
.dn{display:block;font-size:9.5px;line-height:1.25;height:2.5em;overflow:hidden;color:#cfe9e9;margin-top:2px}
.dcb{position:absolute;top:11px;right:11px;font-style:normal;font-size:8px;font-weight:900;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));padding:2px 5px;border-radius:99px}
.tools{max-width:1280px;margin:0 auto;padding:12px 14px 0}
.chips{display:flex;gap:7px;overflow-x:auto;padding-bottom:9px}
.chips button{flex:0 0 auto;display:flex;gap:5px;align-items:center;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.05);color:#cfe9e9;border-radius:999px;padding:7px 13px;font-size:11.5px;font-weight:800;cursor:pointer;transition:transform .14s}
.chips button:active{transform:scale(.94)}
.chips button.on{background:linear-gradient(135deg,var(--teal),var(--sky));border-color:transparent;color:#04222B}
.chips button i{font-style:normal;font-size:9.5px;opacity:.75}
.sorts{display:flex;gap:8px;align-items:center}
.sel{flex:1;display:flex;gap:7px;align-items:center;background:rgba(255,255,255,.05);border:1px solid rgba(47,107,255,.35);border-radius:11px;padding:8px 11px;color:var(--mute)}
.sel select{flex:1;background:none;border:0;outline:none;color:var(--ink);font-size:12px;font-weight:800}
.sel select option{background:#0C333D;color:#EAF7F7}
.pickb{display:flex;gap:6px;align-items:center;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.05);color:#cfe9e9;border-radius:11px;padding:8px 13px;font-size:12px;font-weight:800;cursor:pointer}
.pickb.on{background:linear-gradient(135deg,var(--teal),var(--mint));color:#04222B;border-color:transparent}
.resline{display:flex;justify-content:space-between;align-items:center;max-width:1280px;margin:0 auto;padding:11px 14px 9px;font-size:11.5px;color:var(--mute)}
.resline b{color:var(--mint);font-size:13px}
.rst{border:0;background:none;color:var(--amber);font-size:11.5px;font-weight:800;cursor:pointer}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;max-width:1280px;margin:0 auto;padding:0 12px}
@media(min-width:640px){.grid{grid-template-columns:repeat(3,1fr)}}
@media(min-width:960px){.grid{grid-template-columns:repeat(4,1fr);gap:14px}}
@media(min-width:1240px){.grid{grid-template-columns:repeat(5,1fr)}}
.pc{background:var(--surf);border:1px solid rgba(255,255,255,.07);border-radius:16px;overflow:hidden;cursor:pointer;
 opacity:0;transform:translateY(14px);transition:opacity .4s ease,transform .4s cubic-bezier(.22,1,.36,1),border-color .16s,box-shadow .16s}
.pc.in{opacity:1;transform:none}
.pc:active{border-color:rgba(0,184,169,.55);box-shadow:0 8px 22px rgba(0,0,0,.35)}
.pc.sel{border-color:var(--teal);box-shadow:0 0 0 2px rgba(0,184,169,.35)}
.pw{position:relative;aspect-ratio:1/1;background:#0a2c35}
.pw img{width:100%;height:100%;object-fit:cover;object-position:center;display:block}
.pcat{position:absolute;left:7px;bottom:7px;font-size:8.5px;font-weight:900;color:#04222B;background:rgba(124,245,216,.92);padding:2px 7px;border-radius:99px}
.psave{position:absolute;top:7px;right:7px;width:28px;height:28px;display:grid;place-items:center;border:0;border-radius:10px;background:rgba(4,34,43,.66);color:#cfe9e9;cursor:pointer;backdrop-filter:blur(4px)}
.psave.on{background:linear-gradient(135deg,var(--amber),var(--coral));color:#2b1600}
.pcheck{position:absolute;top:7px;left:7px;width:22px;height:22px;display:grid;place-items:center;border-radius:8px;border:2px solid rgba(255,255,255,.75);background:rgba(4,34,43,.6);color:#04222B}
.pc.sel .pcheck{background:var(--teal);border-color:var(--teal)}
.pb{padding:9px 9px 11px}
.pb h3{margin:0;font-size:11.5px;font-weight:700;line-height:1.3;height:2.6em;overflow:hidden;color:#fff}
.ploc{display:flex;gap:4px;align-items:center;font-size:9.5px;color:var(--mute);margin-top:5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.prow{display:flex;justify-content:space-between;align-items:baseline;gap:6px;margin-top:6px}
.pprice{font-size:14px;font-weight:900;color:var(--amber)}
.pcb{font-size:8.5px;font-weight:900;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));padding:2px 6px;border-radius:99px;white-space:nowrap}
.pnote{display:block;font-size:8.5px;color:#6f9ea3;margin-top:5px}
.skel{opacity:1;transform:none;padding:0 0 12px}
.si{aspect-ratio:1/1;background:linear-gradient(100deg,#0C333D 30%,#14454F 50%,#0C333D 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
.sl{height:10px;margin:9px 9px 0;border-radius:6px;background:linear-gradient(100deg,#0C333D 30%,#14454F 50%,#0C333D 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
.sl.short{width:55%}
@keyframes sh{from{background-position:120% 0}to{background-position:-20% 0}}
.state{display:flex;flex-direction:column;align-items:center;gap:9px;text-align:center;padding:46px 24px;color:var(--mute)}
.state b{font-size:15px;color:#fff}
.state small{font-size:12px;max-width:300px;line-height:1.5}
.btn{margin-top:5px;border:0;border-radius:999px;padding:10px 20px;font-weight:900;font-size:12px;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));cursor:pointer}
.more{display:block;width:calc(100% - 24px);max-width:1256px;margin:14px auto 0;border:1px solid rgba(0,184,169,.4);background:rgba(0,184,169,.1);color:var(--mint);border-radius:13px;padding:12px;font-size:12px;font-weight:800;cursor:pointer}
.tabs{position:fixed;left:0;right:0;bottom:0;z-index:45;display:flex;justify-content:space-around;
 background:rgba(6,38,47,.94);backdrop-filter:blur(16px);border-top:1px solid rgba(0,184,169,.22);padding:7px 4px calc(7px + env(safe-area-inset-bottom))}
.tabs button{position:relative;flex:1;display:flex;flex-direction:column;align-items:center;gap:3px;border:0;background:none;color:#6f9ea3;font-size:9.5px;font-weight:800;cursor:pointer;padding:4px 0;transition:color .16s,transform .16s}
.tabs button:active{transform:scale(.92)}
.tabs button.on{color:var(--mint)}
.tabs button i{position:absolute;top:0;right:22%;min-width:15px;height:15px;padding:0 4px;border-radius:99px;background:var(--coral);color:#fff;font-size:8px;font-style:normal;display:grid;place-items:center}
.bulk{position:fixed;left:12px;right:12px;bottom:calc(70px + env(safe-area-inset-bottom));z-index:46;display:flex;gap:7px;align-items:center;
 background:linear-gradient(135deg,#0d3b46,#10404B);border:1px solid rgba(0,184,169,.45);border-radius:15px;padding:9px 11px;box-shadow:0 12px 30px rgba(0,0,0,.45)}
.bulk span{flex:1;font-size:11.5px;font-weight:800;color:var(--mint)}
.bulk button{display:flex;gap:5px;align-items:center;border:0;border-radius:10px;padding:8px 11px;font-size:11px;font-weight:900;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));cursor:pointer}
.bulk button.danger{background:linear-gradient(135deg,var(--coral),#FF8A3D);color:#fff}
.bulk button.ghost{background:rgba(255,255,255,.08);color:#cfe9e9}
.toast{position:fixed;left:12px;right:12px;bottom:calc(70px + env(safe-area-inset-bottom));z-index:60;display:flex;gap:10px;align-items:center;justify-content:space-between;
 background:#0d3b46;border:1px solid rgba(124,245,216,.4);border-radius:13px;padding:11px 14px;font-size:12px;color:var(--ink);box-shadow:0 12px 30px rgba(0,0,0,.5)}
.toast button{border:0;background:none;color:var(--amber);font-weight:900;font-size:12px;cursor:pointer}
.fade-enter-active,.fade-leave-active{transition:opacity .22s,transform .22s}
.fade-enter-from,.fade-leave-to{opacity:0;transform:translateY(10px)}
.ov{position:fixed;inset:0;z-index:70;background:rgba(2,16,21,.72);backdrop-filter:blur(6px);display:flex;align-items:flex-end;justify-content:center}
.sheet{position:relative;width:100%;max-width:560px;max-height:92vh;display:flex;flex-direction:column;background:linear-gradient(180deg,#0d3b46,#04222B);
 border:1px solid rgba(0,184,169,.3);border-radius:24px 24px 0 0;overflow:hidden;box-shadow:0 -18px 50px rgba(0,0,0,.6);transition:transform .18s}
.grab{padding:10px 0 4px;display:grid;place-items:center;cursor:grab;touch-action:none}
.grab i{width:44px;height:4px;border-radius:99px;background:rgba(124,245,216,.55)}
.sx{position:absolute;top:12px;right:12px;z-index:3;width:32px;height:32px;display:grid;place-items:center;border:0;border-radius:11px;background:rgba(4,34,43,.7);color:#cfe9e9;cursor:pointer}
.simg{height:190px;background:#072a33;flex:0 0 auto}
.simg img{width:100%;height:100%;object-fit:contain}
.sbody{flex:1;overflow-y:auto;padding:14px 16px 8px}
.scat{font-size:9.5px;font-weight:900;letter-spacing:.3px;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));padding:3px 9px;border-radius:99px}
.sbody h2{margin:10px 0 6px;font-size:19px;line-height:1.2;font-weight:900;color:#fff}
.sloc{display:flex;gap:5px;align-items:center;font-size:11.5px;color:var(--mute)}
.sprice{display:flex;justify-content:space-between;align-items:center;gap:10px;margin:13px 0;padding:11px 13px;border-radius:14px;background:rgba(255,179,0,.10);border:1px solid rgba(255,179,0,.28)}
.spl{display:block;font-size:9.5px;color:var(--mute);font-weight:700}
.sprice b{font-size:21px;font-weight:900;color:var(--amber)}
.scb{display:flex;gap:5px;align-items:center;font-size:10px;font-weight:900;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));padding:5px 9px;border-radius:99px;text-align:right}
.sdesc{margin:0 0 13px;font-size:12.5px;line-height:1.6;color:#bcded9}
.sqty{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-top:1px solid rgba(255,255,255,.08);font-size:12.5px;font-weight:800;color:#cfe9e9}
.stp{display:flex;gap:12px;align-items:center}
.stp button{width:30px;height:30px;display:grid;place-items:center;border:1px solid rgba(0,184,169,.4);border-radius:10px;background:rgba(0,184,169,.12);color:var(--mint);cursor:pointer}
.stp button:active{transform:scale(.9)}
.stp b{min-width:20px;text-align:center;font-size:15px;color:#fff}
.stotal{display:flex;justify-content:space-between;align-items:center;padding:8px 0;font-size:12.5px;color:var(--mute);border-top:1px solid rgba(255,255,255,.08)}
.stotal b{font-size:16px;color:#fff}
.stotal.cb2 b{color:var(--mint)}
.slist{list-style:none;margin:12px 0 4px;padding:0;display:flex;flex-direction:column;gap:7px}
.slist li{display:flex;gap:8px;align-items:flex-start;font-size:11.5px;color:#a9d4d0;line-height:1.4}
.slist li :deep(svg){flex:0 0 auto;margin-top:1px;color:var(--teal)}
.sact{flex:0 0 auto;display:flex;gap:8px;align-items:center;padding:11px 14px calc(12px + env(safe-area-inset-bottom));border-top:1px solid rgba(0,184,169,.22);background:rgba(4,34,43,.9)}
.sico{width:44px;height:44px;flex:0 0 auto;display:grid;place-items:center;border:1px solid rgba(255,255,255,.14);border-radius:13px;background:rgba(255,255,255,.05);color:#cfe9e9;cursor:pointer}
.sico.on{background:linear-gradient(135deg,var(--amber),var(--coral));color:#2b1600;border-color:transparent}
.sbuy{flex:1;border:0;border-radius:13px;padding:14px;font-size:13.5px;font-weight:900;color:#04222B;background:linear-gradient(135deg,var(--teal),var(--mint));cursor:pointer;box-shadow:0 8px 22px rgba(0,184,169,.35)}
.sbuy:active{transform:scale(.98)}
.sheet-enter-active,.sheet-leave-active{transition:opacity .24s}
.sheet-enter-active .sheet,.sheet-leave-active .sheet{transition:transform .28s cubic-bezier(.22,1,.36,1)}
.sheet-enter-from,.sheet-leave-to{opacity:0}
.sheet-enter-from .sheet,.sheet-leave-to .sheet{transform:translateY(100%)}
@media(min-width:960px){.hi h1{font-size:38px}.hero{padding:30px 20px 24px}.simg{height:240px}}
</style>
