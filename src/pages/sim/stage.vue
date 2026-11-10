<script setup lang="ts">
import SimWalletChip from '~/components/sim/SimWalletChip.vue'
import { useSimStage } from '~/stores/simStage'
import { useSimWallet } from '~/stores/simWallet'
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
      <div class="presence-dot pulse"></div>
      <h2 :style="{color:'var(--stage-accent)'}">{{ current.name }}</h2>
      <p>{{ current.theme }}</p>
      <div class="wallet-chip">Progres {{ progress }}%</div>
      <div class="wallet-chip">Badge harian {{ dailyUsed }} / {{ dailyCap }}</div>
      <div class="social-rail">
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
.stage-card{background:var(--stage-bg,#FFF7EC);color:var(--stage-fg,#2b2b2b);border:1px solid var(--stage-accent,#FF7A45);padding:14px;border-radius:22px;transition:background 260ms,color 260ms,border-color 260ms}
.stage-card h2{margin:6px 0 4px;font-size:22px}
.stage-card p{margin:0 0 10px;font-size:14px;opacity:.85}
.stage-rail{display:flex;gap:12px;overflow-x:auto;scroll-snap-type:x mandatory;margin-top:16px;padding-bottom:8px;-webkit-overflow-scrolling:touch}
.stage-rail-item{flex:0 0 60%;scroll-snap-align:center;background:var(--stage-bg);color:var(--stage-fg);border:1px solid var(--stage-accent);padding:12px;border-radius:18px}
.stage-rail-item strong{font-size:16px}
</style>
