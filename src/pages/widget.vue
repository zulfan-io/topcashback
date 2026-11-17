<script setup>
import { useRouter } from 'vue-router'
import Icon from '~/components/Icon.vue'
import BrandMarquee from '~/components/BrandMarquee.vue'
import { LIVE } from '~/config/brands'
const router=useRouter()
</script>
<template>
<main class="wg">
  <header class="bar"><button class="ib" @click="router.push('/')" aria-label="Kembali"><Icon name="back" :size="18"/></button><b>Widget</b></header>
  <BrandMarquee/>
  <div class="grid">
    <button v-for="b in LIVE" :key="b.key" class="tile" @click="router.push(b.to)">
      <span class="tl"><img :src="b.logo" :alt="b.name"/></span><b>{{b.name}}</b><small>{{b.sub}}</small>
    </button>
  </div>
</main>
</template>
<style scoped>
.wg{min-height:100vh;background:#FFF7EC;padding-bottom:90px;font-family:system-ui,sans-serif}
.bar{position:sticky;top:0;display:flex;gap:10px;align-items:center;padding:calc(10px + env(safe-area-inset-top)) 14px 10px;background:rgba(255,247,236,.94);backdrop-filter:blur(12px);border-bottom:1px solid #eadfd0}
.bar b{font-size:15px}.ib{width:36px;height:36px;display:grid;place-items:center;border:1px solid #eadfd0;border-radius:11px;background:#fff;cursor:pointer}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;padding:14px;max-width:1280px;margin:0 auto}
.tile{display:flex;flex-direction:column;align-items:flex-start;gap:4px;border:0;border-radius:16px;padding:14px;cursor:pointer;text-align:left;color:#fff;background:linear-gradient(150deg,#FF8A4D,#FF4D3D 75%,#E63946)}
.tl{width:40px;height:40px;display:grid;place-items:center;border-radius:12px;background:#fff;margin-bottom:4px}
.tl img{width:26px;height:26px;object-fit:contain}
.tile b{font-size:14px}.tile small{font-size:9.5px;opacity:.9}
</style>
