<script setup lang="ts">
import { computed } from 'vue'
const props = withDefaults(defineProps<{ status?: 'online'|'offline'|'idle'; size?: number; absolute?: boolean }>(), { status:'offline', size:8, absolute:false })
const cls = computed(() => props.status)
</script>
<template>
  <span class="dot" :class="[cls, { abs: props.absolute }]" :style="{ width: size+'px', height: size+'px' }" />
</template>
<style scoped>
@import '../../styles/sim.css';
.dot{display:inline-block;border-radius:50%;border:2px solid var(--sim-bg);background:var(--sim-offline)}
.dot.online{background:var(--sim-online);animation:sim-pulse 2s infinite}
.dot.idle{background:var(--sim-idle)}
.dot.abs{position:absolute;right:0;bottom:0}
</style>
