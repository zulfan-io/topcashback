<script setup lang="ts">
import { useSimWallet } from '~/stores/simWallet'
const { balance, pendingReward } = useSimWallet()
</script>

<template>
  <div class="sim-wallet-chip wallet-chip spr" data-simchip="1">
    <strong>Dompet Rp {{ balance }}</strong>
    <span v-if="pendingReward > 0" class="swipe-ghost"> (+{{ pendingReward }} pending)</span>
  </div>
</template>
