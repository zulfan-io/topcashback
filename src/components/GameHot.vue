<script setup>
import { ref, onMounted, onUnmounted, computed, nextTick } from 'vue'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const props=defineProps({compact:{type:Boolean,default:false}})
const rows=ref([]); const tick=ref(0); const hs=ref(0); let iv=null; const cleanups=[]
const BONUS={'mobile-legends':'50+50 Diamond','efootball':'-13% · 134.415','top-eleven':'-11% · 89.000','free-fire':'Bonus diamond','genshin-impact':'Bonus top-up pertama'}
const PROMO={'mobile-legends':'Diamond Ganda top-up pertama','efootball':'Hemat 13%','top-eleven':'Hemat 11%'}
onMounted(async()=>{ const {data}=await supabase.from('shoper_offers').select('*').eq('network','game').eq('active',true)
  rows.value=(data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{});return {...r,cat:m.cat||'cowok',bonus:m.bonus||BONUS[r.external_id]||'',brief:m.brief||'',dens:m.dens||[]}})
  iv=setInterval(()=>tick.value++,6000)
  await nextTick()
  document.querySelectorAll('.gh .mq').forEach((el,i)=>cleanups.push(initMarquee(el, i%2?1:-1))) })
onUnmounted(()=>{clearInterval(iv);cleanups.forEach(f=>f())})
function initMarquee(el,dir){
  const track=el.querySelector('.mq-track'); let half=0,x=0,raf=0,drag=false,hover=false,inview=true,mom=0,lastX=0,moved=0
  const measure=()=>{half=track.scrollWidth/2; if(dir>0&&x===0)x=-half}
  measure()
  const step=()=>{ if(inview){ if(!drag){mom*=0.94; x+=(hover?0:0.6*dir)+mom}
    if(half>0){ if(x<=-half)x+=half; if(x>=0)x-=half }
    track.style.transform='translate3d('+x+'px,0,0)' }
    raf=requestAnimationFrame(step) }
  raf=requestAnimationFrame(step)
  const down=e=>{drag=true;moved=0;mom=0;lastX=e.clientX;try{el.setPointerCapture(e.pointerId)}catch(_){}}
  const move=e=>{if(!drag)return;const dx=e.clientX-lastX;lastX=e.clientX;moved+=Math.abs(dx);x+=dx;mom=dx}
  const up=()=>{drag=false}
  const enter=e=>{if(e.pointerType==='mouse')hover=true}
  const leave=()=>{hover=false}
  const click=e=>{if(moved>6){e.preventDefault();e.stopPropagation()}}
  el.addEventListener('pointerdown',down);el.addEventListener('pointermove',move);el.addEventListener('pointerup',up);el.addEventListener('pointercancel',up);el.addEventListener('pointerenter',enter);el.addEventListener('pointerleave',leave);el.addEventListener('click',click,true)
  const io=new IntersectionObserver(es=>{inview=es[0].isIntersecting},{rootMargin:'80px'});io.observe(el)
  addEventListener('resize',measure)
  return ()=>{cancelAnimationFrame(raf);io.disconnect();removeEventListener('resize',measure);
    el.removeEventListener('pointerdown',down);el.removeEventListener('pointermove',move);el.removeEventListener('pointerup',up);el.removeEventListener('pointercancel',up);el.removeEventListener('pointerenter',enter);el.removeEventListener('pointerleave',leave);el.removeEventListener('click',click,true)}
}
const FOLDS=[['cowok','gamepad','Game Cowok · Hot'],['cewek','heart','Game Cewek · Gen Z'],['voucher','gift','Voucher Game'],['genz','tv','Streaming Gen Z'],['stream','film','Drama & Olahraga'],['pc','monitor','Game PC'],['partner','users','Partner Resmi']]
const byCat=computed(()=>{const m={};for(const r of rows.value)(m[r.cat]=m[r.cat]||[]).push(r);return m})
const hot=computed(()=>[...(byCat.value.cowok||[]),...(byCat.value.cewek||[])])
function cur(l){return (l&&l.length)?l[tick.value%l.length]:null}
function dbl(l){return (l||[]).concat(l||[])}
function cta(c){return c==='voucher'?'Beli Voucher':(c==='genz'||c==='stream')?'Tonton Sekarang':'Top Up Sekarang'}
function open(o){window.open(o.url,'_blank','noopener')}
function minp(o){return o.dens&&o.dens.length?Math.min.apply(null,o.dens.map(d=>+d.p)).toLocaleString('id-ID'):''}
function he(e){const dx=e.clientX-hs.value; if(dx>40)tick.value--; else if(dx<-40)tick.value++}
</script>
<template>
<section class="gh" :class="{compact}">
  <template v-if="compact">
    <div v-if="cur(hot)" class="hero" :key="cur(hot).id" @pointerdown="hs=$event.clientX" @pointerup="he">
      <img class="hfg" :src="cur(hot).image_url" :alt="cur(hot).title" loading="lazy" decoding="async"/>
      <span class="chip">{{ PROMO[cur(hot).external_id]||'CASHBACK 0.6%' }}</span>
      <div class="ht"><b>{{cur(hot).title}}</b><button class="cta" @click="open(cur(hot))">{{cta(cur(hot).cat)}} →</button></div>
    </div>
    <div class="mq"><div class="mq-track"><button v-for="(o,i) in dbl(hot)" :key="o.id+'-'+i" class="card" @click="open(o)"><img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/><span>{{o.title}}</span><i v-if="minp(o)" class="mulai">mulai Rp{{minp(o)}}</i><i v-if="o.bonus" class="bonus">{{o.bonus}}</i><em class="buy">Beli</em></button></div></div>
  </template>
  <template v-else>
    <div v-for="([cat,ic,title],fi) in FOLDS" :key="cat">
      <div v-if="(byCat[cat]||[]).length" class="fold">
        <header><h3><Icon :name="ic" :size="16"/>{{title}}</h3><span class="live">● LIVE · geser ↔</span></header>
        <div v-if="cur(byCat[cat])" class="hero" :key="cur(byCat[cat]).id" @pointerdown="hs=$event.clientX" @pointerup="he">
          <img class="hfg" :src="cur(byCat[cat]).image_url" :alt="cur(byCat[cat]).title" loading="lazy" decoding="async"/>
          <span class="chip">{{ PROMO[cur(byCat[cat]).external_id]||'CASHBACK 0.6%' }}</span>
          <div class="ht"><b>{{cur(byCat[cat]).title}}</b><button class="cta" @click="open(cur(byCat[cat]))">{{cta(cat)}} →</button></div>
        </div>
        <div class="mq"><div class="mq-track"><button v-for="(o,i) in dbl(byCat[cat])" :key="o.id+'-'+i" class="card" @click="open(o)"><img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/><span>{{o.title}}</span><i v-if="minp(o)" class="mulai">mulai Rp{{minp(o)}}</i><i v-if="o.bonus" class="bonus">{{o.bonus}}</i><em class="buy">{{cta(cat).split(' ')[0]}}</em></button></div></div>
      </div>
    </div>
  </template>
