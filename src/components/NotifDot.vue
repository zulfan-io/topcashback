<script setup lang="ts">
defineProps<{ on?: boolean }>()
</script>

<template>
  <span v-if="on" class="nd-dot">
    <span class="nd-pulse"></span>
  </span>
</template>

<style scoped>
.nd-dot {
  position: absolute;
  top: -2px;
  right: -2px;
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: #FF3B30;
  border: 2px solid #fff;
  box-sizing: content-box;
  animation: nd-pop 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.nd-pulse {
  position: absolute;
  inset: -4px;
  border-radius: 50%;
  border: 2px solid #FF3B30;
  animation: nd-ring 1.5s cubic-bezier(0.34, 1.56, 0.64, 1) infinite;
}
@keyframes nd-pop {
  0% { transform: scale(0); }
  100% { transform: scale(1); }
}
@keyframes nd-ring {
  0% { transform: scale(0.8); opacity: 1; }
  100% { transform: scale(2.5); opacity: 0; }
}
</style>
