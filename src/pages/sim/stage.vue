<script setup lang="ts">
import SimWalletChip from '~/components/sim/SimWalletChip.vue'
import { useSimStage } from '~/stores/simStage'
import { useSimWallet } from '~/stores/simWallet'
import { useRoute } from 'vue-router'
import { computed } from 'vue'
const route = useRoute()
const dev = computed(() => route.query.dev !== undefined)
const { stages, current, progress, canUnlock, dailyUsed, dailyCap, nextStage, addProgress, resetDay, resetAll } = useSimStage()
const wallet = useSimWallet()
function claimStageReward(){ wallet.reward(1000); wallet.claimReward() }
const stageThemes: Record<string, Record<string,string>> = {
  s1: { '--stage-bg':'#FFF7EC', '--stage-fg':'#2b2b2b', '--stage-accent':'#FF7A45' },
  s2: { '--stage-bg':'#0f2e2b', '--stage-fg':'#FFF7EC', '--stage-accent':'#00B8A9' },
  s3: { '--stage-bg':'#2b1414', '--stage-fg':'#FFF7EC', '--stage-accent':'#FF4D3D' },
}
function themeFor(id:string){ return stageThemes[id] || stageThemes.s1 }
const activeTheme = () => (current.value ? themeFor(current.value.id) : stageThemes.s1)
</script>
<template>
  <SimWalletChip />
  <div class="stage-page">
    <div v-if="current" class="stage-card sim-card spr-pop" :style="activeTheme()">
      <span class="paper p2" aria-hidden="true"></span>
      <span class="paper p1" aria-hidden="true"></span>
      <span class="paper p0" aria-hidden="true"></span>
      <div class="presence-dot pulse"></div>
      <h2 :style="{color:'var(--stage-accent)'}">{{ current.name }}</h2>
      <p>{{ current.theme }}</p>
      <div class="wallet-chip">Progres {{ progress }}%</div>
      <div class="wallet-chip">Badge harian {{ dailyUsed }} / {{ dailyCap }}</div>
      <div v-if="dev" class="social-rail">
        <button class="stage-badge" @click="addProgress(10)" aria-label="Tambah progres">+10%</button>
        <button class="stage-badge" @click="nextStage()" aria-label="Naik stage">Naik Stage</button>
        <button class="stage-badge" @click="claimStageReward()" aria-label="Klaim Reward Stage">Klaim Reward Stage</button>
        <button class="stage-badge" @click="resetDay()" aria-label="Reset harian">Reset Harian</button>
        <button class="stage-badge" @click="resetAll()" aria-label="Reset semua">Reset Semua</button>
      </div>
      <div v-if="!canUnlock" class="swipe-ghost">Badge harian habis. Reset stub atau besok.</div>
    </div>
    <div v-else class="stage-card sim-card swipe-ghost">Semua stage stub selesai.</div>
    <div class="stage-rail">
      <div v-for="s in stages" :key="s.id" class="stage-rail-item sim-card" :style="themeFor(s.id)" :class="{ 'spr-pop': current && current.id === s.id }">
        <span class="presence-dot pulse"></span>
        <strong :style="{color:'var(--stage-accent)'}">{{ s.name }}</strong>
        <span class="swipe-ghost">{{ s.badgeCost }} badge</span>
      </div>
    </div>
  </div>
</template>
<style scoped>
.stage-page{padding:4px 0}
.stage-card{position:relative;z-index:0;overflow:hidden;background:transparent;color:var(--stage-fg,#2b2b2b);padding:14px;border-radius:22px;transition:color 260ms}
.stage-card > :not(.paper){position:relative;z-index:1}
.paper{position:absolute;inset:0;border-radius:22px;background:var(--stage-bg,#FFF7EC);border:1px solid var(--stage-accent,#FF7A45)}
.paper.p0{box-shadow:0 10px 24px rgba(34,34,34,.14)}
.paper.p1{transform:rotate(-2deg) translate(-5px,7px);opacity:.5}
.paper.p2{transform:rotate(1.6deg) translate(6px,11px);opacity:.28}
.stage-card h2{margin:6px 0 4px;font-size:22px}
.stage-card p{margin:0 0 10px;font-size:14px;opacity:.85}
.stage-rail{display:flex;gap:12px;overflow-x:auto;scroll-snap-type:x mandatory;margin-top:16px;padding-bottom:8px;-webkit-overflow-scrolling:touch}
.stage-rail-item{flex:0 0 60%;scroll-snap-align:center;background:var(--stage-bg);color:var(--stage-fg);border:1px solid var(--stage-accent);padding:12px;border-radius:18px;box-shadow:0 4px 0 -1px var(--stage-bg),0 4px 0 0 var(--stage-accent),0 10px 0 -4px var(--stage-bg),0 10px 0 -3px var(--stage-accent);transition:transform 260ms cubic-bezier(.34,1.56,.64,1)}
.stage-rail-item strong{font-size:16px}
</style>
