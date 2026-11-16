<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const P=defineProps({
  network:{type:String,required:true},
  brand:{type:String,required:true},
  tagline:{type:String,default:''},
  hue:{type:String,default:'fusion'},
  ic:{type:String,default:'store'},
  rate:{type:Number,default:0}
})
const route=useRoute(); const router=useRouter()
const rows=ref([]); const state=ref('load'); const q=ref(''); const cat=ref('all'); const geo=ref('all')
const sort=ref('pop'); const view=ref('all'); const saved=ref([]); const detail=ref(null); const qty=ref(1)
const pick=ref(false); const sel=ref([]); const limit=ref(24); const toast=ref(null); const now=ref(Date.now())
const gridEl=ref(null); const sheetY=ref(0); const dragY=ref(null)
const KEY=computed(()=>'shop_saved_'+P.network)
let clock=null,tT=null,io=null,undoBuf=null
function rp(n){return 'Rp'+Number(n||0).toLocaleString('id-ID')}
function pad(n){return String(n).padStart(2,'0')}
function rateOf(r){return Number(r.rate||P.rate||0)}
function cb(r){return r.price?Math.round(r.price*rateOf(r)/100):0}
const hasPrice=computed(()=>rows.value.some(r=>r.price>0))
const midnight=computed(()=>{const d=new Date(now.value);d.setHours(24,0,0,0);return d.getTime()})
const cd=computed(()=>{const s=Math.max(0,Math.floor((midnight.value-now.value)/1000));return pad(Math.floor(s/3600))+':'+pad(Math.floor(s%3600/60))+':'+pad(s%60)})
function rng(seed){let t=seed>>>0;return()=>{t+=0x6D2B79F5;let r=Math.imul(t^t>>>15,1|t);r^=r+Math.imul(r^r>>>7,61|r);return((r^r>>>14)>>>0)/4294967296}}
async function load(){
  state.value='load'
  const {data,error}=await supabase.from('shoper_offers').select('*').eq('network',P.network).eq('active',true).limit(400)
  if(error){state.value='error';return}
  rows.value=(data||[]).map(r=>{
    const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{})
    return {...r,
      cat:(m.cat||m.category||'ALL').toString().toUpperCase(),
      city:m.city||m.region||'',country:m.country||m.region||'',
      brief:m.brief||m.description||'',bonus:m.bonus||'',
      rating:m.rating||'',sold:m.sold||'',
      list:(m.price_list&&m.price_list>r.price)?m.price_list:0,
      rate:m.rate_max||r.commission||0,
      dens:Array.isArray(m.dens)?m.dens:[]}
  })
  state.value=rows.value.length?'ok':'empty'
}
onMounted(async()=>{
  try{const s=localStorage.getItem(KEY.value);if(s)saved.value=JSON.parse(s)||[]}catch(_){}
  if(P.network==='traveloka'){try{const o=localStorage.getItem('tv_saved_v1');if(o){const a=JSON.parse(o)||[];if(a.length){saved.value=Array.from(new Set([...saved.value,...a]));persist()}}}catch(_){}}
  await load()
  const p=route.query.p
  if(p){const hit=rows.value.find(r=>r.external_id===String(p));if(hit)openDetail(hit)}
  if(hasPrice.value)clock=setInterval(()=>now.value=Date.now(),1000)
  await nextTick();reveal()
})
onUnmounted(()=>{clearInterval(clock);clearTimeout(tT);io&&io.disconnect();document.body.style.overflow=''})
function persist(){try{localStorage.setItem(KEY.value,JSON.stringify(saved.value))}catch(_){}}
function flash(msg,undo){clearTimeout(tT);toast.value={msg,undo:!!undo};tT=setTimeout(()=>{toast.value=null;undoBuf=null},4200)}
function isSaved(id){return saved.value.includes(id)}
function toggleSave(o){
  if(isSaved(o.id)){saved.value=saved.value.filter(x=>x!==o.id);flash('Dihapus dari simpanan')}
  else{saved.value=[...saved.value,o.id];flash('Tersimpan · '+String(o.title).slice(0,26))}
  persist()
}
const cats=computed(()=>{
  const m={};for(const r of rows.value)m[r.cat]=(m[r.cat]||0)+1
  const keys=Object.keys(m).sort((a,b)=>m[b]-m[a]).slice(0,6)
  return [['all','grid','Semua',rows.value.length],...keys.map(k=>[k,iconFor(k),labelFor(k),m[k]])]
})
function iconFor(k){
  if(/PLAYGROUND|ARENA|KID/.test(k))return 'sparkle'
  if(/ENTERTAIN|HIBUR|ESCAPE|STREAM|GENZ/.test(k))return 'ticket'
  if(/ATTRACT|WISATA|TRAVEL|TRIP/.test(k))return 'compass'
  if(/VOUCHER|GIFT/.test(k))return 'gift'
  if(/COWOK|GAME/.test(k))return 'gamepad'
  if(/CEWEK/.test(k))return 'heart'
  if(/PC|MONITOR/.test(k))return 'monitor'
  return 'store'
}
function labelFor(k){
  const M={ATTRACTION:'Atraksi',ENTERTAINMENT:'Hiburan',PLAYGROUNDS:'Arena Anak',OTHER:'Lainnya',ALL:'Semua',
    COWOK:'Cowok',CEWEK:'Cewek',VOUCHER:'Voucher',GENZ:'Gen Z',STREAM:'Streaming',PC:'PC',PARTNER:'Partner',TRIP:'Trip'}
  return M[k]||k.charAt(0)+k.slice(1).toLowerCase()
}
const geos=computed(()=>{
  const m={};for(const r of rows.value){const k=r.city||r.country;if(k)m[k]=(m[k]||0)+1}
  return Object.keys(m).sort((a,b)=>m[b]-m[a]).slice(0,8).map(k=>({k,n:m[k]}))
})
const dealRows=computed(()=>{
  if(!hasPrice.value)return []
  const day=Math.floor(now.value/86400000),r=rng(day+11)
  return rows.value.filter(x=>x.price>0).map(x=>({x,k:r()})).sort((a,b)=>(a.x.price-b.x.price)||a.k-b.k).slice(0,14).map(o=>o.x)
})
const base=computed(()=>{
  let a=rows.value
  if(view.value==='saved')a=a.filter(r=>isSaved(r.id))
  if(view.value==='deal'){const s=new Set(dealRows.value.map(r=>r.id));a=a.filter(r=>s.has(r.id))}
  if(cat.value!=='all')a=a.filter(r=>r.cat===cat.value)
  if(geo.value!=='all')a=a.filter(r=>(r.city||r.country)===geo.value)
  const t=q.value.trim().toLowerCase()
  if(t)a=a.filter(r=>(r.title+' '+r.city+' '+r.country+' '+r.brief+' '+r.cat).toLowerCase().includes(t))
  if(sort.value==='cheap')a=[...a].sort((x,y)=>(x.price||0)-(y.price||0))
  else if(sort.value==='high')a=[...a].sort((x,y)=>(y.price||0)-(x.price||0))
  else if(sort.value==='az')a=[...a].sort((x,y)=>String(x.title).localeCompare(String(y.title)))
  return a
})
const shown=computed(()=>base.value.slice(0,limit.value))
const minP=computed(()=>{const p=base.value.filter(r=>r.price>0).map(r=>r.price);return p.length?Math.min.apply(null,p):0})
watch([q,cat,geo,sort,view],()=>{limit.value=24;sel.value=[];nextTick(reveal)})
watch(shown,()=>nextTick(reveal))
function reveal(){
  if(!gridEl.value)return
  io&&io.disconnect()
  io=new IntersectionObserver(es=>es.forEach(e=>{if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target)}}),{rootMargin:'140px'})
  gridEl.value.querySelectorAll('.pc:not(.in)').forEach(el=>io.observe(el))
}
function openDetail(o){detail.value=o;qty.value=1;sheetY.value=0;document.body.style.overflow='hidden'}
function closeDetail(){detail.value=null;document.body.style.overflow='';if(route.query.p)router.replace(router.currentRoute.value.path)}
function buy(o){window.open(o.url,'_blank','noopener')}
async function share(o){
  const url=location.origin+router.currentRoute.value.path+'?p='+encodeURIComponent(o.external_id)
  try{if(navigator.share){await navigator.share({title:o.title,text:o.title,url});return}}catch(_){}
  try{await navigator.clipboard.writeText(url);flash('Tautan disalin')}catch(_){flash('Tautan siap dibagikan')}
}
function tapCard(o){pick.value?toggleSel(o.id):openDetail(o)}
function toggleSel(id){sel.value=sel.value.includes(id)?sel.value.filter(x=>x!==id):[...sel.value,id]}
function bulkSave(){const add=sel.value.filter(id=>!isSaved(id));saved.value=[...saved.value,...add];persist();flash(add.length+' disimpan');sel.value=[];pick.value=false}
function bulkRemove(){undoBuf=[...saved.value];saved.value=saved.value.filter(id=>!sel.value.includes(id));persist();flash(sel.value.length+' dihapus',true);sel.value=[];pick.value=false}
function undo(){if(undoBuf){saved.value=undoBuf;persist();undoBuf=null;flash('Dikembalikan')}}
function setView(v){view.value=v;window.scrollTo({top:0,behavior:'smooth'})}
function reset(){q.value='';cat.value='all';geo.value='all';sort.value='pop';view.value='all'}
function sDown(e){dragY.value=e.clientY}
function sMove(e){if(dragY.value===null)return;sheetY.value=Math.max(0,e.clientY-dragY.value)}
function sUp(){if(sheetY.value>120)closeDetail();sheetY.value=0;dragY.value=null}
</script>
<template>
<main class="sp" :class="'hue-'+hue">
  <header class="bar">
    <button class="ib" @click="router.push('/')" aria-label="Beranda"><Icon name="back" :size="19"/></button>
    <label class="sb"><Icon name="search" :size="15"/>
      <input v-model="q" type="search" :placeholder="'Cari di '+brand+'…'" aria-label="Cari"/>
      <button v-if="q" class="clr" @click="q=''" aria-label="Bersihkan"><Icon name="x" :size="13"/></button>
    </label>
    <button class="ib" @click="setView('saved')" aria-label="Simpanan">
      <Icon name="bookmark" :size="19"/><i v-if="saved.length" class="dot">{{saved.length}}</i>
    </button>
  </header>

  <section class="hero">
    <div class="hg"/>
    <div class="hi">
      <span class="eyebrow"><Icon :name="ic" :size="12"/>{{brand}}</span>
      <h1>{{tagline}}</h1>
      <div class="hstats">
        <div><b>{{rows.length}}</b><span>Item</span></div>
        <div><b>{{geos.length}}</b><span>Lokasi</span></div>
        <div><b>{{saved.length}}</b><span>Disimpan</span></div>
        <div v-if="minP"><b>{{rp(minP)}}</b><span>Mulai</span></div>
      </div>
    </div>
  </section>

  <nav class="rail" aria-label="Kategori">
    <button v-for="[k,i,l,n] in cats" :key="k" :class="{on:cat===k}" @click="cat=k">
      <span class="ri"><Icon :name="i" :size="18"/></span><span class="rl">{{l}}</span><i class="rn">{{n}}</i>
    </button>
  </nav>

  <section v-if="hasPrice&&dealRows.length" class="deal">
    <div class="dh"><h2><Icon name="flame" :size="16"/>Deal Harian</h2><span class="timer"><Icon name="clock" :size="12"/>{{cd}}</span></div>
    <div class="dstrip">
      <button v-for="o in dealRows" :key="'d'+o.id" class="dc" @click="openDetail(o)">
        <img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/>
        <span class="dp">{{rp(o.price)}}</span><span class="dn">{{o.title}}</span>
        <em v-if="cb(o)" class="dcb">+{{rp(cb(o))}}</em>
      </button>
    </div>
  </section>

  <div class="tools">
    <div class="chips">
      <button :class="{on:geo==='all'}" @click="geo='all'">Semua lokasi</button>
      <button v-for="g in geos" :key="g.k" :class="{on:geo===g.k}" @click="geo=g.k">{{g.k}}<i>{{g.n}}</i></button>
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
    <span><b>{{base.length}}</b> item<template v-if="q"> · “{{q}}”</template></span>
    <button v-if="q||cat!=='all'||geo!=='all'||sort!=='pop'" class="rst" @click="reset">Reset</button>
  </div>

  <div v-if="state==='load'" class="grid"><div v-for="n in 8" :key="'s'+n" class="pc skel"><div class="si"/><div class="sl"/><div class="sl short"/></div></div>
  <div v-else-if="state==='error'" class="state"><Icon name="refresh" :size="24"/><b>Gagal memuat</b><small>Koneksi terputus. Simpanan tetap aman di perangkat.</small><button class="btn" @click="load().then(()=>nextTick(reveal))">Muat ulang</button></div>
  <div v-else-if="!base.length" class="state"><Icon name="search" :size="24"/><b>NOL hasil</b>
    <small v-if="view==='saved'">Belum ada yang disimpan. Tap ikon simpan di kartu.</small><small v-else>Tidak ada yang cocok dengan filter ini.</small>
    <button class="btn" @click="reset">Reset filter</button></div>
  <div v-else class="grid" ref="gridEl">
    <article v-for="o in shown" :key="o.id" class="pc" :class="{sel:sel.includes(o.id)}" @click="tapCard(o)">
      <div class="pw">
        <img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/>
        <span v-if="o.list" class="poff">-{{Math.round((1-o.price/o.list)*100)}}%</span>
        <span v-else-if="o.bonus" class="poff alt">{{o.bonus}}</span>
        <button class="psave" :class="{on:isSaved(o.id)}" @click.stop="toggleSave(o)" aria-label="Simpan"><Icon name="bookmark" :size="14"/></button>
        <span v-if="pick" class="pcheck"><Icon v-if="sel.includes(o.id)" name="check" :size="13"/></span>
      </div>
      <div class="pb">
        <h3>{{o.title}}</h3>
        <span v-if="o.city||o.country" class="ploc"><Icon name="pin" :size="10"/>{{o.city||o.country}}</span>
        <div class="prow">
          <span class="pprice">{{o.price?rp(o.price):'Lihat promo'}}</span>
          <span v-if="cb(o)" class="pcb">+{{rp(cb(o))}}</span>
        </div>
        <span v-if="o.list" class="pstrike">{{rp(o.list)}}</span>
        <span class="pnote">
          <template v-if="o.rating&&o.rating!=='0'">★ {{o.rating}}<template v-if="o.sold&&o.sold!=='0'"> · {{o.sold}} terjual</template></template>
          <template v-else>{{labelFor(o.cat)}} · resmi</template>
        </span>
      </div>
    </article>
  </div>

  <button v-if="shown.length<base.length" class="more" @click="limit+=24">Muat {{Math.min(24,base.length-shown.length)}} lagi · sisa {{base.length-shown.length}}</button>

  <nav class="tabs">
    <button :class="{on:view==='all'}" @click="setView('all')"><Icon name="grid" :size="18"/><span>Jelajah</span></button>
    <button v-if="hasPrice" :class="{on:view==='deal'}" @click="setView('deal')"><Icon name="flame" :size="18"/><span>Deal</span></button>
    <button :class="{on:view==='saved'}" @click="setView('saved')"><Icon name="bookmark" :size="18"/><span>Simpanan</span><i v-if="saved.length">{{saved.length}}</i></button>
    <button @click="router.push('/akun')"><Icon name="users" :size="18"/><span>Akun</span></button>
  </nav>

  <div v-if="pick&&sel.length" class="bulk">
    <span>{{sel.length}} dipilih</span>
    <button @click="bulkSave"><Icon name="bookmark" :size="14"/>Simpan</button>
    <button class="danger" @click="bulkRemove"><Icon name="trash" :size="14"/>Hapus</button>
    <button class="ghost" @click="sel=[];pick=false">Batal</button>
  </div>

  <transition name="fade"><div v-if="toast" class="toast"><span>{{toast.msg}}</span><button v-if="toast.undo" @click="undo">Urungkan</button></div></transition>

  <transition name="sheet">
    <div v-if="detail" class="ov" @click.self="closeDetail">
      <div class="sheet" :style="{transform:'translateY('+sheetY+'px)'}">
        <div class="grab" @pointerdown="sDown" @pointermove="sMove" @pointerup="sUp" @pointercancel="sUp"><i/></div>
        <button class="sx" @click="closeDetail" aria-label="Tutup"><Icon name="x" :size="17"/></button>
        <div class="simg"><img :src="detail.image_url" :alt="detail.title"/></div>
        <div class="sbody">
          <span class="scat">{{labelFor(detail.cat)}}<template v-if="detail.country"> · {{detail.country}}</template></span>
          <h2>{{detail.title}}</h2>
          <div v-if="detail.city||detail.country" class="sloc"><Icon name="pin" :size="13"/>{{detail.city||detail.country}}</div>
          <div v-if="detail.price" class="sprice">
            <div><span class="spl">Harga</span><b>{{rp(detail.price)}}</b><span v-if="detail.list" class="sstrike">{{rp(detail.list)}}</span></div>
            <span v-if="cb(detail)" class="scb"><Icon name="sparkle" :size="12"/>cashback s/d {{rp(cb(detail))}}</span>
          </div>
          <p class="sdesc">{{detail.brief||'Penawaran resmi mitra. Detail lengkap, jadwal, dan ketentuan tampil di halaman pemesanan.'}}</p>
          <div v-if="detail.dens.length" class="sdens">
            <span class="sdl">Pilihan nominal</span>
            <div class="sdrow"><span v-for="(d,i) in detail.dens.slice(0,10)" :key="i" class="sdchip">{{d.n}} · {{rp(d.p)}}</span></div>
          </div>
          <div v-if="detail.price" class="sqty"><span>Jumlah</span>
            <div class="stp"><button @click="qty=Math.max(1,qty-1)" aria-label="Kurangi"><Icon name="minus" :size="14"/></button><b>{{qty}}</b><button @click="qty=Math.min(10,qty+1)" aria-label="Tambah"><Icon name="plus" :size="14"/></button></div>
          </div>
          <div v-if="detail.price" class="stotal"><span>Perkiraan total</span><b>{{rp(detail.price*qty)}}</b></div>
          <div v-if="cb(detail)" class="stotal cb2"><span>Perkiraan cashback</span><b>+{{rp(cb(detail)*qty)}}</b></div>
          <ul class="slist">
            <li><Icon name="check" :size="13"/>Penawaran resmi mitra terverifikasi</li>
            <li><Icon name="check" :size="13"/>Konfirmasi & pembayaran di halaman mitra</li>
            <li><Icon name="check" :size="13"/>Cashback tercatat setelah transaksi tervalidasi</li>
          </ul>
        </div>
        <div class="sact">
          <button class="sico" :class="{on:isSaved(detail.id)}" @click="toggleSave(detail)" aria-label="Simpan"><Icon name="bookmark" :size="18"/></button>
          <button class="sico" @click="share(detail)" aria-label="Bagikan"><Icon name="share" :size="18"/></button>
          <button class="sbuy" @click="buy(detail)">{{detail.price?'Pesan Sekarang · '+rp(detail.price*qty):'Buka Penawaran Resmi'}}</button>
        </div>
      </div>
    </div>
  </transition>
