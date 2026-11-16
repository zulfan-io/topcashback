<script setup>
import { ref, onMounted, computed } from 'vue'
import { supabase } from '~/utils/supabase'
const props = defineProps({ compact:{type:Boolean,default:false} })
const rows=ref([]); const bucket=ref(0)
onMounted(async()=>{ bucket.value=Math.floor(Date.now()/21600000)
  const {data}=await supabase.from('shoper_offers').select('*').eq('network','game').eq('active',true)
  rows.value=(data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{});return {...r,cat:m.cat||'cowok'}}) })
function rng(s){let t=s>>>0;return()=>{t+=0x6D2B79F5;let r=Math.imul(t^t>>>15,1|t);r^=r+Math.imul(r^r>>>7,61|r);return((r^r>>>14)>>>0)/4294967296}}
const FOLDS=[['cowok','🎮','Game Cowok · Hot'],['cewek','💖','Game Cewek · Gen Z'],['voucher','🎁','Voucher Game'],['genz','📺','Streaming Gen Z'],['stream','🎬','Drama & Olahraga'],['pc','💻','Game PC'],['partner','🤝','Partner Resmi']]
const byCat=computed(()=>{const m={};for(const r of rows.value)(m[r.cat]=m[r.cat]||[]).push(r);return m})
const hot=computed(()=>[...(byCat.value.cowok||[]),...(byCat.value.cewek||[])])
function feat(list){if(!list||!list.length)return null;const r=rng(bucket.value+list.length*7);return list[Math.floor(r()*list.length)]}
function open(o){window.open(o.url,'_blank','noopener')}
</script>
<template>
<section class="gh" :class="{compact}">
  <template v-if="compact">
    <div v-if="feat(hot)" class="hero" :key="feat(hot).id" @click="open(feat(hot))">
      <img :src="feat(hot).image_url" :alt="feat(hot).title" loading="lazy"/>
      <div class="scrim"/><span class="chip">🔥 HOT · CASHBACK 0.6%</span>
      <div class="ht"><b>{{feat(hot).title}}</b><small>Top-up instant · rotasi 6 jam</small></div>
    </div>
    <div class="strip"><button v-for="o in hot.slice(0,10)" :key="o.id" class="card" @click="open(o)"><img :src="o.image_url" :alt="o.title" loading="lazy"/><span>{{o.title}}</span></button></div>
  </template>
  <template v-else>
    <div v-for="[cat,ic,title] in FOLDS" :key="cat">
      <div v-if="(byCat[cat]||[]).length" class="fold">
        <header><h3><i>{{ic}}</i>{{title}}</h3><span class="live">● LIVE</span></header>
        <div v-if="feat(byCat[cat])" class="hero" :key="feat(byCat[cat]).id" @click="open(feat(byCat[cat]))">
          <img :src="feat(byCat[cat]).image_url" :alt="feat(byCat[cat]).title" loading="lazy"/>
          <div class="scrim"/><span class="chip">CASHBACK 0.6%</span>
          <div class="ht"><b>{{feat(byCat[cat]).title}}</b><small>Deep-link · tracked</small></div>
        </div>
        <div class="strip"><button v-for="o in byCat[cat]" :key="o.id" class="card" @click="open(o)"><img :src="o.image_url" :alt="o.title" loading="lazy"/><span>{{o.title}}</span><em>0.6%</em></button></div>
      </div>
    </div>
  </template>
</section>
</template>
<style scoped>
.gh{--surf:#0d1526;--card:#16233c;--acc:#FF7A45;--acc2:#FF4D3D;--grn:#7CFC9A;display:flex;flex-direction:column;gap:20px;padding:14px}
.fold header{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px}
.fold h3{font-size:15px;font-weight:800;color:#fff;display:flex;gap:8px;align-items:center}
.fold h3 i{font-style:normal}
.live{font-size:10px;color:var(--grn);font-weight:700}
.hero{position:relative;height:170px;border-radius:24px;overflow:hidden;cursor:pointer;box-shadow:0 10px 30px rgba(0,0,0,.45);animation:fade .5s ease}
.hero img{width:100%;height:100%;object-fit:cover}
.scrim{position:absolute;inset:0;background:linear-gradient(180deg,transparent 30%,rgba(13,21,38,.9))}
.chip{position:absolute;top:10px;left:10px;background:linear-gradient(135deg,var(--acc),var(--acc2));color:#fff;font-size:10px;font-weight:800;padding:4px 10px;border-radius:999px;box-shadow:0 4px 12px rgba(255,77,61,.4)}
.ht{position:absolute;left:12px;bottom:10px;color:#fff}
.ht b{display:block;font-size:16px}
.ht small{font-size:10px;opacity:.8}
.strip{display:flex;gap:12px;overflow-x:auto;scroll-snap-type:x mandatory;padding:12px 2px;-webkit-overflow-scrolling:touch}
.card{scroll-snap-align:start;flex:0 0 108px;position:relative;background:var(--card);border:0;border-radius:20px;padding:8px;cursor:pointer;color:#dfe8ff;box-shadow:0 6px 18px rgba(0,0,0,.35);transition:transform .15s ease}
.card:active{transform:scale(.96)}
.card img{width:92px;height:92px;object-fit:cover;border-radius:14px}
.card span{display:block;font-size:10px;margin-top:6px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.card em{position:absolute;top:6px;right:6px;font-style:normal;font-size:9px;font-weight:800;color:var(--grn);background:rgba(124,252,154,.12);padding:2px 6px;border-radius:999px}
@keyframes fade{from{opacity:0;transform:scale(1.02)}to{opacity:1;transform:scale(1)}}
</style>
