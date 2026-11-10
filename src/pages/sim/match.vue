<script setup lang="ts">
import { ref } from 'vue'
import SwipeDeck from '~/components/sim/SwipeDeck.vue'
import WalletChip from '~/components/sim/WalletChip.vue'
import profilesRaw from '~/data/simProfiles.json'
const profiles = profilesRaw as any[]
const deck = ref<Record<string, () => void> | null>(null)
const swiped = ref(0)
function onDecide(){ swiped.value++ }
</script>
<template>
  <div class="mt">
    <div class="bar">
      <router-link to="/sim" class="bk">←</router-link>
      <span class="ti">match</span>
      <WalletChip :balance="0" />
    </div>
    <div class="stage"><SwipeDeck ref="deck" :cards="profiles" @decide="onDecide" /></div>
    <div class="ctl">
      <button class="c undo" @click="deck?.undo()">↺</button>
      <button class="c nope" @click="deck?.nope()">✕</button>
      <button class="c sup"  @click="deck?.sup()">★</button>
      <button class="c like" @click="deck?.like()">♥</button>
    </div>
    <div class="cnt">swiped: {{ swiped }}</div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.mt{height:100vh;display:flex;flex-direction:column;background:var(--sim-bg);color:var(--sim-text)}
.bar{display:flex;align-items:center;gap:var(--sp-2);padding:var(--sp-2) var(--sp-3)}
.bk{font:700 var(--t-lg) system-ui;color:var(--sim-dim);text-decoration:none}
.ti{flex:1;font:800 var(--t-lg) system-ui}
.stage{flex:1;padding:0 var(--sp-3)}
.ctl{display:flex;justify-content:center;gap:var(--sp-3);padding:var(--sp-3)}
.c{width:56px;height:56px;border-radius:50%;border:1px solid var(--sim-border);background:var(--sim-surface-2);font:700 var(--t-xl) system-ui;color:var(--sim-text);cursor:pointer;transition:transform .2s var(--spring-bounce)}
.c:active{transform:scale(.9)}
.c.undo{color:var(--sim-joy)} .c.nope{color:var(--sim-alarm)} .c.sup{color:var(--sim-joy)} .c.like{color:var(--sim-cool)}
.cnt{text-align:center;font:500 var(--t-xs) system-ui;color:var(--sim-dim);padding-bottom:var(--sp-2)}
</style>
