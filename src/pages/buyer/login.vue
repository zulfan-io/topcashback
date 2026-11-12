<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'

const router = useRouter()
const email = ref('')
const password = ref('')
const busy = ref(false)
const err = ref('')
const ok = ref('')

async function go() {
  err.value = ''
  ok.value = ''
  if (!email.value || !password.value) { err.value = 'Isi email & password dulu.'; return }
  busy.value = true
  const { error } = await supabase.auth.signInWithPassword({ email: email.value, password: password.value })
  busy.value = false
  if (error) { err.value = error.message || 'Login gagal.'; return }
  ok.value = 'Masuk. Membuka katalog...'
  router.push('/')
}

onMounted(async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (user) router.replace('/')
})
</script>

<template>
  <div class="lg-wrap">
    <div class="lg-card">
      <div class="lg-brand">shopergo <span>buyer</span></div>
      <h1>Masuk</h1>
      <p class="lg-sub">Login pakai akun Supabase lo. NOL OAuth, NOL plane-lama.</p>
      <label class="lg-lb">Email</label>
      <input v-model="email" type="email" inputmode="email" autocomplete="username" placeholder="email lo" />
      <label class="lg-lb">Password</label>
      <input v-model="password" type="password" autocomplete="current-password" placeholder="password lo" @keyup.enter="go" />
      <div v-if="err" class="lg-msg err">{{ err }}</div>
      <div v-if="ok" class="lg-msg ok">{{ ok }}</div>
      <button class="lg-btn" :disabled="busy" @click="go">{{ busy ? 'Memproses…' : 'SIGN IN' }}</button>
    </div>
  </div>
</template>

<style scoped>
.lg-wrap{ min-height:100vh; display:flex; align-items:center; justify-content:center; padding:24px 16px; background:#0f1115; font-family:system-ui,sans-serif; }
.lg-card{ width:100%; max-width:380px; background:#171a21; border:1px solid #262b34; border-radius:18px; padding:24px 20px; color:#e8e8e8; box-shadow:0 12px 40px rgba(0,0,0,.4); }
.lg-brand{ font-size:13px; font-weight:800; letter-spacing:.5px; color:#FF7A45; text-transform:uppercase; }
.lg-brand span{ color:#00B8A9; }
.lg-card h1{ font-size:22px; font-weight:800; margin:10px 0 2px; color:#fff; }
.lg-sub{ font-size:12px; color:#8a909c; margin:0 0 18px; }
.lg-lb{ display:block; font-size:12px; color:#aab0bb; margin:12px 0 6px; }
.lg-card input{ width:100%; box-sizing:border-box; background:#0f1115; border:1px solid #2c323d; border-radius:10px; padding:12px 14px; font-size:15px; color:#fff; outline:none; }
.lg-card input:focus{ border-color:#FF7A45; }
.lg-msg{ font-size:12px; border-radius:8px; padding:8px 10px; margin-top:12px; }
.lg-msg.err{ background:#2a1416; color:#ff8a80; border:1px solid #4a1f23; }
.lg-msg.ok{ background:#10241f; color:#7fe3c8; border:1px solid #1c3f37; }
.lg-btn{ width:100%; margin-top:18px; background:#FF4D3D; color:#fff; border:0; border-radius:12px; padding:13px; font-size:15px; font-weight:700; cursor:pointer; transition:transform .12s, opacity .12s; }
.lg-btn:active{ transform:scale(.98); }
.lg-btn:disabled{ opacity:.6; cursor:not-allowed; }
</style>
