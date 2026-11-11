<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import SimBottomNav from '~/components/sim/SimBottomNav.vue'

const route = useRoute()
const isSim = computed(() => route.path === '/sim' || route.path.startsWith('/sim/'))
</script>

<template>
  <main v-if="isSim" class="sim-shell" data-sim-layout="clean">
    <router-view />
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
