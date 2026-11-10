<script setup lang="ts">
import PresenceDot from '~/components/sim/PresenceDot.vue'
import StageBadge from '~/components/sim/StageBadge.vue'
import profilesRaw from '~/data/simProfiles.json'
const me = (profilesRaw as any[])[0]
const pinned = [ {label:'First Match',state:'earned',kind:'reward'}, {label:'Pansos',state:'unlocked',kind:'reward'} ]
</script>
<template>
  <div class="pf">
    <div class="top">
      <div class="av-wrap"><div class="av">{{ me.name[0] }}</div><PresenceDot :status="me.presence" :size="12" absolute /></div>
      <div class="who"><div class="nm">{{ me.name }}, {{ me.age }}</div><div class="bio">{{ me.bio }}</div></div>
    </div>
    <div class="sec">
      <div class="lbl">badge di-pin (pansos)</div>
      <div class="row"><StageBadge v-for="b in pinned" :key="b.label" v-bind="b" /></div>
    </div>
    <div class="sec">
      <div class="lbl">dia lagi beli apa</div>
      <div class="ph">opt-in · commerce card = FASE 4</div>
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.pf{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding:var(--sp-3);display:flex;flex-direction:column;gap:var(--sp-4)}
.top{display:flex;gap:var(--sp-2);align-items:center}
.av-wrap{position:relative}
.av{width:72px;height:72px;border-radius:50%;display:grid;place-items:center;font:800 var(--t-xl) system-ui;color:var(--sim-cream);background:linear-gradient(135deg,var(--sim-joy),var(--sim-action));border:2px solid var(--sim-bg)}
.nm{font:800 var(--t-lg) system-ui}
.bio{font:500 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:2px}
.lbl{font:700 var(--t-sm) system-ui;color:var(--sim-dim);margin-bottom:var(--sp-1)}
.row{display:flex;flex-wrap:wrap;gap:var(--sp-1)}
.ph{border:1px dashed var(--sim-border);border-radius:var(--r-card);padding:var(--sp-3);color:var(--sim-dim);font:500 var(--t-sm) system-ui}
</style>
