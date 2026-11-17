<script setup>
import { useRoute, useRouter } from 'vue-router'
import Icon from '~/components/Icon.vue'
const route=useRoute(); const router=useRouter()
const T=[['/','home','Home'],['/mall','store','Mall'],['/cari','search','Cari'],['/widget','grid','Widget'],['/akun','users','Akun']]
</script>
<template>
<nav class="an">
  <button v-for="[to,ic,lb] in T" :key="to" :class="{on:route.path===to}" @click="router.push(to)">
    <Icon :name="ic" :size="20"/><span>{{lb}}</span>
  </button>
</nav>
</template>
<style scoped>
.an{position:fixed;left:0;right:0;bottom:0;z-index:60;display:flex;justify-content:space-around;
 background:rgba(255,247,236,.94);backdrop-filter:blur(16px);border-top:1px solid #eadfd0;
 padding:7px 4px calc(7px + env(safe-area-inset-bottom))}
.an button{flex:1;display:flex;flex-direction:column;align-items:center;gap:3px;border:0;background:none;color:#9a8f82;font-size:9.5px;font-weight:800;cursor:pointer;padding:4px 0}
.an button.on{color:#FF4D3D}
.an button:active{transform:scale(.92)}
</style>
