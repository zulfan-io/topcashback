import { ref } from 'vue'
import { supabase } from '~/utils/supabase'
// SEAM 1 sumber buat web+APK (pola useCatalog). SSR-safe: call hanya di fungsi.
const products = ref<any[]>([])
const order = ref<any>(null)
const busy = ref(false)
const err = ref('')
const FN = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/ppob`
async function load() {
  const { data, error } = await supabase.from('ppob_products').select('*').eq('active', true).order('sort')
  if (error) err.value = error.message; else products.value = data || []
}
async function create(code: string, target: string) {
  busy.value = true; err.value = ''
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) { err.value = 'Login dulu.'; busy.value = false; return }
  const r = await fetch(FN, { method: 'POST', headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${session.access_token}` }, body: JSON.stringify({ action: 'create', code, target }) })
  const j = await r.json(); busy.value = false
  if (j.error) err.value = j.error; else order.value = j.order
}
async function poll() {
  if (!order.value) return
  const { data } = await supabase.from('ppob_orders').select('*').eq('id', order.value.id).single()
  if (data) order.value = data
}
export function usePpob() { return { products, order, busy, err, load, create, poll } }
