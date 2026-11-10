// KANTONG 6 — COMMERCE STUB store (FASE 4 ringan)
// Self-contained, NOL Pinia, NOL Supabase, NOL payment, NOL CGiftRow/ports.json.
import { ref, computed } from 'vue'

type Item = { id: string; name: string; price: number; qty: number }

const feed = ref([
  { id: 'c1', name: 'Kopi Susu Gula Aren', price: 18000, cat: 'F&B', aff: 'shopee' },
  { id: 'c2', name: 'Sepatu Lari Ringan', price: 249000, cat: 'Fashion', aff: 'tokopedia' },
  { id: 'c3', name: 'Tumbler Stainless', price: 75000, cat: 'Rumah', aff: 'lazada' },
  { id: 'c4', name: 'Headphone Wireless', price: 199000, cat: 'Elektronik', aff: 'shopee' },
  { id: 'c5', name: 'Skincare Serum', price: 120000, cat: 'Beauty', aff: 'tokopedia' },
  { id: 'c6', name: 'Snack Box Hemat', price: 35000, cat: 'F&B', aff: 'lazada' },
])

const cart = ref<Item[]>([])
const vouchers = ref(['DISKON10', 'ONGRISGRATIS', 'CASHBACK5'])

export function useSimCommerce() {
  const cartTotal = computed(() => cart.value.reduce((s, i) => s + i.price * i.qty, 0))
  const cartCount = computed(() => cart.value.reduce((s, i) => s + i.qty, 0))

  function addToCart(p: { id: string; name: string; price: number }) {
    const found = cart.value.find(i => i.id === p.id)
    if (found) found.qty += 1
    else cart.value.push({ id: p.id, name: p.name, price: p.price, qty: 1 })
  }
  function removeFromCart(id: string) { cart.value = cart.value.filter(i => i.id !== id) }
  function clearCart() { cart.value = [] }
  function checkout() { if (cart.value.length === 0) return false; clearCart(); return true }

  return { feed, cart, vouchers, cartTotal, cartCount, addToCart, removeFromCart, clearCart, checkout }
}
