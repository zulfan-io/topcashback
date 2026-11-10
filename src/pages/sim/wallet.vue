<script setup lang="ts">
import WalletChip from '~/components/sim/WalletChip.vue'
const bal = 0
const tx: any[] = []
</script>
<template>
  <div class="wl">
    <div class="big"><span class="cur">Rp</span><span class="num">{{ bal.toLocaleString('id-ID') }}</span></div>
    <div class="hint">top-up & earn = FASE 3 (Midtrans/Xendit sandbox). NOL free path.</div>
    <div class="list">
      <div v-if="!tx.length" class="empty">Belum ada transaksi.</div>
    </div>
    <div class="foot"><WalletChip :balance="bal" /></div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.wl{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding:var(--sp-4) var(--sp-3);display:flex;flex-direction:column;gap:var(--sp-3)}
.big{display:flex;align-items:baseline;gap:6px}
.cur{font:700 var(--t-lg) system-ui;color:var(--sim-dim)}
.num{font:800 var(--t-2xl) system-ui;color:var(--sim-cream)}
.hint{font:500 var(--t-sm) system-ui;color:var(--sim-dim)}
.list{flex:1;border:1px dashed var(--sim-border);border-radius:var(--r-card);padding:var(--sp-3)}
.empty{color:var(--sim-dim);font:500 var(--t-sm) system-ui}
.foot{display:flex;justify-content:center}
</style>
