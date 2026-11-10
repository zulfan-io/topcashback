<script setup lang="ts">
import { computed } from 'vue'
import PresenceDot from '~/components/sim/PresenceDot.vue'
const props = defineProps<{ stories:any[] }>()
const items = computed(() => props.stories.slice(0,8))
function ini(n:string){ return (n?.[0]||'?').toUpperCase() }
</script>
<template>
  <div class="rail">
    <div class="col mine">
      <div class="ring add"><span class="plus">+</span></div>
      <div class="nm">Story</div>
    </div>
    <div v-for="(s,i) in items" :key="s.id" class="col">
      <div class="ring" :class="{seen:i>2}">
        <div class="av">{{ ini(s.name) }}</div>
        <PresenceDot :status="s.presence" :size="9" absolute />
        <span v-if="i===1" class="nd" />
      </div>
      <div class="nm">{{ s.name }}</div>
    </div>
  </div>
  <div class="dots"><i v-for="n in 4" :key="n" :class="{on:n===1}" /></div>
</template>
<style scoped>
@import '../../styles/sim.css';
.rail{display:flex;gap:var(--sp-2);overflow-x:auto;padding:var(--sp-2) var(--sp-3);scrollbar-width:none}
.rail::-webkit-scrollbar{display:none}
.col{flex:0 0 auto;width:64px;text-align:center}
.ring{position:relative;width:60px;height:60px;margin:0 auto;border-radius:50%;padding:2px;background:conic-gradient(from 210deg, var(--sim-cool), var(--sim-joy), var(--sim-action), var(--sim-cool))}
.ring.seen{background:var(--sim-border)}
.ring.add{background:var(--sim-surface-2);display:grid;place-items:center;border:1px dashed var(--sim-border)}
.plus{font:700 var(--t-lg) system-ui;color:var(--sim-dim)}
.av{width:100%;height:100%;border-radius:50%;display:grid;place-items:center;font:800 var(--t-md) system-ui;color:var(--sim-cream);background:var(--sim-surface);border:2px solid var(--sim-bg)}
.nd{position:absolute;top:-2px;right:-2px;width:12px;height:12px;border-radius:50%;background:var(--sim-alarm);border:2px solid var(--sim-bg)}
.nm{font:500 var(--t-xs) system-ui;color:var(--sim-dim);margin-top:6px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.dots{display:flex;gap:5px;justify-content:center;padding-bottom:var(--sp-1)}
.dots i{width:6px;height:6px;border-radius:50%;background:var(--sim-border)}
.dots i.on{background:var(--sim-cool);width:16px;border-radius:var(--r-pill)}
</style>
