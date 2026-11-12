<route lang="yaml">
meta:
  layout: admin/LADashboard
</route>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'

const router = useRouter()
const offers = ref([])
const loading = ref(true)
const err = ref('')
const ok = ref('')
const editing = ref({})
const draft = ref({ title: '', price: '', image_url: '', affiliate_link: '', active: true })

async function load() {
  loading.value = true
  err.value = ''
  const { data, error } = await supabase.from('shoper_offers').select('*').order('id')
  if (error) err.value = error.message
  else offers.value = data || []
  loading.value = false
}
function startEdit(o) { editing.value[String(o.id)] = o.affiliate_link || '' }
function setLink(o, e) { editing.value[String(o.id)] = e.target.value }
async function saveLink(o) {
  const val = editing.value[String(o.id)]
  const { error } = await supabase.from('shoper_offers').update({ affiliate_link: val }).eq('id', o.id)
  if (error) err.value = 'save gagal: ' + error.message
  else { ok.value = 'link tersimpan #' + o.id; o.affiliate_link = val }
}
async function toggleActive(o) {
  const next = !o.active
  const { error } = await supabase.from('shoper_offers').update({ active: next }).eq('id', o.id)
  if (error) err.value = 'toggle gagal: ' + error.message
  else { o.active = next; ok.value = (next ? 'aktif' : 'nonaktif') + ' #' + o.id }
}
async function del(o) {
  const { error } = await supabase.from('shoper_offers').delete().eq('id', o.id)
  if (error) err.value = 'hapus gagal: ' + error.message
  else { offers.value = offers.value.filter(x => x.id !== o.id); ok.value = 'hapus #' + o.id }
}
async function add() {
  const payload = {
    title: draft.value.title || 'Produk',
    price: draft.value.price ? Number(draft.value.price) : null,
    image_url: draft.value.image_url || null,
    affiliate_link: draft.value.affiliate_link || null,
    active: draft.value.active,
  }
  const { data, error } = await supabase.from('shoper_offers').insert(payload).select().single()
  if (error) err.value = 'tambah gagal: ' + error.message
  else {
    offers.value = [data, ...offers.value]
    draft.value = { title: '', price: '', image_url: '', affiliate_link: '', active: true }
    ok.value = 'offer baru #' + data.id
  }
}
onMounted(async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) { router.replace('/admin/login'); return }
  load()
})
</script>

<template>
  <div class="aff-page">
    <header class="aff-head">
      <h1>CRUD Affiliate</h1>
      <p class="aff-sub">Ngutak-atik <code>shoper_offers.affiliate_link</code> langsung dari dashboard lo. Sinkron & keamanan nyusul (arah Coi).</p>
    </header>
    <div v-if="err" class="aff-msg err">{{ err }}</div>
    <div v-if="ok" class="aff-msg ok">{{ ok }}</div>

    <section class="aff-add">
      <h2>Tambah Offer</h2>
      <div class="aff-row">
        <input v-model="draft.title" placeholder="judul" />
        <input v-model="draft.price" placeholder="harga" inputmode="numeric" />
        <input v-model="draft.image_url" placeholder="image_url" />
        <input v-model="draft.affiliate_link" placeholder="affiliate_link (click.accesstrade...)" />
        <label class="aff-chk"><input type="checkbox" v-model="draft.active" /> active</label>
        <button class="aff-btn primary" @click="add">+ Simpan</button>
      </div>
    </section>

    <section class="aff-list">
      <h2>Daftar Offer ({{ offers.length }})</h2>
      <div v-if="loading" class="aff-empty">Loading…</div>
      <div v-else-if="!offers.length" class="aff-empty">Belum ada offer. Tambah di atas, atau seed via dashboard Supabase.</div>
      <table v-else class="aff-table">
        <thead><tr><th>#</th><th>Judul</th><th>Harga</th><th>Active</th><th>affiliate_link</th><th>Aksi</th></tr></thead>
        <tbody>
          <tr v-for="o in offers" :key="String(o.id)">
            <td>{{ o.id }}</td>
            <td>{{ o.title || '—' }}</td>
            <td>{{ o.price != null ? 'Rp' + o.price : '—' }}</td>
            <td><button class="aff-btn sm" @click="toggleActive(o)">{{ o.active ? '✓' : '✗' }}</button></td>
            <td><input class="aff-link" :value="editing[String(o.id)] ?? (o.affiliate_link || '')" @focus="startEdit(o)" @input="setLink(o, $event)" /></td>
            <td class="aff-act">
              <button class="aff-btn sm primary" @click="saveLink(o)">Save</button>
              <button class="aff-btn sm danger" @click="del(o)">Hapus</button>
            </td>
          </tr>
        </tbody>
      </table>
    </section>
  </div>
</template>

<style scoped>
.aff-page{ max-width:1100px; margin:0 auto; padding:16px clamp(12px,3vw,24px) 80px; font-family:system-ui,sans-serif; color:#1a1a1a; text-align:left; }
.aff-head h1{ font-size:20px; font-weight:800; margin:0 0 4px; color:#FF7A45; }
.aff-sub{ font-size:12px; color:#777; margin:0 0 12px; }
.aff-sub code{ background:#FFF3E9; padding:1px 5px; border-radius:6px; font-size:11px; }
.aff-msg{ padding:8px 12px; border-radius:10px; font-size:13px; margin:8px 0; }
.aff-msg.err{ background:#FDECEA; color:#B3261E; border:1px solid #F5C6C0; }
.aff-msg.ok{ background:#E8F5E9; color:#1B7A2E; border:1px solid #C8E6C9; }
.aff-add{ background:#fff; border:1px solid #eee; border-radius:14px; padding:12px; margin:8px 0 16px; }
.aff-add h2, .aff-list h2{ font-size:14px; margin:0 0 8px; }
.aff-row{ display:flex; flex-wrap:wrap; gap:8px; align-items:center; }
.aff-row input{ flex:1 1 140px; min-width:120px; border:1px solid #ddd; border-radius:8px; padding:7px 9px; font-size:13px; }
.aff-chk{ display:flex; align-items:center; gap:4px; font-size:12px; }
.aff-btn{ border:1px solid #ddd; background:#fff; border-radius:8px; padding:7px 12px; font-size:13px; cursor:pointer; transition:background .15s, transform .15s; }
.aff-btn:active{ transform:scale(.97); }
.aff-btn.primary{ background:#FF7A45; border-color:#FF7A45; color:#fff; }
.aff-btn.danger{ background:#fff; border-color:#E63946; color:#E63946; }
.aff-btn.sm{ padding:5px 9px; font-size:12px; }
.aff-table{ width:100%; border-collapse:collapse; font-size:13px; background:#fff; border:1px solid #eee; border-radius:12px; overflow:hidden; }
.aff-table th, .aff-table td{ padding:8px 10px; border-bottom:1px solid #f0f0f0; text-align:left; vertical-align:middle; }
.aff-table th{ background:#FFF7EC; font-weight:700; }
.aff-link{ width:100%; border:1px solid #eee; border-radius:6px; padding:5px 7px; font-size:12px; }
.aff-act{ display:flex; gap:6px; }
.aff-empty{ padding:18px; text-align:center; color:#888; font-size:13px; background:#fafafa; border-radius:12px; }
@media (max-width:640px){ .aff-table{ font-size:12px; } .aff-link{ font-size:11px; } }
</style>
