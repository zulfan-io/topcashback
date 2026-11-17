<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
const r=useRouter(); onMounted(()=>r.replace('/mall'))
</script>
<template><div style="min-height:100vh;background:#FFF7EC"></div></template>
