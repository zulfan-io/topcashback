<script setup lang="ts">
withDefaults(defineProps<{ label:string; state?:'locked'|'unlocked'|'earned'; kind?:'reward'|'punish'; count?:number }>(), { state:'locked', kind:'reward' })
</script>
<template>
  <span class="bdg" :class="[state, kind]">
    <i class="pip" />
    <span class="lb">{{ label }}</span>
    <span v-if="count !== undefined" class="ct">{{ count }}</span>
  </span>
</template>
<style scoped>
@import '../../styles/sim.css';
.bdg{display:inline-flex;align-items:center;gap:6px;padding:6px 12px;border-radius:var(--r-pill);border:1px solid var(--sim-border);background:var(--sim-surface-2);font:600 var(--t-xs) system-ui;color:var(--sim-dim)}
.pip{width:8px;height:8px;border-radius:50%;background:var(--sim-offline)}
.unlocked{color:var(--sim-text)} .unlocked .pip{background:var(--sim-cool)}
.earned{color:var(--sim-cream);border-color:var(--sim-joy)} .earned .pip{background:var(--sim-joy)}
.punish.earned{border-color:var(--sim-alarm)} .punish .pip{background:var(--sim-alarm)}
.ct{margin-left:2px;background:rgba(255,255,255,.08);padding:0 6px;border-radius:var(--r-pill)}
</style>
