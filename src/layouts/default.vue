<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import SimBottomNav from '~/components/sim/SimBottomNav.vue'

const route = useRoute()
const isSim = computed(() => route.path === '/sim' || route.path.startsWith('/sim/'))
const router = useRouter()
const TABS = ['/sim','/sim/match','/sim/stage','/sim/wallet','/sim/commerce']
let sx=0, sy=0, st=0
function onTouchStart(e){ const t=e.touches[0]; sx=t.clientX; sy=t.clientY; st=Date.now() }
function onTouchEnd(e){
  if (route.path.startsWith('/sim/match')) return
  const t=e.changedTouches[0]; const dx=t.clientX-sx; const dy=t.clientY-sy; const dt=Date.now()-st
  if (dt>600 || Math.abs(dx)<60 || Math.abs(dx)<Math.abs(dy)*1.5) return
  if (sx<28 && dx>0){ router.back(); return }
  const i=TABS.indexOf(route.path); if (i<0) return
  const n = dx<0 ? Math.min(TABS.length-1,i+1) : Math.max(0,i-1)
  if (n!==i) router.push(TABS[n])
}
</script>

<template>
  <main v-if="isSim" class="sim-shell" data-sim-layout="clean">
    <div class="sim-swipe" @touchstart.passive="onTouchStart" @touchend.passive="onTouchEnd">
      <router-view />
    </div>
    <SimBottomNav />
  </main>

  <main v-else class="px-4 py-10 text-center text-gray-700" data-app-chrome="clean">
    <router-view />
  </main>
</template>

<style>
.sim-shell {
  background: #FFF7EC;
  color: #222;
  min-height: 100vh;
  padding: calc(16px + env(safe-area-inset-top)) 16px calc(80px + env(safe-area-inset-bottom));
  text-align: left;
  color-scheme: light;
}

.sim-shell a {
  color: inherit;
  text-decoration: none;
}
</style>
