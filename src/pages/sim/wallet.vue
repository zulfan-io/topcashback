<script setup lang="ts">
import SimWalletChip from \'~/components/sim/SimWalletChip.vue\'
import { useSimWallet } from '~/stores/simWallet'

const {
  balance,
  pendingReward,
  txLog,
  topUp,
  spend,
  reward,
  claimReward,
  resetWallet
} = useSimWallet()
</script>

<template>
  <SimWalletChip />
  <div class="wallet-shell">
    <div class="sim-card spr-pop wallet-card">
      <div class="presence-dot pulse"></div>
      <h2>Dompet Sim</h2>

      <div class="wallet-chip">
        Saldo Rp {{ balance }}
      </div>

      <div class="wallet-chip">
        Pending reward Rp {{ pendingReward }}
      </div>

      <div class="social-rail">
        <button class="stage-badge" @click="topUp(10000)" aria-label="Top-up 10K">
          Top-up 10K
        </button>
        <button class="stage-badge" @click="reward(1000)" aria-label="Reward 1K">
          +Reward 1K
        </button>
        <button class="stage-badge" @click="claimReward()" aria-label="Claim reward">
          Claim
        </button>
        <button class="stage-badge" @click="spend(500, 'belanja stub')" aria-label="Belanja 500">
          Belanja 500
        </button>
        <button class="stage-badge" @click="resetWallet()" aria-label="Reset wallet">
          Reset
        </button>
      </div>

      <ul v-if="txLog.length" class="tx-list">
        <li
          v-for="(tx, i) in txLog.slice(0, 5)"
          :key="i"
          class="swipe-ghost"
        >
          {{ tx.note }} · {{ tx.amount > 0 ? '+' : '' }}{{ tx.amount }}
        </li>
      </ul>

      <div v-else class="swipe-ghost">
        Belum ada transaksi stub.
      </div>
    </div>
  </div>
</template>
