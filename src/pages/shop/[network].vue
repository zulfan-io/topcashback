<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import ShopPage from '~/components/ShopPage.vue'
import { byKey, rateNum } from '~/config/brands'
const route=useRoute()
const b=computed(()=>{
  const k=String(route.params.network||'')
  return byKey(k)||{key:k,name:k.charAt(0).toUpperCase()+k.slice(1),tagline:'Penawaran resmi mitra.',hue:'fusion',ic:'store',rate:''}
})
</script>
<template><ShopPage :network="b.key" :brand="b.name" :tagline="b.tagline" :hue="b.hue" :ic="b.ic" :rate="rateNum(b.rate)"/></template>
