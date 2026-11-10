// KANTONG 5 — WALLET STUB store (FASE 3 ringan)
// Self-contained, NOL Pinia, NOL Supabase, NOL Midtrans/Xendit beneran.
import { ref, computed } from 'vue'

type Tx = {
  type: 'topup' | 'spend' | 'reward' | 'claim' | 'reset'
  amount: number
  note: string
}

const balance = ref(0)
const pendingReward = ref(0)
const txLog = ref<Tx[]>([])

export function useSimWallet() {
  const canSpend = computed(() => (amount: number) => balance.value >= amount)

  function topUp(amount = 10000) {
    balance.value += amount
    txLog.value.unshift({ type: 'topup', amount, note: 'stub top-up' })
  }

  function spend(amount = 500, note = 'badge stub') {
    if (balance.value < amount) return false
    balance.value -= amount
    txLog.value.unshift({ type: 'spend', amount: -amount, note })
    return true
  }

  function reward(amount = 1000) {
    pendingReward.value += amount
    txLog.value.unshift({ type: 'reward', amount, note: 'stub reward' })
  }

  function claimReward() {
    if (pendingReward.value <= 0) return false
    const amount = pendingReward.value
    balance.value += amount
    pendingReward.value = 0
    txLog.value.unshift({ type: 'claim', amount, note: 'claim reward' })
    return true
  }

  function resetWallet() {
    balance.value = 0
    pendingReward.value = 0
    txLog.value = [{ type: 'reset', amount: 0, note: 'wallet reset' }]
  }

  return {
    balance,
    pendingReward,
    txLog,
    canSpend,
    topUp,
    spend,
    reward,
    claimReward,
    resetWallet
  }
}
