<template>
  <div class="cl-wrap" aria-busy="true" aria-label="Memuat">
    <div class="cl-head skel"></div>
    <div class="cl-row">
      <span v-for="i in 5" :key="i" class="cl-circle skel"></span>
    </div>
    <div class="cl-grid">
      <div v-for="i in 6" :key="i" class="cl-card">
        <div class="cl-img skel"></div>
        <div class="cl-line skel"></div>
        <div class="cl-line short skel"></div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.cl-wrap{padding:16px;min-height:60vh}
.cl-head{height:28px;width:40%;margin-bottom:16px}
.cl-row{display:flex;gap:12px;margin-bottom:20px}
.cl-circle{width:56px;height:56px;border-radius:50%}
.cl-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.cl-card{background:#fff;border-radius:12px;padding:8px}
.cl-img{height:120px;border-radius:8px;margin-bottom:8px}
.cl-line{height:12px;margin-bottom:6px}
.cl-line.short{width:60%}
</style>
