<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
const router = useRouter()
onMounted(() => router.replace('/admin/omni'))
</script>
<template><div class="adm-redir">Mengalihkan ke dashboard…</div></template>
<style scoped>.adm-redir{ padding:40px; text-align:center; color:#8a909c; font-family:system-ui,sans-serif; }</style>
