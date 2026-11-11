<script setup lang="ts">
import { ref } from 'vue'
const items = ref([
  { id: 1, title: 'Badge harianmu tinggal 1', body: 'Claim sebelum reset 00:00 UTC.', ago: '2 mnt lalu', unread: true },
  { id: 2, title: 'Produk favorit hampir habis', body: 'Kemeja Flanel Oversize stok 3.', ago: '1 jam lalu', unread: true },
  { id: 3, title: 'Selamat datang di shopergo', body: 'Daftar member buat mulai ngumpulin poin.', ago: 'kemarin', unread: false },
])
function markRead(i){ i.unread = false }
</script>

<template>
  <div class="notif-page">
    <header class="notif-top">
      <button class="back" @click="$router.back()" aria-label="Balik">&larr;</button>
      <h1>Notifikasi</h1>
      <span class="count">{{ items.filter(i=>i.unread).length }} baru</span>
    </header>
    <ul class="notif-list">
      <li v-for="i in items" :key="i.id" class="notif-item" :class="{ unread: i.unread }" @click="markRead(i)">
        <div class="ni-dot" v-if="i.unread"></div>
        <div class="ni-body">
          <strong>{{ i.title }}</strong>
          <p>{{ i.body }}</p>
          <span class="ni-ago">{{ i.ago }}</span>
        </div>
      </li>
    </ul>
    <p class="notif-empty" v-if="!items.length">Belum ada notifikasi.</p>
  </div>
</template>

<style scoped>
.notif-page{ max-width:640px; margin:0 auto; padding:12px clamp(12px,3vw,24px) 80px; font-family:system-ui,sans-serif; color:#1a1a1a; background:#f7f7f7; min-height:100vh; text-align:left; }
.notif-top{ display:flex; align-items:center; gap:10px; padding:8px 0; border-bottom:1px solid #e6e6e6; }
.notif-top h1{ font-size:18px; font-weight:800; margin:0; flex:1; }
.back{ border:0; background:transparent; font-size:20px; cursor:pointer; color:#FF7A45; padding:4px 8px; }
.count{ font-size:11px; font-weight:700; color:#FF4D3D; }
.notif-list{ list-style:none; margin:8px 0; padding:0; display:flex; flex-direction:column; gap:8px; }
.notif-item{ display:flex; gap:10px; background:#fff; border:1px solid #eee; border-radius:12px; padding:12px; cursor:pointer; transition:background .15s, transform .15s; }
.notif-item:active{ transform:scale(.99); }
.notif-item.unread{ background:#FFF3E9; border-color:#FFE0C2; }
.ni-dot{ width:8px; height:8px; border-radius:50%; background:#FF4D3D; flex:0 0 auto; margin-top:6px; }
.ni-body{ flex:1; }
.ni-body strong{ display:block; font-size:14px; }
.ni-body p{ margin:2px 0 0; font-size:13px; color:#555; }
.ni-ago{ display:block; margin-top:4px; font-size:11px; color:#999; }
.notif-empty{ text-align:center; color:#888; font-size:13px; padding:24px; }
@media (prefers-reduced-motion:reduce){ .notif-item{ transition:none; } .notif-item:active{ transform:none; } }
</style>
