<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const router=useRouter(); const root=ref(null)
const rows=ref([]); const tick=ref(0); const state=ref('load'); const hs=ref(0)
let iv=null; let cleanups=[]
const RATE=0.1261
function rp(n){return 'Rp'+Number(n||0).toLocaleString('id-ID')}
async function load(){
  state.value='load'
  const {data,error}=await supabase.from('shoper_offers').select('*').eq('network','traveloka').eq('active',true).limit(120)
  if(error){state.value='error';return}
  rows.value=(data||[]).map(r=>{const m=typeof r.meta_json==='string'?JSON.parse(r.meta_json||'{}'):(r.meta_json||{})
    return {...r,cat:(m.cat||'ATTRACTION').toUpperCase(),city:m.city||m.region||m.country||'',country:m.country||'',brief:m.brief||''}})
  state.value=rows.value.length?'ok':'empty'
}
onMounted(async()=>{ await load(); iv=setInterval(()=>tick.value++,5200); await nextTick(); mount() })
onUnmounted(()=>{clearInterval(iv);cleanups.forEach(f=>f())})
const top=computed(()=>[...rows.value].sort((a,b)=>a.price-b.price).slice(0,18))
const hero=computed(()=>rows.value.length?rows.value[tick.value%rows.value.length]:null)
const minPrice=computed(()=>rows.value.length?Math.min.apply(null,rows.value.map(r=>r.price)):0)
function dbl(l){const a=(l||[]).slice(0,14);return a.concat(a)}
function goDetail(o){router.push('/travel?p='+encodeURIComponent(o.external_id))}
function goAll(){router.push('/travel')}
function he(e){const dx=e.clientX-hs.value;if(dx>40)tick.value--;else if(dx<-40)tick.value++}
function mount(){ cleanups.forEach(f=>f()); cleanups=[]
  if(!root.value)return
  root.value.querySelectorAll('.mq').forEach((el,i)=>cleanups.push(marquee(el,i%2?1:-1))) }
