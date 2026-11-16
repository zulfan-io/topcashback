<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { supabase } from '~/utils/supabase'
const props=defineProps({compact:{type:Boolean,default:false}})
const rows=ref([]); const tick=ref(0); let iv=null
onMounted(async()=>{ const {data}=await supabase.from('shoper_offers').select('*').eq('network','game').eq('active',true)
  rows.value=(data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{});return {...r,cat:m.cat||'cowok'}})
  iv=setInterval(()=>tick.value++,4000) })
onUnmounted(()=>clearInterval(iv))
const FOLDS=[['cowok','🎮','Game Cowok · Hot'],['cewek','💖','Game Cewek · Gen Z'],['voucher','🎁','Voucher Game'],['genz','📺','Streaming Gen Z'],['stream','🎬','Drama & Olahraga'],['pc','💻','Game PC'],['partner','🤝','Partner Resmi']]
const byCat=computed(()=>{const m={};for(const r of rows.value)(m[r.cat]=m[r.cat]||[]).push(r);return m})
const hot=computed(()=>[...(byCat.value.cowok||[]),...(byCat.value.cewek||[])])
function cur(l){return (l&&l.length)?l[tick.value%l.length]:null}
function dbl(l){return (l||[]).concat(l||[])}
function open(o){window.open(o.url,'_blank','noopener')}
</script>
<template>
<section class="gh" :class="{compact}">
  <template v-if="compact">
    <div v-if="cur(hot)" class="hero" :key="cur(hot).id" @click="open(cur(hot))">
      <img class="hbg" :src="cur(hot).image_url" alt=""/><img class="hfg" :src="cur(hot).image_url" :alt="cur(hot).title"/>
      <div class="scrim"/><span class="chip">🔥 HOT · CASHBACK 0.6%</span>
      <div class="ht"><b>{{cur(hot).title}}</b><small>Top-up instant · carousel live</small></div>
    </div>
    <div class="mq left"><div class="mq-track"><button v-for="(o,i) in dbl(hot)" :key="o.id+'-'+i" class="card" @click="open(o)"><img :src="o.image_url" :alt="o.title"/><span>{{o.title}}</span></button></div></div>
  </template>
  <template v-else>
    <div v-for="([cat,ic,title],fi) in FOLDS" :key="cat">
      <div v-if="(byCat[cat]||[]).length" class="fold">
        <header><h3><i>{{ic}}</i>{{title}}</h3><span class="live">● LIVE</span></header>
        <div v-if="cur(byCat[cat])" class="hero" :key="cur(byCat[cat]).id" @click="open(cur(byCat[cat]))">
          <img class="hbg" :src="cur(byCat[cat]).image_url" alt=""/><img class="hfg" :src="cur(byCat[cat]).image_url" :alt="cur(byCat[cat]).title"/>
          <div class="scrim"/><span class="chip">⚡ CASHBACK 0.6%</span>
          <div class="ht"><b>{{cur(byCat[cat]).title}}</b><small>Deep-link · tracked</small></div>
        </div>
        <div class="mq" :class="fi%2? 'right':'left'"><div class="mq-track"><button v-for="(o,i) in dbl(byCat[cat])" :key="o.id+'-'+i" class="card" @click="open(o)"><img :src="o.image_url" :alt="o.title"/><span>{{o.title}}</span><em>0.6%</em></button></div></div>
      </div>
    </div>
  </template>
</section>
</template>
<style scoped>
.gh{--card:#16233c;--acc:#FF7A45;--acc2:#FF4D3D;--grn:#7CFC9A;display:flex;flex-direction:column;gap:0;padding:0;width:100%;}
@media(min-width:1024px){.gh{max-width:1280px;margin:0 auto;}}
.fold{padding:14px 0;}
.fold header{display:flex;justify-content:space-between;align-items:center;margin:0 14px 10px;}
.fold h3{font-size:15px;font-weight:800;color:#fff;display:flex;gap:8px;align-items:center;}
.fold h3 i{font-style:normal;}
.live{font-size:10px;color:var(--grn);font-weight:700;}
.hero{position:relative;height:200px;width:100%;border-radius:0;overflow:hidden;cursor:pointer;animation:fade .5s ease;}
.hero .hbg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;filter:blur(18px) brightness(.55);transform:scale(1.15);}
.hero .hfg{position:relative;width:100%;height:100%;object-fit:contain;object-position:center;}
.scrim{position:absolute;inset:0;background:linear-gradient(180deg,transparent 30%,rgba(13,21,38,.9));}
.chip{position:absolute;top:10px;left:10px;background:linear-gradient(135deg,var(--acc),var(--acc2));color:#fff;font-size:10px;font-weight:800;padding:4px 10px;border-radius:999px;}
.ht{position:absolute;left:14px;bottom:10px;color:#fff;}
.ht b{display:block;font-size:16px;}
.ht small{font-size:10px;opacity:.8;}
.mq{overflow:hidden;width:100%;padding:12px 0;}
.mq-track{display:flex;gap:12px;width:max-content;}
.mq.left .mq-track{animation:mqL 30s linear infinite;}
.mq.right .mq-track{animation:mqR 30s linear infinite;}
.mq:active .mq-track{animation-play-state:paused;}
.card{flex:0 0 108px;position:relative;background:var(--card);border:0;border-radius:16px;padding:8px;cursor:pointer;color:#dfe8ff;}
.card img{width:92px;height:92px;object-fit:cover;object-position:center top;border-radius:12px;}
.card span{display:block;font-size:10px;margin-top:6px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.card em{position:absolute;top:6px;right:6px;font-style:normal;font-size:9px;font-weight:800;color:var(--grn);background:rgba(124,252,154,.12);padding:2px 6px;border-radius:999px;}
@keyframes mqL{from{transform:translateX(0)}to{transform:translateX(-50%)}}
@keyframes mqR{from{transform:translateX(-50%)}to{transform:translateX(0)}}
@keyframes fade{from{opacity:0}to{opacity:1}}
</style>
