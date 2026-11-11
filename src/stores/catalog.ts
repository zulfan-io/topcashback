import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '~/utils/supabase'

const mk = (id, name, price, stock, sold, rating) => ({
  id, name, image: null, sold, rating, price, stock, variants: [],
  models: price != null ? [{ id, sku: 'SKU' + id, price, stock, variation_index: [], is_default: true, product_id: id }] : [],
  wholesale: []
})
function placeholderFeed() {
  const f = [
    mk(1, 'Kemeja Flanel Oversize', 89000, 32, 1240, 4.8),
    mk(2, 'Celana Kargo Dewasa', null, 0, 870, 4.6),
    mk(3, 'Hoodie Fleece Premium', 135000, 14, 2100, 4.9),
    mk(4, 'Sepatu Sneakers Retro', 199000, 7, 540, 4.3),
    mk(5, 'Tas Ransel Anti Air', 159000, 21, 3300, 4.7),
    mk(6, 'Jam Tangan Digital Sport', 75000, 3, 410, 4.5)
  ]
  f[1].models = [
    { id: 2, sku: 'SKU2A', price: 120000, stock: 5, variation_index: [], is_default: false, product_id: 2 },
    { id: 3, sku: 'SKU2B', price: 150000, stock: 9, variation_index: [], is_default: true, product_id: 3 }
  ]
  return f
}
function mapOffer(o) {
  const price = o.price != null ? Number(o.price) : null
  return {
    id: o.id, name: o.title || 'Produk', image: o.image_url || null,
    sold: 0, rating: 0, price, stock: 0, variants: [], wholesale: [],
    models: price != null ? [{ id: o.id, sku: 'AFF' + o.id, price, stock: 0, variation_index: [], is_default: true, product_id: o.id }] : []
  }
}

export const useCatalog = defineStore('catalog', () => {
  const plane = ref('supabase')
  const feed = ref(placeholderFeed())
  const src = ref('live')
  const rowLabels = ref(['Rekomendasi Untukmu', 'Produk Terlaris', 'Flash Sale', 'Baru Datang'])
  const loveCounts = ref({})
  const shareCounts = ref({})
  const feedAll = computed(() => { const f = feed.value; return f.length >= 15 ? f : [...f, ...f, ...f] })
  const feedRows = computed(() => { const out = []; for (let i = 0; i < feedAll.value.length; i += 5) out.push(feedAll.value.slice(i, i + 5)); return out })

  async function loadOffers() {
    if (plane.value !== 'supabase') return
    try {
      const { data, error } = await supabase
        .from('shoper_offers')
        .select('*')
        .eq('active', true)
        .limit(24)
      if (!error && data && data.length) {
        feed.value = data.map(mapOffer)
        src.value = 'live'
      }
    } catch (e) {}
  }
  async function love(p) {
    if (plane.value !== 'supabase') return
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { console.log('login dulu buat love'); return }
    const { data: mem } = await supabase.from('shoper_members').select('id').eq('user_id', user.id).single()
    if (!mem) { console.log('belum jadi member'); return }
    const { error } = await supabase.from('shoper_loves').insert({ member_id: mem.id, target_type: 'offer', target_id: String(p.id) })
    if (!error) loveCounts.value[p.id] = (loveCounts.value[p.id] || 0) + 1
  }
  async function share(p) {
    if (plane.value !== 'supabase') return
    const { error } = await supabase.from('shoper_shares').insert({ target_type: 'offer', target_id: String(p.id), channel: 'app' })
    if (!error) shareCounts.value[p.id] = (shareCounts.value[p.id] || 0) + 1
  }
  return { plane, feed, src, rowLabels, loveCounts, shareCounts, feedAll, feedRows, loadOffers, love, share }
})
