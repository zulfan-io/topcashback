<script setup lang="ts">
import SocialRail from '~/components/sim/SocialRail.vue'
import profilesRaw from '~/data/simProfiles.json'
const profiles = profilesRaw as any[]
const tiles = [
  { to:'/sim/match', t:'Match', d:'swipe deck' },
  { to:'/sim/stage', t:'Stage', d:'dunia 1' },
  { to:'/sim/wallet', t:'Wallet', d:'money digital' },
  { to:'/sim/profile', t:'Profile', d:'badge & pansos' },
]
</script>
<template>
  <div class="hub">
    <header class="hd"><span class="br">shoper</span><span class="tg">sim</span></header>
    <SocialRail :stories="profiles" />
    <div class="grid">
      <router-link v-for="x in tiles" :key="x.to" :to="x.to" class="tile">
        <div class="tt">{{ x.t }}</div><div class="dd">{{ x.d }}</div>
      </router-link>
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.hub{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding-bottom:var(--sp-6)}
.hd{display:flex;align-items:baseline;gap:8px;padding:var(--sp-2) var(--sp-3)}
.br{font:800 var(--t-xl) system-ui;color:var(--sim-joy)}
.tg{font:600 var(--t-sm) system-ui;color:var(--sim-dim)}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-2);padding:var(--sp-2) var(--sp-3)}
.tile{display:block;padding:var(--sp-3);border-radius:var(--r-card);border:1px solid var(--sim-border);background:var(--sim-surface);text-decoration:none;color:inherit;transition:transform .25s var(--spring)}
.tile:active{transform:scale(.97)}
.tt{font:800 var(--t-lg) system-ui}
.dd{font:500 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:4px}
</style>
