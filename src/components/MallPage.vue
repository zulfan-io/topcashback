<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
import AppNav from '~/components/AppNav.vue'
import { byKey } from '~/config/brands'
function NETOF(k){return k==='tiktokshop'?'tiktok':k==='tokopedia'?'tokopedia':k}
const P=defineProps({network:{type:String,required:true}})
const router=useRouter()

function fmtPrice(n) {
  if (!n) return ''
  return 'Rp' + Number(n).toLocaleString('id-ID')
}
function calcDiscount(price, original) {
  if (!price || !original || original <= price) return 0
  return Math.round((1 - price / original) * 100)
}

const meta=computed(()=>byKey(P.network)||{name:P.network,logo:'',sub:'Katalog resmi',hue:'fusion'})
const items=ref([]); const brands=ref([]); const promos=ref([])
const state=ref('load'); const seg=ref('produk'); const q=ref(''); const sort=ref('pop')
async function load(){
  state.value='load'
  const [a,b,c]=await Promise.all([
    supabase.from('shoper_offers').select('*').eq('network',NETOF(P.network)).eq('active',true).limit(400),
    supabase.from('merchant_brands').select('*').eq('network',NETOF(P.network)).eq('active',true).limit(600),
    supabase.from('merchant_promos').select('*').eq('network',NETOF(P.network)).eq('active',true).limit(200)])
  items.value=(a.data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{})
    return {...r,title:r.name||r.title,price:r.price||r.original_price,original_price:r.original_price,list:+(m.price_list||r.original_price||0),city:m.city||'',sold:+(m.sold||0)}})
  brands.value=b.data||[]; promos.value=c.data||[]
  seg.value = items.value.length?'produk':(brands.value.length?'brand':(promos.value.length?'promo':'produk'))
  state.value=(items.value.length||brands.value.length||promos.value.length)?'ok':'empty'
}
onMounted(load)
function rp(n){return 'Rp'+Number(n||0).toLocaleString('id-ID')}
function out(u){window.open(u,'_blank','noopener')}
const SEGS=computed(()=>[['produk','store','Etalase Produk',items.value.length],['brand','grid','Etalase Brand',brands.value.length],['promo','ticket','Diskon & Kupon',promos.value.length]])
const shownItem=computed(()=>{const t=q.value.trim().toLowerCase()
  let a=items.value.filter(r=>!t||String(r.title).toLowerCase().includes(t))
  if(sort.value==='cheap')a=[...a].sort((x,y)=>(x.price||0)-(y.price||0))
  else if(sort.value==='disc')a=[...a].sort((x,y)=>(y.list?1-y.price/y.list:0)-(x.list?1-x.price/x.list:0))
  return a})
const shownBrand=computed(()=>{const t=q.value.trim().toLowerCase()
  let a=brands.value.filter(r=>!t||String(r.brand).toLowerCase().includes(t))
  if(sort.value==='az')a=[...a].sort((x,y)=>String(x.brand).localeCompare(String(y.brand)))
  return a})