function marquee(el,dir){
  const track=el.querySelector('.mq-track'); if(!track)return()=>{}
  let half=0,x=0,raf=0,drag=false,hover=false,seen=true,mom=0,last=0,moved=0
  const measure=()=>{half=track.scrollWidth/2;if(dir>0&&x===0)x=-half}
  measure()
  const step=()=>{ if(seen){ if(!drag){mom*=0.94;x+=(hover?0:0.5*dir)+mom}
    if(half>0){if(x<=-half)x+=half;if(x>=0)x-=half}
    track.style.transform='translate3d('+x+'px,0,0)'} raf=requestAnimationFrame(step)}
  raf=requestAnimationFrame(step)
  const down=e=>{drag=true;moved=0;mom=0;last=e.clientX;try{el.setPointerCapture(e.pointerId)}catch(_){}}
  const move=e=>{if(!drag)return;const dx=e.clientX-last;last=e.clientX;moved+=Math.abs(dx);x+=dx;mom=dx}
  const up=()=>{drag=false}
  const enter=e=>{if(e.pointerType==='mouse')hover=true}
  const leave=()=>{hover=false}
  const click=e=>{if(moved>6){e.preventDefault();e.stopPropagation()}}
  el.addEventListener('pointerdown',down);el.addEventListener('pointermove',move);el.addEventListener('pointerup',up)
  el.addEventListener('pointercancel',up);el.addEventListener('pointerenter',enter);el.addEventListener('pointerleave',leave)
  el.addEventListener('click',click,true)
  const io=new IntersectionObserver(es=>{seen=es[0].isIntersecting},{rootMargin:'90px'});io.observe(el)
  addEventListener('resize',measure)
  return ()=>{cancelAnimationFrame(raf);io.disconnect();removeEventListener('resize',measure)
    el.removeEventListener('pointerdown',down);el.removeEventListener('pointermove',move);el.removeEventListener('pointerup',up)
    el.removeEventListener('pointercancel',up);el.removeEventListener('pointerenter',enter);el.removeEventListener('pointerleave',leave)
    el.removeEventListener('click',click,true)}
}
</script>
<template>
<section class="th" ref="root">
  <header class="th-h">
    <h3><Icon name="compass" :size="17"/>Traveloka Xperience</h3>
    <button class="th-all" @click="goAll">Lihat semua<Icon name="chevron" :size="13"/></button>
  </header>
  <div v-if="state==='load'" class="th-sk"><div v-for="n in 3" :key="n" class="sk"/></div>
  <div v-else-if="state==='error'" class="th-msg"><Icon name="refresh" :size="18"/><span>Katalog belum termuat.</span><button @click="load().then(()=>nextTick().then(mount))">Coba lagi</button></div>
  <div v-else-if="state==='empty'" class="th-msg"><Icon name="compass" :size="18"/><span>Destinasi sedang disiapkan.</span><button @click="goAll">Buka katalog</button></div>
  <template v-else>
    <div v-if="hero" class="hero" :key="hero.id" @pointerdown="hs=$event.clientX" @pointerup="he" @click="goDetail(hero)">
      <img class="hb" :src="hero.image_url" alt="" aria-hidden="true" loading="lazy" decoding="async"/>
      <img class="hf" :src="hero.image_url" :alt="hero.title" loading="lazy" decoding="async"/>
      <div class="sc"/>
      <span class="loc"><Icon name="pin" :size="11"/>{{hero.city||hero.country}}</span>
      <span class="pr">{{rp(hero.price)}}</span>
      <div class="ht">
        <div class="hx"><b>{{hero.title}}</b><small>{{hero.brief||'Tiket resmi · e-voucher · konfirmasi cepat'}}</small></div>
        <button class="cta" @click.stop="goDetail(hero)">Lihat</button>
      </div>
    </div>
    <div class="mq"><div class="mq-track">
      <button v-for="(o,i) in dbl(top)" :key="o.id+'-'+i" class="cd" @click="goDetail(o)">
        <img :src="o.image_url" :alt="o.title" loading="lazy" decoding="async"/>
        <span class="cn">{{o.title}}</span>
        <span class="cl"><Icon name="pin" :size="9"/>{{o.city||o.country}}</span>
        <span class="cp">{{rp(o.price)}}</span>
        <em class="cb">+{{rp(Math.round(o.price*RATE))}}</em>
      </button>
    </div></div>
    <button class="th-cta" @click="goAll">
      <Icon name="ticket" :size="15"/>Jelajahi {{rows.length}} destinasi · mulai {{rp(minPrice)}}<Icon name="chevron" :size="14"/>
    </button>
  </template>
