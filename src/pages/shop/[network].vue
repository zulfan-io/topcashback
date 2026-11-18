<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MallPage from '~/components/MallPage.vue'
const route=useRoute()
const net=computed(()=>String(route.params.network||'shopee'))
</script>
<template><MallPage :network="net"/></template>
