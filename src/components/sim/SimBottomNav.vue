<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const items = [
  { to: '/sim',          label: 'Home',    icon: '⌂' },
  { to: '/sim/match',    label: 'Kencan',  icon: '♥' },
  { to: '/sim/stage',    label: 'Stage',   icon: '◈' },
  { to: '/sim/wallet',   label: 'Dompet',  icon: '◎' },
  { to: '/sim/commerce', label: 'Feed',    icon: '▦' },
]
const active = computed(() => route.path)
</script>

<template>
  <nav class="sim-bottom-nav" data-sim-nav="1">
    <a
      v-for="it in items"
      :key="it.to"
      :href="it.to"
      class="sim-nav-item"
      :class="{ 'sim-nav-active': active === it.to || (it.to === '/sim' && active === '/sim') }"
      :aria-label="it.label"
    >
      <span class="sim-nav-icon">{{ it.icon }}</span>
      <span class="sim-nav-label">{{ it.label }}</span>
    </a>
  </nav>
</template>

<style scoped>
.sim-bottom-nav{
  position:fixed; left:0; right:0; bottom:0; z-index:50;
  display:flex; justify-content:space-around; align-items:center;
  height:calc(64px + env(safe-area-inset-bottom)); padding:0 4px env(safe-area-inset-bottom);
  background:#fff; border-top:1px solid rgba(255,122,69,.18);
  box-shadow:0 -6px 20px rgba(34,34,34,.08);
  backdrop-filter:saturate(1.1);
}
.sim-nav-item{
  flex:1; display:flex; flex-direction:column; align-items:center; justify-content:center;
  gap:2px; text-decoration:none; color:#8a8a8a; font-size:11px;
  transition:transform 200ms cubic-bezier(.34,1.56,.64,1), color 200ms;
}
.sim-nav-item:active{ transform:translateY(-2px) scale(1.04); }
.sim-nav-icon{ font-size:20px; line-height:1; }
.sim-nav-label{ font-weight:600; letter-spacing:.2px; }
.sim-nav-active{ color:#FF4D3D; }
.sim-nav-active .sim-nav-icon{ transform:scale(1.08); }
@media (prefers-reduced-motion:reduce){ .sim-nav-item{ transition:none; } .sim-nav-item:active{ transform:none; } }
</style>