const shownPromo=computed(()=>{const t=q.value.trim().toLowerCase();return promos.value.filter(r=>!t||String(r.title).toLowerCase().includes(t))})
</script>
<template>
<main class="mp">
  <header class="bar">
    <button class="ib" @click="router.push('/')" aria-label="Kembali"><Icon name="back" :size="18"/></button>
    <label class="sb"><Icon name="search" :size="15"/><input v-model="q" type="search" :placeholder="'Cari di '+meta.name+'…'" aria-label="Cari"/></label>
    <button class="ib" @click="router.push('/akun')" aria-label="Akun"><Icon name="users" :size="18"/></button>
  </header>
  <section class="hero">
    <span class="eyebrow"><img v-if="meta.logo" :src="meta.logo" :alt="meta.name"/>{{meta.name}}</span>
    <h1>{{meta.sub||'Katalog resmi'}},<br/><em>harga jujur.</em></h1>
    <div class="stats">
      <div><b>{{items.length}}</b><span>Produk</span></div>
      <div><b>{{brands.length}}</b><span>Brand resmi</span></div>
      <div><b>{{promos.length}}</b><span>Promo aktif</span></div>
    </div>
  </section>
  <nav class="rail">
    <button v-for="[k,ic,lb,n] in SEGS" :key="k" :class="{on:seg===k}" @click="seg=k">
      <span class="ri"><Icon :name="ic" :size="18"/></span><span class="rl">{{lb}}</span><i class="rn">{{n}}</i>
    </button>
  </nav>
  <div class="tools">
    <label class="sel"><Icon name="sliders" :size="14"/>
      <select v-model="sort" aria-label="Urutkan">
        <option value="pop">Populer</option><option value="cheap">Termurah</option>
        <option value="disc">Diskon terbesar</option><option value="az">A–Z</option>
      </select>
    </label>
  </div>
  <div v-if="state==='load'" class="grid"><div v-for="n in 8" :key="'s'+n" class="card sk"><div class="si"/><div class="sl"/><div class="sl short"/></div></div>
  <div v-else-if="state==='empty'" class="msg"><Icon name="store" :size="22"/><b>Katalog {{meta.name}} sedang disiapkan</b><small>Belum ada etalase yang bisa dipesan di sini. Jelajah yang sudah hidup dulu.</small><button class="btn" @click="router.push('/mall')">Ke Mall</button></div>
  <template v-else>
    <div v-if="seg==='produk'" class="grid">
      <button v-for="r in shownItem" :key="r.id" class="card" @click="out(r.url)">
        <span class="pw"><img :src="r.image_url" :alt="r.title" loading="lazy" decoding="async"/>
          <i v-if="r.discount_pct" class="off">-{{r.discount_pct}}%</i></span>
        <span class="nm">{{r.title}}</span>
        <span class="pr" v-if="r.price">{{fmtPrice(r.price)}}</span>
        <span class="st" v-if="r.original_price>r.price">{{fmtPrice(r.original_price)}}</span>
                <small v-if="r.store_name" style="display:block;margin:4px 10px 0;font-size:11px;color:#9a7b60;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{r.store_name}}</small>
        <span class="go">Lihat di {{meta.name}}<Icon name="chevron" :size="12"/></span>
      </button>
    </div>
    <div v-else-if="seg==='brand'" class="grid">
      <button v-for="r in shownBrand" :key="r.id" class="card" @click="out(r.affiliate)">
        <span class="pw logo"><img :src="r.logo" :alt="r.brand" loading="lazy" decoding="async"/></span>
        <span class="nm">{{r.brand}}</span>
        <span class="ex" v-if="r.expires">{{r.expires}}</span>
        <span class="go">Kunjungi toko<Icon name="chevron" :size="12"/></span>
      </button>
    </div>
    <div v-else class="grid">
      <button v-for="r in shownPromo" :key="r.id" class="card" @click="out(r.url)">
        <span class="pw" v-if="r.image_url"><img :src="r.image_url" :alt="r.title" loading="lazy" decoding="async"/></span>
        <span class="nm">{{r.title}}</span>
        <span class="pr" v-if="r.price">{{fmtPrice(r.price)}}</span>
        <span class="ex" v-if="r.ends">s/d {{r.ends}}</span>
        <span class="go">Pakai promo<Icon name="chevron" :size="12"/></span>
      </button>
    </div>
  </template>
  <p class="note">Harga & diskon mengikuti halaman resmi {{meta.name}}. Kami menampilkan penawaran mitra, bukan menjanjikan potongan tambahan.</p>
  <AppNav/>
