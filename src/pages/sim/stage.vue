<script setup lang="ts">
import StageBadge from '~/components/sim/StageBadge.vue'
const badges = [
  { label:'First Match', state:'earned', kind:'reward', count:1 },
  { label:'Streak 3', state:'unlocked', kind:'reward' },
  { label:'Daily Cap', state:'locked', kind:'reward', count:0 },
  { label:'Skip Penalty', state:'earned', kind:'punish', count:2 },
  { label:'World 2', state:'locked', kind:'reward' },
  { label:'Pansos', state:'unlocked', kind:'reward' },
]
</script>
<template>
  <div class="sg">
    <header class="hd"><span class="cur">Dunia 1</span><span class="sub">stub · theme beneran = FASE 2</span></header>
    <div class="row">
      <StageBadge v-for="b in badges" :key="b.label" v-bind="b" />
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.sg{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding:var(--sp-3)}
.hd{margin-bottom:var(--sp-3)}
.cur{font:800 var(--t-2xl) system-ui;color:var(--sim-joy)}
.sub{display:block;font:500 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:4px}
.row{display:flex;flex-wrap:wrap;gap:var(--sp-2)}
</style>