</section>
</template>
<style scoped>
.gh{--card:#16233c;--acc:#FF7A45;--acc2:#FF4D3D;--grn:#7CFC9A;display:flex;flex-direction:column;padding:0;width:100%}
@media(min-width:1024px){.gh{max-width:1280px;margin:0 auto}}
.fold{padding:14px 0;content-visibility:auto;contain-intrinsic-size:auto 340px}
.fold header{display:flex;justify-content:space-between;align-items:center;margin:0 14px 10px}
.fold h3{display:flex;gap:8px;align-items:center;font-size:15px;font-weight:800;color:#fff}
.live{font-size:10px;color:var(--grn);font-weight:700}
.hero{position:relative;height:200px;overflow:hidden;background:linear-gradient(135deg,#1a2a4a,#0d1526);animation:fade .5s;touch-action:pan-y;cursor:grab}
.hfg{position:absolute;inset:0;width:100%;height:100%;object-fit:contain;object-position:center;pointer-events:none}
.chip{position:absolute;top:10px;left:10px;background:linear-gradient(135deg,var(--acc),var(--acc2));color:#fff;font-size:10px;font-weight:800;padding:4px 10px;border-radius:999px}
.ht{position:absolute;left:14px;bottom:10px;right:14px;display:flex;justify-content:space-between;align-items:center;color:#fff}
.ht b{font-size:16px}
.cta{border:0;border-radius:999px;padding:8px 14px;font-weight:800;font-size:11px;color:#fff;background:linear-gradient(135deg,var(--acc),var(--acc2));cursor:pointer}
.mq{overflow:hidden;padding:12px 0;cursor:grab;touch-action:pan-y}
.mq:active{cursor:grabbing}
.mq-track{display:flex;gap:12px;width:max-content;will-change:transform}
.card{flex:0 0 108px;position:relative;background:var(--card);border:0;border-radius:16px;padding:8px;cursor:pointer;color:#dfe8ff}
.card img{width:92px;height:92px;object-fit:cover;object-position:center top;border-radius:12px;pointer-events:none}
.card span{display:block;font-size:10px;margin-top:6px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.bonus{position:absolute;top:6px;left:6px;font-style:normal;font-size:8px;font-weight:800;color:#fff;background:var(--acc2);padding:2px 5px;border-radius:6px;max-width:92px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.mulai{position:absolute;bottom:44px;left:6px;font-style:normal;font-size:8px;font-weight:700;color:#9fd0ff;background:rgba(47,107,255,.18);padding:2px 5px;border-radius:6px}
.buy{position:absolute;bottom:30px;right:6px;font-style:normal;font-size:9px;font-weight:800;color:var(--grn);background:rgba(124,252,154,.15);padding:2px 6px;border-radius:999px}
@keyframes fade{from{opacity:0}to{opacity:1}}
</style>
