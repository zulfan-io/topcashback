<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const router=useRouter(); const rows=ref([]); const seed=ref(0)
function rp(n){return 'Rp'+Number(n||0).toLocaleString('id-ID')}
onMounted(async()=>{
  const {data}=await supabase.from('shoper_offers').select('*').eq('active',true).in('network',['shopee','traveloka','trip']).limit(400)
  rows.value=(data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{});return {...r,net:r.network,sold:+(m.sold||0),rate:+(m.rate_max||r.commission||0),list:+(m.price_list||0)}})
  try{const {data:s}=await supabase.from('rotation_seed').select('v').limit(1).maybeSingle(); seed.value=s?.v??Math.floor(Date.now()/3600000)}catch(_){seed.value=Math.floor(Date.now()/3600000)}
})
function rng(s){let t=s>>>0;return()=>{t+=0x6D2B79F5;let r=Math.imul(t^t>>>15,1|t);r^=r+Math.imul(r^r>>>7,61|r);return((r^r>>>14)>>>0)/4294967296}}
function rot(list,s,n){const r=rng(s);return [...list].map(x=>({x,k:r()})).sort((a,b)=>a.k-b.k).slice(0,n).map(o=>o.x)}
const shop=computed(()=>rows.value.filter(r=>r.net==='shopee'))
const trav=computed(()=>rows.value.filter(r=>r.net==='traveloka'))
const trip=computed(()=>rows.value.filter(r=>r.net==='trip'))
const SEG=computed(()=>[
 ['Rekomendasi Untukmu', rot(shop.value,seed.value+1,10), '/mall'],
 ['Produk Terlaris', [...shop.value].sort((a,b)=>b.sold-a.sold).slice(0,10).length? [...shop.value].sort((a,b)=>b.sold-a.sold).slice(0,10):rot(shop.value,seed.value+2,10), '/mall?seg=terlaris'],
 ['Flash Sale', rot(shop.value.filter(r=>r.list>r.price),seed.value+3,10).length?rot(shop.value.filter(r=>r.list>r.price),seed.value+3,10):rot(shop.value,seed.value+3,10), '/mall?seg=flash'],
 ['Destinasi Promo', rot(trav.value,seed.value+4,10), '/travel'],
 ['Tiket Liburan Miring', [...trav.value].sort((a,b)=>(a.price||1e12)-(b.price||1e12)).slice(0,10), '/travel?seg=miring'],
 ['Trip Cerdas', rot(trip.value,seed.value+5,10), '/trip'],
])
function open(r){window.open(r.url,'_blank','noopener')}
</script>
<template>
<section class="rf">
  <div v-for="[title,list,href] in SEG" :key="title" class="rf-s">
    <header><h3>{{title}}</h3><button class="rf-more" @click="router.push(href)">Lihat selengkapnya<Icon name="chevron" :size="13"/></button></header>
    <div class="rf-row">
      <button v-for="r in list" :key="r.id" class="rf-c" @click="open(r)">
        <img :src="r.image_url" :alt="r.title" loading="lazy" decoding="async"/>
        <span class="rf-t">{{r.title}}</span>
        <span class="rf-p" v-if="r.price">{{rp(r.price)}}</span>
        <span class="rf-cb" v-if="r.price&&r.rate">+{{rp(Math.round(r.price*r.rate/100))}}</span>
      </button>
    </div>
  </div>
</section>
</template>
<style scoped>
.rf{max-width:1280px;margin:0 auto;padding:6px 0 20px}
.rf-s{margin:0 0 16px}
.rf-s header{display:flex;justify-content:space-between;align-items:center;padding:0 14px 8px}
.rf-s h3{margin:0;font-size:15px;font-weight:900;color:#1a1a1a}
.rf-more{display:flex;gap:3px;align-items:center;border:0;background:none;color:#FF4D3D;font-size:11px;font-weight:800;cursor:pointer}
.rf-row{display:flex;gap:10px;overflow-x:auto;padding:0 14px 6px;scroll-snap-type:x proximity;scrollbar-width:thin;scrollbar-color:#FF7A45 #f3e9dc}
.rf-row::-webkit-scrollbar{height:5px}
.rf-row::-webkit-scrollbar-thumb{background:linear-gradient(90deg,#FF7A45,#FF4D3D);border-radius:99px}
.rf-c{flex:0 0 132px;scroll-snap-align:start;position:relative;border:1px solid #eadfd0;background:#fff;border-radius:14px;padding:7px;cursor:pointer;text-align:left}
.rf-c:active{transform:scale(.96)}
.rf-c img{width:100%;height:96px;object-fit:cover;border-radius:10px;background:#f3e9dc}
.rf-t{display:block;font-size:10px;font-weight:700;color:#1a1a1a;margin-top:6px;line-height:1.25;height:2.5em;overflow:hidden}
.rf-p{display:block;font-size:12px;font-weight:900;color:#B34700;margin-top:3px}
.rf-cb{position:absolute;top:11px;right:11px;font-size:8px;font-weight:900;color:#fff;background:linear-gradient(135deg,#00B8A9,#2F6BFF);padding:2px 5px;border-radius:99px}
</style>
