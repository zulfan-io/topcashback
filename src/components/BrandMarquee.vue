<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { BRANDS } from '~/config/brands'
const router=useRouter(); const root=ref(null); let raf=0,clean=[]
onMounted(()=>{ const el=root.value; if(!el)return
  const track=el.querySelector('.bm-track'); let half=0,x=0,drag=false,last=0,mom=0,seen=true
  const measure=()=>{half=track.scrollWidth/2}
  measure()
  const step=()=>{ if(seen&&!drag){mom*=.94;x-=.5+mom; if(half>0&&x<=-half)x+=half}
    track.style.transform='translate3d('+x+'px,0,0)'; raf=requestAnimationFrame(step)}
  raf=requestAnimationFrame(step)
  const down=e=>{drag=true;last=e.clientX;try{el.setPointerCapture(e.pointerId)}catch(_){}}
  const move=e=>{if(!drag)return;const dx=e.clientX-last;last=e.clientX;x+=dx;mom=dx}
  const up=()=>{drag=false}
  el.addEventListener('pointerdown',down);el.addEventListener('pointermove',move);el.addEventListener('pointerup',up);el.addEventListener('pointercancel',up)
  const io=new IntersectionObserver(es=>{seen=es[0].isIntersecting},{rootMargin:'80px'});io.observe(el)
  addEventListener('resize',measure)
  clean.push(()=>{cancelAnimationFrame(raf);io.disconnect();removeEventListener('resize',measure)})
})
onUnmounted(()=>clean.forEach(f=>f()))
function go(b){router.push(b.live?b.to:'/widget')}
</script>
<template>
<div class="bm" ref="root"><div class="bm-track">
  <button v-for="(b,i) in BRANDS.concat(BRANDS)" :key="b.key+i" class="bm-c" @click="go(b)">
    <span class="bm-l"><img :src="b.logo" :alt="b.name" loading="lazy" decoding="async"/></span>
    <span class="bm-n">{{b.name}}</span>
  </button>
</div></div>
</template>
<style scoped>
.bm{overflow:hidden;padding:10px 0;cursor:grab;touch-action:pan-y}
.bm:active{cursor:grabbing}
.bm-track{display:flex;gap:14px;width:max-content;will-change:transform;padding:0 14px}
.bm-c{flex:0 0 64px;display:flex;flex-direction:column;align-items:center;gap:5px;border:0;background:none;cursor:pointer}
.bm-l{width:52px;height:52px;display:grid;place-items:center;border-radius:50%;background:#fff;border:2px solid #FF7A45;box-shadow:0 4px 12px rgba(255,122,69,.2)}
.bm-l img{width:30px;height:30px;object-fit:contain}
.bm-n{font-size:9px;font-weight:800;color:#7b7268;max-width:64px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
</style>
