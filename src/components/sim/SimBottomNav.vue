<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const items = [
  { to: '/sim',          label: 'Home',   icon: 'home' },
  { to: '/sim/match',    label: 'Kencan', icon: 'heart' },
  { to: '/sim/stage',    label: 'Stage',  icon: 'stage' },
  { to: '/sim/wallet',   label: 'Dompet', icon: 'wallet' },
  { to: '/sim/commerce', label: 'Feed',   icon: 'feed' },
]
const active = computed(() => route.path)
const idx = computed(() => Math.max(0, items.findIndex(i => i.to === active.value)))
</script>

<template>
  <nav class="sim-bottom-nav" data-sim-nav="1">
    <span class="sim-nav-pill" :style="{ transform: `translateX(${idx * 100}%)` }" aria-hidden="true"></span>
    <RouterLink
      v-for="it in items"
      :key="it.to"
      :to="it.to"
      class="sim-nav-item"
      :class="{ 'sim-nav-active': active === it.to }"
      :aria-label="it.label"
    >
      <CIcon :name="it.icon" :active="active === it.to" :size="22" />
      <span class="sim-nav-label">{{ it.label }}</span>
    </RouterLink>
  </nav>
</template>

<style scoped>
.sim-bottom-nav{
  position:fixed; left:0; right:0; bottom:0; z-index:50;
  display:flex; justify-content:space-around; align-items:center;
  height:calc(64px + env(safe-area-inset-bottom)); padding:0 4px env(safe-area-inset-bottom);
  background:#fff; border-top:1px solid rgba(255,122,69,.18);
  box-shadow:0 -6px 20px rgba(34,34,34,.08);
}
.sim-nav-pill{
  position:absolute; top:6px; left:0; width:20%;
  height:calc(100% - 12px - env(safe-area-inset-bottom));
  background:rgba(255,122,69,.10); border-radius:14px;
  transition:transform .32s cubic-bezier(.34,1.56,.64,1);
  pointer-events:none;
}
.sim-nav-item{
  flex:1; display:flex; flex-direction:column; align-items:center; justify-content:center;
  gap:2px; text-decoration:none; color:#8a8a8a; font-size:11px;
  position:relative; z-index:1;
  transition:transform .18s cubic-bezier(.34,1.56,.64,1), color .2s;
}
.sim-nav-item:active{ transform:translateY(-2px) scale(1.04); }
.sim-nav-label{ font-weight:600; letter-spacing:.2px; }
.sim-nav-active{ color:#FF4D3D; }
@media (prefers-reduced-motion:reduce){
  .sim-nav-pill,.sim-nav-item{ transition:none; }
  .sim-nav-item:active{ transform:none; }
}
</style>
