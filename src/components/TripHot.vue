<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const rows=ref([]); const tick=ref(0); let iv=null
onMounted(async()=>{ const {data}=await supabase.from('shoper_offers').select('*').eq('network','trip').eq('active',true)
  rows.value=data||[]; iv=setInterval(()=>tick.value++,4000) })
onUnmounted(()=>clearInterval(iv))
function cur(){return rows.value.length?rows.value[tick.value%rows.value.length]:null}
function open(u){window.open(u,'_blank','noopener')}
</script>
<template>
<section class="th">
  <header><h3><img src="https://logo.clearbit.com/trip.com" alt="Trip.com"/>Trip.com · Travel</h3><span class="cb">3.51%</span></header>
  <div v-if="cur()" class="hero" :key="cur().id" @click="open(cur().url)">
    <img class="hbg" :src="cur().image_url" alt=""/><img class="hfg" :src="cur().image_url" :alt="cur().title"/>
    <div class="scrim"/><span class="chip"><Icon name="plane" :size="12"/> 11.11 MEGA SALE</span>
    <div class="ht"><b>{{cur().title}}</b><small>Klik → halaman baru · tracked</small></div>
  </div>
  <button class="cta" @click="open('https://atid.me/00q9ny002scm')"><Icon name="plane" :size="16"/> Kunjungi Trip.com</button>
</section>
</template>
<style scoped>
.th{padding:14px;display:flex;flex-direction:column;gap:10px}
.th header{display:flex;justify-content:space-between;align-items:center}
.th h3{display:flex;gap:8px;align-items:center;font-size:15px;font-weight:800;color:#1a1a1a}
.th h3 img{width:20px;height:20px;border-radius:5px}
.cb{font-size:11px;font-weight:800;color:#fff;background:linear-gradient(135deg,#2563eb,#06b6d4);padding:3px 9px;border-radius:999px}
.hero{position:relative;height:180px;border-radius:16px;overflow:hidden;cursor:pointer;animation:fade .5s}
.hbg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;filter:blur(16px) brightness(.6);transform:scale(1.15)}
.hfg{position:relative;width:100%;height:100%;object-fit:contain}
.scrim{position:absolute;inset:0;background:linear-gradient(180deg,transparent 30%,rgba(10,15,30,.85))}
.chip{position:absolute;top:10px;left:10px;display:flex;gap:5px;align-items:center;background:linear-gradient(135deg,#2563eb,#06b6d4);color:#fff;font-size:10px;font-weight:800;padding:4px 10px;border-radius:999px}
.ht{position:absolute;left:12px;bottom:10px;color:#fff}.ht b{display:block;font-size:15px}.ht small{font-size:10px;opacity:.8}
.cta{display:flex;gap:8px;align-items:center;justify-content:center;border:0;border-radius:12px;padding:11px;font-weight:800;color:#fff;background:linear-gradient(135deg,#2563eb,#06b6d4);cursor:pointer}
@keyframes fade{from{opacity:0}to{opacity:1}}
</style>
