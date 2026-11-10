<script setup lang="ts">
import { useSimStage } from '~/stores/simStage'

const {
  current,
  progress,
  canUnlock,
  dailyUsed,
  dailyCap,
  nextStage,
  addProgress,
  resetDay,
  resetAll
} = useSimStage()
</script>

<template>
  <div class="stage-shell">
    <div v-if="current" class="sim-card spr-pop stage-card">
      <div class="presence-dot pulse"></div>
      <h2>{{ current.name }}</h2>
      <p>{{ current.theme }}</p>

      <div class="wallet-chip">
        Progres {{ progress }}%
      </div>

      <div class="wallet-chip">
        Badge harian {{ dailyUsed }} / {{ dailyCap }}
      </div>

      <div class="social-rail">
        <button class="stage-badge" @click="addProgress(10)" aria-label="Tambah progres">
          +10%
        </button>
        <button class="stage-badge" @click="nextStage()" aria-label="Naik stage">
          Naik Stage
        </button>
        <button class="stage-badge" @click="resetDay()" aria-label="Reset harian">
          Reset Harian
        </button>
        <button class="stage-badge" @click="resetAll()" aria-label="Reset semua">
          Reset Semua
        </button>
      </div>

      <div v-if="!canUnlock" class="swipe-ghost">
        Badge harian habis. Coba lagi besok atau reset stub.
      </div>
    </div>

    <div v-else class="sim-card swipe-ghost">
      Semua stage stub sudah selesai.
    </div>
  </div>
</template>
