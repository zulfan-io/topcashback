<script setup lang="ts">
defineProps<{ balance:number; currency?:string }>()
const emit = defineEmits<{ (e:'open'):void }>()
function fmt(n:number){ return n.toLocaleString('id-ID') }
</script>
<template>
  <button class="chip" @click="emit('open')">
    <span class="coin" />
    <span class="amt">{{ currency || 'Rp' }}{{ fmt(balance) }}</span>
  </button>
</template>
<style scoped>
@import '../../styles/sim.css';
.chip{display:inline-flex;align-items:center;gap:8px;padding:6px 12px 6px 8px;border-radius:var(--r-pill);border:1px solid var(--sim-border);background:var(--sim-surface-2);cursor:pointer}
.coin{width:18px;height:18px;border-radius:50%;background:radial-gradient(circle at 35% 30%, var(--sim-cream), var(--sim-joy) 60%, var(--sim-action));box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)}
.amt{font:700 var(--t-sm) system-ui;color:var(--sim-text)}
</style>
