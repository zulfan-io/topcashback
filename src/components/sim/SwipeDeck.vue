<script setup lang="ts">
import { ref, computed } from 'vue'
import SimCard from '~/components/sim/SimCard.vue'
const props = defineProps<{ cards: any[] }>()
const emit = defineEmits<{ (e:'decide', p:{dir:string; card:any}):void }>()
const stack = ref<any[]>([...props.cards])
const popped = ref<any[]>([])
const dragging = ref(false)
const dx = ref(0); const dy = ref(0); const sx = ref(0); const sy = ref(0)
const flying = ref<''|'left'|'right'|'up'>('')
const W = computed(() => (typeof window !== 'undefined' ? window.innerWidth : 360))
const TH = computed(() => W.value * 0.4)
const topStyle = computed(() => {
  if (flying.value === 'left') return { transform:'translateX(-120%) rotate(-18deg)', opacity:'0', transition:'transform .38s var(--spring-bounce), opacity .38s linear' }
  if (flying.value === 'right') return { transform:'translateX(120%) rotate(18deg)', opacity:'0', transition:'transform .38s var(--spring-bounce), opacity .38s linear' }
  if (flying.value === 'up') return { transform:'translateY(-120%)', opacity:'0', transition:'transform .38s var(--spring-bounce), opacity .38s linear' }
  if (dragging.value) return { transform:`translate(${dx.value}px, ${dy.value}px) rotate(${dx.value*0.05}deg)`, transition:'none' }
  return { transform:'translate(0,0) rotate(0deg)', transition:'transform .3s var(--spring)' }
})
const likeOp = computed(() => Math.min(1, Math.max(0, dx.value / TH.value)))
const nopeOp = computed(() => Math.min(1, Math.max(0, -dx.value / TH.value)))
const supOp  = computed(() => Math.min(1, Math.max(0, -dy.value / (TH.value * 0.8))))
function down(e:PointerEvent){ if(flying.value) return; dragging.value=true; sx.value=e.clientX; sy.value=e.clientY; (e.currentTarget as HTMLElement).setPointerCapture?.(e.pointerId) }
function move(e:PointerEvent){ if(!dragging.value) return; dx.value=e.clientX-sx.value; dy.value=e.clientY-sy.value }
function up(){ if(!dragging.value) return; dragging.value=false; const x=dx.value, y=dy.value; dx.value=0; dy.value=0; if(x>TH.value) fly('right'); else if(x<-TH.value) fly('left'); else if(y<-TH.value*0.8) fly('up'); }
function fly(dir:'left'|'right'|'up'){ const card=stack.value[0]; if(!card) return; flying.value=dir; popped.value.unshift(card); setTimeout(()=>{ stack.value.shift(); flying.value=''; emit('decide',{dir,card}) },380) }
function like(){ fly('right') } function nope(){ fly('left') } function sup(){ fly('up') }
function undo(){ const c=popped.value.shift(); if(c) stack.value.unshift(c) }
defineExpose({ like, nope, sup, undo })
</script>
<template>
  <div class="deck">
    <div v-if="!stack.length" class="empty">Deck habis — undo atau reload.</div>
    <div v-for="(c,i) in stack.slice(0,3)" :key="c.id" class="slot" :class="{top:i===0}"
      :style="i===0 ? topStyle : { transform:`translateY(${i*10}px) scale(${1-i*0.04})`, zIndex:String(10-i) }"
      @pointerdown="i===0 ? down($event) : null"
      @pointermove="i===0 ? move($event) : null"
      @pointerup="i===0 ? up() : null"
      @pointercancel="i===0 ? up() : null">
      <SimCard :profile="c" />
      <div v-if="i===0" class="ov like" :style="{opacity:likeOp}">LIKE</div>
      <div v-if="i===0" class="ov nope" :style="{opacity:nopeOp}">NOPE</div>
      <div v-if="i===0" class="ov sup"  :style="{opacity:supOp}">SUPER</div>
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.deck{position:relative;width:100%;height:100%;min-height:440px;touch-action:none}
.slot{position:absolute;inset:0}
.ov{position:absolute;top:24px;font:800 var(--t-lg) system-ui;letter-spacing:2px;padding:6px 14px;border:3px solid;border-radius:var(--r-pill);pointer-events:none}
.ov.like{left:24px;color:var(--sim-cool);border-color:var(--sim-cool);transform:rotate(-12deg)}
.ov.nope{right:24px;color:var(--sim-alarm);border-color:var(--sim-alarm);transform:rotate(12deg)}
.ov.sup{left:50%;transform:translateX(-50%);color:var(--sim-joy);border-color:var(--sim-joy)}
.empty{position:absolute;inset:0;display:grid;place-items:center;color:var(--sim-dim)}
</style>
