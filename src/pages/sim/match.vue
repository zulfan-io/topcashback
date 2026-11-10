<script setup lang="ts">
import SimWalletChip from \'~/components/sim/SimWalletChip.vue\'
import { useSimMatch } from '~/stores/simMatch'
const { current, remaining, swipeHistory, matchQueue, decide, undo, reset } = useSimMatch()
</script>

<template>
  <SimWalletChip />
  <div class="swipe-deck">
    <div v-if="remaining > 1" class="sim-card swipe-ghost" aria-hidden="true">
      <div class="presence-dot"></div>
    </div>

    <div v-if="current" class="sim-card spr-pop">
      <div class="presence-dot" :class="{ pulse: current.online }"></div>
      <h2>{{ current.name }}</h2>
      <p>{{ current.bio }}</p>
      <span>{{ current.city }} · {{ current.distance }} km</span>
      <div class="wallet-chip">{{ current.price === 0 ? 'GRATIS' : current.price }}</div>
    </div>

    <div v-else class="sim-card">
      <p>Semua profil sudah di-swipe.</p>
      <button class="stage-badge" @click="reset">Mulai Ulang</button>
    </div>

    <div class="social-rail">
      <button class="stage-badge" @click="decide('nope')" aria-label="Pass">&#10005;</button>
      <button class="stage-badge" @click="undo()" aria-label="Undo">&#8634;</button>
      <button class="stage-badge" @click="decide('like')" aria-label="Like">&#9829;</button>
      <button class="stage-badge" @click="decide('sup')" aria-label="Super Like">&#9733;</button>
    </div>

    <div class="wallet-chip">Super-like 50 · Undo 20 <span class="swipe-ghost">(belum diblokir)</span></div>
    <div class="wallet-chip">
      Sisa {{ remaining }} · Match {{ matchQueue.length }} · Swipe {{ swipeHistory.length }}
    </div>
  </div>
</template>
