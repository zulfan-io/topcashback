<script setup lang="ts">
defineProps<{ count: number; active: number }>()
</script>

<template>
  <div class="dt-row">
    <span v-for="i in count" :key="i" class="dt-dot" :class="{ on: i - 1 === active }"></span>
  </div>
</template>

<style scoped>
.dt-row { display: flex; gap: 5px; align-items: center; justify-content: center; }
.dt-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #ddd;
  transition: background 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              width 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.dt-dot.on {
  background: #FF7A45;
  width: 14px;
  border-radius: 999px;
  transform: scale(1.05);
}
</style>
