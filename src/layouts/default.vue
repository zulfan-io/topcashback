<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const isSim = computed(() => route.path === '/sim' || route.path.startsWith('/sim/'))
</script>

<template>
  <main v-if="isSim" class="sim-shell" data-sim-layout="clean">
    <router-view />
  </main>

  <main v-else class="px-4 py-10 text-center text-gray-700 dark:text-gray-200">
    <router-view />
    <CExtension />
    <div class="mt-5 mx-auto text-center opacity-25 text-sm">
      [Default Layout]
    </div>
  </main>
</template>

<style>
.sim-shell {
  background: #FFF7EC;
  color: #222;
  min-height: 100vh;
  padding: 16px;
  text-align: left;
  color-scheme: light;
}

.sim-shell a {
  color: inherit;
  text-decoration: none;
}
</style>
