<route lang="yaml">
meta:
  layout: admin/LADashboard
</route>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'

const ADMIN_EMAIL = 'zulfanmeta04@gmail.com'
const router = useRouter()
const user = ref(null)
const isAdmin = ref(false)
const loading = ref(true)
const err = ref('')

const ADMIN_TILES = [
  { id: 'dash', label: 'Dashboard Seller', to: '/admin/dashboard', ic: '\u25A6', hint: 'mock thuonthrong' },
  { id: 'aff', label: 'Affiliate CRUD', to: '/admin/affiliate', ic: '\uD83D\uDD17', hint: 'shoper_offers' },
  { id: 'cat', label: 'Kategori', to: '/admin/category/attributes', ic: '\u2630', hint: 'attributes' },
  { id: 'reset', label: 'Reset', to: '/admin/account/reset', ic: '\u21BA', hint: 'password' },
]
const USER_TILES = [
  { id: 'udash', label: 'Akun Ku', to: '/buyer/account/dashboard', ic: '\uD83D\uDC64', hint: 'profil' },
  { id: 'uord', label: 'Pesanan', to: '/buyer/account/orders', ic: '\uD83D\uDCE6', hint: 'order' },
  { id: 'sim', label: 'Kencan', to: '/sim', ic: '\u2665', hint: 'dating' },
  { id: 'st', label: 'Status', to: '/sc1', ic: '\u2605', hint: 'sosmed' },
  { id: 'vl', label: 'Vlog', to: '/gallery', ic: '\u25B6', hint: 'beta' },
  { id: 'ppob', label: 'PPOB', to: '/ppob', ic: '\u26A1', hint: 'pulsa/listrik' },
]

function go(t) { router.push(t.to) }

onMounted(async () => {
  loading.value = true
  try {
    const { data: { user: u }, error } = await supabase.auth.getUser()
    if (error) { err.value = error.message; loading.value = false; return }
    if (!u) { router.replace('/admin/login'); return }
    user.value = u
    isAdmin.value = (u.email === ADMIN_EMAIL)
  } catch (e) { err.value = 'Supabase paused?'; }
  loading.value = false
})
</script>

<template>
  <div class="omni">
    <header class="omni-head">
      <h1>OMNI <span>hub</span></h1>
      <p class="omni-sub">1 kesatuan nyambung seluruh admin. Pembeda: {{ isAdmin ? 'ADMIN' : 'USER' }}.</p>
      <div v-if="err" class="omni-msg err">{{ err }}</div>
      <div v-if="loading" class="omni-msg">Memeriksa sesi…</div>
    </header>

    <section v-if="isAdmin" class="omni-grp admin">
      <h2 class="omni-grp-t">Akses Admin <em>penuh</em></h2>
      <div class="omni-grid">
        <button v-for="t in ADMIN_TILES" :key="t.id" class="omni-tile" @click="go(t)">
          <span class="ot-ic">{{ t.ic }}</span>
          <span class="ot-lb">{{ t.label }}</span>
          <span class="ot-hint">{{ t.hint }}</span>
        </button>
      </div>
    </section>

    <section class="omni-grp user">
      <h2 class="omni-grp-t">Akses User <em>terbatas</em></h2>
      <div class="omni-grid">
        <button v-for="t in USER_TILES" :key="t.id" class="omni-tile u" @click="go(t)">
          <span class="ot-ic">{{ t.ic }}</span>
          <span class="ot-lb">{{ t.label }}</span>
          <span class="ot-hint">{{ t.hint }}</span>
        </button>
      </div>
      <p v-if="!isAdmin" class="omni-note">Login admin untuk membuka gerbang penuh.</p>
    </section>
  </div>
</template>

<style scoped>
.omni{ max-width:1100px; margin:0 auto; padding:16px clamp(12px,3vw,24px) 80px; font-family:system-ui,sans-serif; color:#1a1a1a; text-align:left; }
.omni-head h1{ font-size:22px; font-weight:800; margin:0 0 4px; color:#FF7A45; }
.omni-head h1 span{ color:#00B8A9; }
.omni-sub{ font-size:12px; color:#777; margin:0 0 12px; }
.omni-msg{ font-size:12px; padding:8px 12px; border-radius:10px; margin:8px 0; background:#FFF7EC; color:#B34700; }
.omni-msg.err{ background:#FDECEA; color:#B3261E; }
.omni-grp{ margin:14px 0; }
.omni-grp-t{ font-size:14px; font-weight:700; margin:0 0 10px; }
.omni-grp.admin .omni-grp-t em{ color:#FF7A45; }
.omni-grp.user .omni-grp-t em{ color:#00B8A9; }
.omni-grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(150px,1fr)); gap:10px; }
.omni-tile{ display:flex; flex-direction:column; align-items:flex-start; gap:4px; padding:14px 12px; background:#fff; border:1px solid #eee; border-radius:14px; cursor:pointer; text-align:left; transition:transform .14s cubic-bezier(.22,1,.36,1), box-shadow .14s, border-color .14s; }
.omni-tile:active{ transform:scale(.96); }
.omni-grp.admin .omni-tile:hover{ border-color:#FF7A45; box-shadow:0 6px 20px rgba(255,122,69,.15); }
.omni-grp.user .omni-tile.u:hover{ border-color:#00B8A9; box-shadow:0 6px 20px rgba(0,184,169,.15); }
.ot-ic{ font-size:20px; line-height:1; }
.ot-lb{ font-size:13px; font-weight:700; color:#1a1a1a; }
.ot-hint{ font-size:10px; color:#999; }
.omni-note{ font-size:11px; color:#888; margin-top:8px; }
@media (max-width:640px){ .omni-grid{ grid-template-columns:repeat(2,1fr); } }
</style>
