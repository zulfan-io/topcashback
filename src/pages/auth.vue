<script setup>
import { supabase } from '~/utils/supabase'

const email = ref('')
const pass = ref('')
const msg = ref('')
const logged = ref(false)
const uid = ref('')

onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  if (session?.user) {
    logged.value = true
    uid.value = session.user.id
    msg.value = 'SESSION DIPULIHKAN uuid=' + session.user.id
  }
  supabase.auth.onAuthStateChange((_e, s) => {
    logged.value = !!s?.user
    uid.value = s?.user?.id ?? ''
  })
})

const signIn = async () => {
  msg.value = 'loading...'
  const { data, error } = await supabase.auth.signInWithPassword({ email: email.value, password: pass.value })
  if (error) { msg.value = 'GAGAL: ' + error.message; return }
  logged.value = true
  uid.value = data.user.id
  msg.value = 'LOGIN OK uuid=' + data.user.id
}

const signOut = async () => {
  await supabase.auth.signOut()
  logged.value = false
  uid.value = ''
  msg.value = 'logout'
}

const insertTest = async () => {
  msg.value = 'insert...'
  const { data, error } = await supabase.from('shoper_offers').insert({
    network: 'accesstrade',
    external_id: 'mono-' + Date.now(),
    title: 'TEST MONOPOLY',
    image_url: '',
    price: 0,
    commission: 0,
    url: 'https://topcashback.shopergo.workers.dev',
    meta_json: { note: 'rls-proof' },
    active: true,
  }).select()
  if (error) { msg.value = 'DITOLAK RLS: ' + error.message; return }
  msg.value = 'NONGOL id=' + (data?.[0]?.id ?? '?') + ' -> cek etalase /'
}
</script>

<template>
  <div class="p-6 max-w-md mx-auto">
    <h2 class="text-xl font-bold mb-4">Auth Supabase (uji monopoly)</h2>
    <div v-if="!logged" class="space-y-3">
      <input v-model="email" type="email" placeholder="email" autocomplete="off" class="w-full border rounded p-2">
      <input v-model="pass" type="password" placeholder="password" autocomplete="off" class="w-full border rounded p-2">
      <button @click="signIn" class="bg-orange-500 text-white rounded p-2 w-full">SIGN IN</button>
    </div>
    <div v-else class="space-y-3">
      <p class="text-green-500 text-sm">login sbg: {{ uid }}</p>
      <button @click="insertTest" class="bg-blue-600 text-white rounded p-2 w-full">INSERT 1 OFFER TES</button>
      <button @click="signOut" class="border rounded p-2 w-full">LOGOUT</button>
    </div>
    <p class="mt-4 text-sm text-gray-500 break-all">{{ msg }}</p>
  </div>
</template>