</main>
</template>
<style scoped>
.mp{--a:#FF7A45;--a2:#FF4D3D;min-height:100vh;background:#FFF7EC;color:#1a1a1a;font-family:system-ui,sans-serif;padding-bottom:110px}
.bar{position:sticky;top:0;z-index:30;display:flex;gap:9px;align-items:center;padding:calc(9px + env(safe-area-inset-top)) 12px 9px;background:rgba(255,247,236,.94);backdrop-filter:blur(14px);border-bottom:1px solid #eadfd0}
.ib{width:36px;height:36px;flex:0 0 auto;display:grid;place-items:center;border:1px solid #eadfd0;border-radius:11px;background:#fff;cursor:pointer}
.sb{flex:1;display:flex;gap:8px;align-items:center;background:#fff;border:1px solid var(--a);border-radius:12px;padding:9px 12px;color:#9a8f82;min-width:0}
.sb input{flex:1;min-width:0;border:0;outline:none;background:none;font-size:13px;color:#1a1a1a}
.hero{position:relative;padding:18px 16px 14px;overflow:hidden}
.hero::before{content:'';position:absolute;inset:0;background:radial-gradient(70% 90% at 12% 0%,rgba(255,122,69,.20),transparent 62%),radial-gradient(60% 80% at 92% 10%,rgba(0,184,169,.14),transparent 65%)}
.eyebrow{position:relative;display:inline-flex;gap:6px;align-items:center;font-size:11px;font-weight:900;color:#fff;background:linear-gradient(135deg,var(--a),var(--a2));padding:4px 11px;border-radius:999px}
.eyebrow img{width:16px;height:16px;object-fit:contain;background:#fff;border-radius:4px}
.hero h1{position:relative;margin:10px 0 12px;font-size:26px;line-height:1.1;font-weight:900;letter-spacing:-.5px}
.hero h1 em{font-style:normal;background:linear-gradient(100deg,var(--a),var(--a2));-webkit-background-clip:text;background-clip:text;color:transparent}
.stats{position:relative;display:flex;gap:9px}
.stats div{flex:1;background:#fff;border:1px solid #eadfd0;border-radius:13px;padding:9px 11px}
.stats b{display:block;font-size:17px;font-weight:900;color:var(--a2)}
.stats span{font-size:9.5px;color:#7b7268;font-weight:700}
.rail{display:flex;gap:8px;overflow-x:auto;padding:12px 14px;max-width:1280px;margin:0 auto}
.rail button{flex:0 0 92px;display:flex;flex-direction:column;align-items:center;gap:5px;border:0;background:none;cursor:pointer;padding:0}
.ri{width:50px;height:50px;display:grid;place-items:center;border-radius:17px;background:#fff;border:1px solid #eadfd0;color:var(--a)}
.rail button.on .ri{background:linear-gradient(140deg,var(--a),var(--a2));color:#fff;border-color:transparent}
.rl{font-size:9.5px;font-weight:800;color:#1a1a1a;text-align:center;line-height:1.15}
.rn{font-style:normal;font-size:9px;font-weight:800;color:#fff;background:var(--a);border-radius:99px;padding:1px 6px}
.tools{padding:0 14px 10px;max-width:1280px;margin:0 auto}
.sel{display:flex;gap:7px;align-items:center;background:#fff;border:1px solid #eadfd0;border-radius:11px;padding:8px 11px;color:#9a8f82}
.sel select{flex:1;background:none;border:0;outline:none;color:#1a1a1a;font-size:12px;font-weight:800}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;padding:0 12px;max-width:1280px;margin:0 auto}
@media(min-width:640px){.grid{grid-template-columns:repeat(3,1fr)}}
@media(min-width:960px){.grid{grid-template-columns:repeat(5,1fr)}}
.card{display:flex;flex-direction:column;align-items:flex-start;gap:4px;border:1px solid #eadfd0;background:#fff;border-radius:15px;padding:9px;cursor:pointer;text-align:left;content-visibility:auto;contain-intrinsic-size:auto 220px;transition:transform .14s,border-color .14s}
.card:active{transform:scale(.96);border-color:var(--a)}
.pw{position:relative;width:100%;height:104px;border-radius:11px;overflow:hidden;background:#FFFBF6;display:grid;place-items:center}
.pw img{width:100%;height:100%;object-fit:cover}
.pw.logo img{object-fit:contain;max-width:80%;max-height:70px}
.off{position:absolute;top:6px;left:6px;font-style:normal;font-size:9px;font-weight:900;color:#fff;background:linear-gradient(135deg,var(--a2),#FF8A3D);padding:2px 7px;border-radius:99px}
.nm{font-size:11px;font-weight:700;line-height:1.3;height:2.6em;overflow:hidden;color:#1a1a1a;margin-top:5px}
.pr{font-size:13px;font-weight:900;color:#B34700}
.st{font-size:9.5px;color:#9a8f82;text-decoration:line-through}
.ex{font-size:8.5px;color:#9a8f82}
.go{display:flex;gap:3px;align-items:center;margin-top:3px;font-size:9.5px;font-weight:800;color:var(--a)}
.sk{content-visibility:visible}
.si{width:100%;height:104px;border-radius:11px;background:linear-gradient(100deg,#f3e9dc 30%,#fff 50%,#f3e9dc 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
.sl{width:80%;height:9px;margin-top:7px;border-radius:6px;background:linear-gradient(100deg,#f3e9dc 30%,#fff 50%,#f3e9dc 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
.sl.short{width:50%}
@keyframes sh{from{background-position:120% 0}to{background-position:-20% 0}}
.msg{display:flex;flex-direction:column;align-items:center;gap:9px;text-align:center;padding:44px 24px;color:#7b7268}
.msg b{font-size:15px;color:#1a1a1a}.msg small{font-size:12px;max-width:300px;line-height:1.5}
.btn{margin-top:4px;border:0;border-radius:999px;padding:10px 20px;font-weight:900;font-size:12px;color:#fff;background:linear-gradient(135deg,var(--a),var(--a2));cursor:pointer}
.note{max-width:1280px;margin:14px auto 0;padding:0 16px;font-size:9.5px;color:#9a8f82;line-height:1.5}

.price-block { display: flex; align-items: baseline; gap: 6px; margin: 4px 0; }
.price-block .pr { font-size: 14px; font-weight: 700; color: #ff5722; }
.price-block .st { font-size: 11px; color: #999; text-decoration: line-through; }
</style>