</main>
</template>
<style scoped>
.sp{--bg:#FFF7EC;--surf:#fff;--ink:#1a1a1a;--mute:#7b7268;--line:#eadfd0;--a1:#FF7A45;--a2:#FF4D3D;--gold:#B34700;--ok:#00B8A9;--on:#fff;
 min-height:100vh;background:var(--bg);color:var(--ink);padding-bottom:132px;font-family:system-ui,-apple-system,sans-serif;overflow-x:hidden}
.sp.hue-ocean{--bg:#04222B;--surf:#0C333D;--ink:#EAF7F7;--mute:#8FC7C2;--line:rgba(255,255,255,.09);--a1:#00B8A9;--a2:#7CF5D8;--gold:#FFB300;--ok:#2F6BFF;--on:#04222B}
.sp.hue-sky{--bg:#041E3A;--surf:#0B2C50;--ink:#EAF2FF;--mute:#8FB4DE;--line:rgba(255,255,255,.09);--a1:#2563EB;--a2:#06B6D4;--gold:#FFB300;--ok:#22D3EE;--on:#fff}
.sp ::-webkit-scrollbar{width:6px;height:6px}
.sp ::-webkit-scrollbar-track{background:rgba(128,128,128,.10)}
.sp ::-webkit-scrollbar-thumb{background:linear-gradient(180deg,var(--a1),var(--a2));border-radius:99px}
.bar{position:sticky;top:0;z-index:40;display:flex;gap:9px;align-items:center;padding:calc(9px + env(safe-area-inset-top)) 12px 9px;background:color-mix(in srgb,var(--bg) 88%,transparent);backdrop-filter:blur(14px);border-bottom:1px solid var(--line)}
.ib{position:relative;flex:0 0 auto;width:38px;height:38px;display:grid;place-items:center;border:1px solid var(--line);border-radius:12px;background:var(--surf);color:var(--ink);cursor:pointer}
.ib:active{transform:scale(.93)}
.dot{position:absolute;top:-5px;right:-5px;min-width:17px;height:17px;padding:0 4px;border-radius:99px;background:var(--a2);color:var(--on);font-size:9px;font-weight:900;font-style:normal;display:grid;place-items:center;border:2px solid var(--bg)}
.sb{flex:1;display:flex;gap:8px;align-items:center;background:var(--surf);border:1px solid var(--line);border-radius:12px;padding:9px 11px;color:var(--mute);min-width:0}
.sb input{flex:1;min-width:0;background:none;border:0;outline:none;color:var(--ink);font-size:13px}
.clr{border:0;background:none;color:var(--mute);cursor:pointer;display:grid;place-items:center}
.hero{position:relative;padding:18px 16px 16px;overflow:hidden}
.hg{position:absolute;inset:0;background:radial-gradient(70% 90% at 10% 0%,color-mix(in srgb,var(--a1) 26%,transparent),transparent 62%),radial-gradient(60% 80% at 92% 10%,color-mix(in srgb,var(--a2) 22%,transparent),transparent 65%)}
.hi{position:relative;max-width:1280px;margin:0 auto}
.eyebrow{display:inline-flex;gap:6px;align-items:center;font-size:10px;font-weight:800;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));padding:4px 10px;border-radius:999px}
.hi h1{margin:10px 0 12px;font-size:25px;line-height:1.12;font-weight:900;letter-spacing:-.4px}
.hstats{display:flex;gap:8px;flex-wrap:wrap}
.hstats div{flex:1;min-width:72px;background:var(--surf);border:1px solid var(--line);border-radius:13px;padding:8px 10px}
.hstats b{display:block;font-size:15px;font-weight:900;color:var(--a1)}
.hstats span{font-size:9.5px;color:var(--mute);font-weight:700}
.rail{display:flex;gap:8px;overflow-x:auto;padding:12px 14px;scroll-snap-type:x proximity;max-width:1280px;margin:0 auto}
.rail button{flex:0 0 80px;scroll-snap-align:start;display:flex;flex-direction:column;align-items:center;gap:5px;border:0;background:none;color:var(--mute);cursor:pointer;padding:0}
.ri{width:50px;height:50px;display:grid;place-items:center;border-radius:17px;background:var(--surf);border:1px solid var(--line);color:var(--a1);transition:transform .16s,background .16s}
.rail button:active .ri{transform:scale(.92)}
.rail button.on .ri{background:linear-gradient(140deg,var(--a1),var(--a2));color:var(--on);border-color:transparent}
.rl{font-size:10.5px;font-weight:800;color:var(--ink);text-align:center;line-height:1.15}
.rn{font-style:normal;font-size:9px;font-weight:800;color:var(--on);background:var(--a1);border-radius:99px;padding:1px 6px}
.deal{margin:2px 0 6px;padding:12px 0 14px;background:color-mix(in srgb,var(--gold) 12%,transparent);border-top:1px solid var(--line);border-bottom:1px solid var(--line)}
.dh{display:flex;justify-content:space-between;align-items:center;padding:0 14px 10px;max-width:1280px;margin:0 auto}
.dh h2{display:flex;gap:7px;align-items:center;margin:0;font-size:15px;font-weight:900}
.timer{display:flex;gap:5px;align-items:center;font-size:12px;font-weight:900;font-variant-numeric:tabular-nums;color:#2b1600;background:linear-gradient(135deg,var(--gold),#FF8A3D);padding:4px 10px;border-radius:999px}
.dstrip{display:flex;gap:10px;overflow-x:auto;padding:0 14px 4px;scroll-snap-type:x mandatory;max-width:1280px;margin:0 auto}
.dc{flex:0 0 126px;scroll-snap-align:start;position:relative;border:1px solid var(--line);background:var(--surf);border-radius:14px;padding:7px;cursor:pointer;color:var(--ink);text-align:left}
.dc:active{transform:scale(.95)}
.dc img{width:100%;height:80px;object-fit:cover;border-radius:10px}
.dp{display:block;font-size:12.5px;font-weight:900;color:var(--gold);margin-top:6px}
.dn{display:block;font-size:9.5px;line-height:1.25;height:2.5em;overflow:hidden;color:var(--mute);margin-top:2px}
.dcb{position:absolute;top:11px;right:11px;font-style:normal;font-size:8px;font-weight:900;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));padding:2px 5px;border-radius:99px}
.tools{max-width:1280px;margin:0 auto;padding:12px 14px 0}
.chips{display:flex;gap:7px;overflow-x:auto;padding-bottom:9px}
.chips button{flex:0 0 auto;display:flex;gap:5px;align-items:center;border:1px solid var(--line);background:var(--surf);color:var(--ink);border-radius:999px;padding:7px 13px;font-size:11.5px;font-weight:800;cursor:pointer}
.chips button.on{background:linear-gradient(135deg,var(--a1),var(--a2));border-color:transparent;color:var(--on)}
.chips button i{font-style:normal;font-size:9.5px;opacity:.75}
.sorts{display:flex;gap:8px;align-items:center}
.sel{flex:1;display:flex;gap:7px;align-items:center;background:var(--surf);border:1px solid var(--line);border-radius:11px;padding:8px 11px;color:var(--mute)}
.sel select{flex:1;background:none;border:0;outline:none;color:var(--ink);font-size:12px;font-weight:800}
.sel select option{background:var(--surf);color:var(--ink)}
.pickb{display:flex;gap:6px;align-items:center;border:1px solid var(--line);background:var(--surf);color:var(--ink);border-radius:11px;padding:8px 13px;font-size:12px;font-weight:800;cursor:pointer}
.pickb.on{background:linear-gradient(135deg,var(--a1),var(--a2));color:var(--on);border-color:transparent}
.resline{display:flex;justify-content:space-between;align-items:center;max-width:1280px;margin:0 auto;padding:11px 14px 9px;font-size:11.5px;color:var(--mute)}
.resline b{color:var(--a1);font-size:13px}
.rst{border:0;background:none;color:var(--gold);font-size:11.5px;font-weight:800;cursor:pointer}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;max-width:1280px;margin:0 auto;padding:0 12px}
@media(min-width:640px){.grid{grid-template-columns:repeat(3,1fr)}}
@media(min-width:960px){.grid{grid-template-columns:repeat(4,1fr);gap:14px}}
@media(min-width:1240px){.grid{grid-template-columns:repeat(5,1fr)}}
.pc{background:var(--surf);border:1px solid var(--line);border-radius:16px;overflow:hidden;cursor:pointer;content-visibility:auto;contain-intrinsic-size:auto 260px;
 opacity:0;transform:translateY(12px);transition:opacity .38s ease,transform .38s cubic-bezier(.22,1,.36,1),border-color .16s}