</section>
</template>
<style scoped>
.th{--deep:#04222B;--surf:#0C333D;--teal:#00B8A9;--sky:#2F6BFF;--amber:#FFB300;--ink:#EAF7F7;
 background:linear-gradient(168deg,#04222B,#08303A 60%,#04222B);color:var(--ink);padding:14px 0 16px;position:relative;overflow:hidden;width:100%}
.th::before{content:'';position:absolute;inset:-30% -10% auto;height:65%;pointer-events:none;
 background:radial-gradient(58% 58% at 18% 0%,rgba(0,184,169,.24),transparent 70%),radial-gradient(48% 48% at 88% 8%,rgba(47,107,255,.20),transparent 70%)}
@media(min-width:1024px){.th{max-width:1280px;margin:0 auto;border-radius:22px}}
.th-h{display:flex;justify-content:space-between;align-items:center;margin:0 14px 10px;position:relative}
.th-h h3{display:flex;gap:8px;align-items:center;margin:0;font-size:16px;font-weight:800;color:#fff}
.th-all{display:flex;gap:3px;align-items:center;border:0;background:none;color:#7fd8cf;font-size:12px;font-weight:800;cursor:pointer}
.th-sk{display:flex;gap:10px;padding:0 14px}
.sk{flex:1;height:120px;border-radius:16px;background:linear-gradient(100deg,#0C333D 30%,#14454F 50%,#0C333D 70%);background-size:220% 100%;animation:sh 1.2s linear infinite}
@keyframes sh{from{background-position:120% 0}to{background-position:-20% 0}}
.th-msg{display:flex;gap:9px;align-items:center;justify-content:center;padding:18px;color:#bfe3e0;font-size:12px}
.th-msg button{border:0;border-radius:999px;padding:7px 14px;font-weight:800;font-size:11px;color:#04222B;background:linear-gradient(135deg,var(--teal),#7CF5D8);cursor:pointer}
.hero{position:relative;height:196px;overflow:hidden;cursor:pointer;background:#072a33;animation:fd .45s ease;touch-action:pan-y}
.hb{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;filter:brightness(.44) saturate(1.15);transform:scale(1.05)}
.hf{position:absolute;inset:0;width:100%;height:100%;object-fit:contain;pointer-events:none}
.sc{position:absolute;inset:0;background:linear-gradient(180deg,rgba(4,34,43,.1),transparent 34%,rgba(4,34,43,.93))}
.loc{position:absolute;top:10px;left:12px;display:flex;gap:5px;align-items:center;max-width:58%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;
 background:rgba(4,34,43,.72);border:1px solid rgba(0,184,169,.5);color:#9ff0e4;font-size:10px;font-weight:800;padding:4px 9px;border-radius:999px}
.pr{position:absolute;top:10px;right:12px;background:linear-gradient(135deg,var(--amber),#FF8A3D);color:#2b1600;font-size:12px;font-weight:900;padding:5px 11px;border-radius:999px}
.ht{position:absolute;left:14px;right:14px;bottom:12px;display:flex;gap:12px;align-items:flex-end;justify-content:space-between}
.hx{min-width:0}
.hx b{display:block;font-size:15px;color:#fff;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.hx small{display:block;font-size:11px;color:#bcded9;margin-top:3px;max-height:2.6em;overflow:hidden;line-height:1.3}
.cta{flex:0 0 auto;border:0;border-radius:999px;padding:9px 15px;font-weight:900;font-size:12px;color:#04222B;background:linear-gradient(135deg,var(--teal),#7CF5D8);cursor:pointer}
.mq{overflow:hidden;padding:12px 0;cursor:grab;touch-action:pan-y}
.mq:active{cursor:grabbing}
.mq-track{display:flex;gap:11px;width:max-content;will-change:transform;padding:0 14px}
.cd{flex:0 0 142px;position:relative;background:var(--surf);border:1px solid rgba(255,255,255,.07);border-radius:15px;padding:7px;cursor:pointer;color:var(--ink);text-align:left;transition:transform .14s,border-color .14s}
.cd:active{transform:scale(.96);border-color:rgba(0,184,169,.55)}
.cd img{width:100%;height:88px;object-fit:cover;border-radius:10px;pointer-events:none;background:#0a2c35}
.cn{display:block;font-size:10.5px;font-weight:700;margin-top:6px;line-height:1.25;height:2.5em;overflow:hidden}
.cl{display:flex;gap:3px;align-items:center;font-size:9px;color:#8fc7c2;margin-top:2px;white-space:nowrap;overflow:hidden}
.cp{display:block;font-size:12px;font-weight:900;color:var(--amber);margin-top:3px}
.cb{position:absolute;top:12px;right:12px;font-style:normal;font-size:8.5px;font-weight:900;color:#04222B;background:linear-gradient(135deg,var(--teal),#7CF5D8);padding:2px 6px;border-radius:999px}
.th-cta{display:flex;gap:8px;align-items:center;justify-content:center;width:calc(100% - 28px);margin:2px 14px 0;border:1px solid rgba(0,184,169,.45);
 border-radius:13px;padding:11px;background:rgba(0,184,169,.10);color:#9ff0e4;font-size:12px;font-weight:800;cursor:pointer}
.th-cta:active{background:rgba(0,184,169,.2)}
@keyframes fd{from{opacity:0}to{opacity:1}}
</style>