.pc.in{opacity:1;transform:none}
.pc:active{border-color:var(--a1)}
.pc.sel{border-color:var(--a1);box-shadow:0 0 0 2px color-mix(in srgb,var(--a1) 40%,transparent)}
.pw{position:relative;aspect-ratio:1/1;background:color-mix(in srgb,var(--ink) 6%,var(--surf))}
.pw img{width:100%;height:100%;object-fit:cover;display:block}
.poff{position:absolute;left:7px;top:7px;font-size:9px;font-weight:900;color:#fff;background:linear-gradient(135deg,var(--a2),#FF8A3D);padding:2px 7px;border-radius:99px;max-width:78%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}
.poff.alt{background:linear-gradient(135deg,var(--a1),var(--a2));color:var(--on)}
.psave{position:absolute;top:7px;right:7px;width:28px;height:28px;display:grid;place-items:center;border:0;border-radius:10px;background:color-mix(in srgb,var(--bg) 70%,transparent);color:var(--ink);cursor:pointer;backdrop-filter:blur(4px)}
.psave.on{background:linear-gradient(135deg,var(--gold),var(--a2));color:#fff}
.pcheck{position:absolute;bottom:7px;left:7px;width:22px;height:22px;display:grid;place-items:center;border-radius:8px;border:2px solid var(--surf);background:color-mix(in srgb,var(--bg) 60%,transparent);color:var(--on)}
.pc.sel .pcheck{background:var(--a1);border-color:var(--a1)}
.pb{padding:9px 9px 11px}
.pb h3{margin:0;font-size:11.5px;font-weight:700;line-height:1.3;height:2.6em;overflow:hidden}
.ploc{display:flex;gap:4px;align-items:center;font-size:9.5px;color:var(--mute);margin-top:5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.prow{display:flex;justify-content:space-between;align-items:baseline;gap:6px;margin-top:6px}
.pprice{font-size:14px;font-weight:900;color:var(--gold)}
.pcb{font-size:8.5px;font-weight:900;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));padding:2px 6px;border-radius:99px;white-space:nowrap}
.pstrike{display:block;font-size:9.5px;color:var(--mute);text-decoration:line-through;margin-top:2px}
.pnote{display:block;font-size:8.5px;color:var(--mute);margin-top:5px}
.skel{opacity:1;transform:none;content-visibility:visible}
.si{aspect-ratio:1/1;background:linear-gradient(100deg,var(--surf) 30%,color-mix(in srgb,var(--ink) 8%,var(--surf)) 50%,var(--surf) 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
.sl{height:10px;margin:9px 9px 0;border-radius:6px;background:linear-gradient(100deg,var(--surf) 30%,color-mix(in srgb,var(--ink) 8%,var(--surf)) 50%,var(--surf) 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
.sl.short{width:55%}
@keyframes sh{from{background-position:120% 0}to{background-position:-20% 0}}
.state{display:flex;flex-direction:column;align-items:center;gap:9px;text-align:center;padding:46px 24px;color:var(--mute)}
.state b{font-size:15px;color:var(--ink)}
.state small{font-size:12px;max-width:300px;line-height:1.5}
.btn{margin-top:5px;border:0;border-radius:999px;padding:10px 20px;font-weight:900;font-size:12px;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));cursor:pointer}
.more{display:block;width:calc(100% - 24px);max-width:1256px;margin:14px auto 0;border:1px solid var(--line);background:var(--surf);color:var(--a1);border-radius:13px;padding:12px;font-size:12px;font-weight:800;cursor:pointer}
.tabs{position:fixed;left:0;right:0;bottom:0;z-index:45;display:flex;justify-content:space-around;background:color-mix(in srgb,var(--bg) 94%,transparent);backdrop-filter:blur(16px);border-top:1px solid var(--line);padding:7px 4px calc(7px + env(safe-area-inset-bottom))}
.tabs button{position:relative;flex:1;display:flex;flex-direction:column;align-items:center;gap:3px;border:0;background:none;color:var(--mute);font-size:9.5px;font-weight:800;cursor:pointer;padding:4px 0}
.tabs button.on{color:var(--a1)}
.tabs button i{position:absolute;top:0;right:22%;min-width:15px;height:15px;padding:0 4px;border-radius:99px;background:var(--a2);color:#fff;font-size:8px;font-style:normal;display:grid;place-items:center}
.bulk{position:fixed;left:12px;right:12px;bottom:calc(70px + env(safe-area-inset-bottom));z-index:46;display:flex;gap:7px;align-items:center;background:var(--surf);border:1px solid var(--a1);border-radius:15px;padding:9px 11px;box-shadow:0 12px 30px rgba(0,0,0,.28)}
.bulk span{flex:1;font-size:11.5px;font-weight:800;color:var(--a1)}
.bulk button{display:flex;gap:5px;align-items:center;border:0;border-radius:10px;padding:8px 11px;font-size:11px;font-weight:900;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));cursor:pointer}
.bulk button.danger{background:linear-gradient(135deg,var(--a2),#FF8A3D);color:#fff}
.bulk button.ghost{background:color-mix(in srgb,var(--ink) 8%,transparent);color:var(--ink)}
.toast{position:fixed;left:12px;right:12px;bottom:calc(70px + env(safe-area-inset-bottom));z-index:60;display:flex;gap:10px;align-items:center;justify-content:space-between;background:var(--surf);border:1px solid var(--a1);border-radius:13px;padding:11px 14px;font-size:12px;box-shadow:0 12px 30px rgba(0,0,0,.3)}
.toast button{border:0;background:none;color:var(--gold);font-weight:900;font-size:12px;cursor:pointer}
.fade-enter-active,.fade-leave-active{transition:opacity .22s,transform .22s}
.fade-enter-from,.fade-leave-to{opacity:0;transform:translateY(10px)}
.ov{position:fixed;inset:0;z-index:70;background:rgba(6,10,14,.66);backdrop-filter:blur(6px);display:flex;align-items:flex-end;justify-content:center}
.sheet{position:relative;width:100%;max-width:560px;max-height:92vh;display:flex;flex-direction:column;background:var(--bg);border:1px solid var(--line);border-radius:24px 24px 0 0;overflow:hidden;box-shadow:0 -18px 50px rgba(0,0,0,.5);transition:transform .18s}
.grab{padding:10px 0 4px;display:grid;place-items:center;cursor:grab;touch-action:none}
.grab i{width:44px;height:4px;border-radius:99px;background:var(--a1);opacity:.6}
.sx{position:absolute;top:12px;right:12px;z-index:3;width:32px;height:32px;display:grid;place-items:center;border:0;border-radius:11px;background:color-mix(in srgb,var(--bg) 72%,transparent);color:var(--ink);cursor:pointer}
.simg{height:190px;flex:0 0 auto;background:color-mix(in srgb,var(--ink) 6%,var(--surf))}
.simg img{width:100%;height:100%;object-fit:contain}
.sbody{flex:1;overflow-y:auto;padding:14px 16px 8px}
.scat{font-size:9.5px;font-weight:900;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));padding:3px 9px;border-radius:99px}
.sbody h2{margin:10px 0 6px;font-size:19px;line-height:1.2;font-weight:900}
.sloc{display:flex;gap:5px;align-items:center;font-size:11.5px;color:var(--mute)}
.sprice{display:flex;justify-content:space-between;align-items:center;gap:10px;margin:13px 0;padding:11px 13px;border-radius:14px;background:color-mix(in srgb,var(--gold) 12%,transparent);border:1px solid var(--line)}
.spl{display:block;font-size:9.5px;color:var(--mute);font-weight:700}
.sprice b{font-size:21px;font-weight:900;color:var(--gold)}
.sstrike{display:block;font-size:10.5px;color:var(--mute);text-decoration:line-through}
.scb{display:flex;gap:5px;align-items:center;font-size:10px;font-weight:900;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));padding:5px 9px;border-radius:99px}
.sdesc{margin:0 0 13px;font-size:12.5px;line-height:1.6;color:var(--mute)}
.sdens{margin-bottom:12px}
.sdl{display:block;font-size:10px;font-weight:800;color:var(--mute);margin-bottom:6px}
.sdrow{display:flex;gap:6px;overflow-x:auto;padding-bottom:4px}
.sdchip{flex:0 0 auto;font-size:10px;font-weight:700;border:1px solid var(--line);background:var(--surf);border-radius:99px;padding:5px 10px;white-space:nowrap}
.sqty{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-top:1px solid var(--line);font-size:12.5px;font-weight:800}
.stp{display:flex;gap:12px;align-items:center}
.stp button{width:30px;height:30px;display:grid;place-items:center;border:1px solid var(--line);border-radius:10px;background:var(--surf);color:var(--a1);cursor:pointer}
.stp b{min-width:20px;text-align:center;font-size:15px}
.stotal{display:flex;justify-content:space-between;align-items:center;padding:8px 0;font-size:12.5px;color:var(--mute);border-top:1px solid var(--line)}
.stotal b{font-size:16px;color:var(--ink)}
.stotal.cb2 b{color:var(--a1)}
.slist{list-style:none;margin:12px 0 4px;padding:0;display:flex;flex-direction:column;gap:7px}
.slist li{display:flex;gap:8px;align-items:flex-start;font-size:11.5px;color:var(--mute);line-height:1.4}
.slist li :deep(svg){flex:0 0 auto;margin-top:1px;color:var(--a1)}
.sact{flex:0 0 auto;display:flex;gap:8px;align-items:center;padding:11px 14px calc(12px + env(safe-area-inset-bottom));border-top:1px solid var(--line);background:var(--bg)}
.sico{width:44px;height:44px;flex:0 0 auto;display:grid;place-items:center;border:1px solid var(--line);border-radius:13px;background:var(--surf);color:var(--ink);cursor:pointer}
.sico.on{background:linear-gradient(135deg,var(--gold),var(--a2));color:#fff;border-color:transparent}
.sbuy{flex:1;border:0;border-radius:13px;padding:14px;font-size:13.5px;font-weight:900;color:var(--on);background:linear-gradient(135deg,var(--a1),var(--a2));cursor:pointer}
.sbuy:active{transform:scale(.98)}
.sheet-enter-active,.sheet-leave-active{transition:opacity .24s}
.sheet-enter-active .sheet,.sheet-leave-active .sheet{transition:transform .28s cubic-bezier(.22,1,.36,1)}
.sheet-enter-from,.sheet-leave-to{opacity:0}
.sheet-enter-from .sheet,.sheet-leave-to .sheet{transform:translateY(100%)}
@media(min-width:960px){.hi h1{font-size:34px}.simg{height:240px}}
</style>
