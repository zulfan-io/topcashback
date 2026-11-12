<script setup lang="ts">
import IHome from '~/components/icons/IHome.vue'
import IShop from '~/components/icons/IShop.vue'
import IApplication from '~/components/icons/IApplication.vue'
import INotify from '~/components/icons/INotify.vue'
import IAccount from '~/components/icons/IAccount.vue'
const BI_REG = { IHome, IShop, IApplication, INotify, IAccount }
const BI_MAP: Record<string,string> = {"home": "IHome", "kat": "IShop", "game": "IApplication", "notif": "INotify", "saya": "IAccount"}
const BI_CFG: Record<string,{lite:string;base:string;m:string}> = {'home':{lite:'#6EE7B7',base:'#10B981',m:"url(\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' aria-hidden='true' role='img' width='1.2em' height='1.2em' preserveAspectRatio='xMidYMid meet' viewBox='0 0 24 24'><path fill='currentColor' d='M3 13h1v7c0 1.103.897 2 2 2h12c1.103 0 2-.897 2-2v-7h1a1 1 0 0 0 .707-1.707l-9-9a.999.999 0 0 0-1.414 0l-9 9A1 1 0 0 0 3 13zm7 7v-5h4v5h-4zm2-15.586l6 6V15l.001 5H16v-5c0-1.103-.897-2-2-2h-4c-1.103 0-2 .897-2 2v5H6v-9.586l6-6z' /></svg>\")"},'kat':{lite:'#9CC4FF',base:'#2F6BFF',m:"url(\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' aria-hidden='true' role='img' width='1.2em' height='1.2em' preserveAspectRatio='xMidYMid meet' viewBox='0 0 24 24'><g stroke-width='1.5' fill='none'><path d='M21.818 9.364l-1.694-5.929A.6.6 0 0 0 19.547 3H15.5l.475 5.704a.578.578 0 0 0 .278.45c.39.233 1.152.663 1.747.846c1.016.313 2.5.2 3.346.096a.57.57 0 0 0 .472-.732z' stroke='currentColor' /><path d='M14 10c.568-.175 1.288-.574 1.69-.812a.578.578 0 0 0 .28-.549L15.5 3h-7l-.47 5.639a.578.578 0 0 0 .28.55c.402.237 1.122.636 1.69.811c1.493.46 2.507.46 4 0z' stroke='currentColor' /><path d='M3.876 3.435l-1.694 5.93a.57.57 0 0 0 .472.73c.845.105 2.33.217 3.346-.095c.595-.183 1.358-.613 1.747-.845a.578.578 0 0 0 .278-.451L8.5 3H4.453a.6.6 0 0 0-.577.435z' stroke='currentColor' /><path d='M3 10v9a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-9' stroke='currentColor' /></g></svg>\")"},'game':{lite:'#FF8FB1',base:'#FF5C8A',m:"url(\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' aria-hidden='true' role='img' width='1.2em' height='1.2em' preserveAspectRatio='xMidYMid meet' viewBox='0 0 48 48'><path fill='currentColor' d='M10 14a4 4 0 1 0 0-8a4 4 0 0 0 0 8Zm14 0a4 4 0 1 0 0-8a4 4 0 0 0 0 8Zm14 0a4 4 0 1 0 0-8a4 4 0 0 0 0 8ZM10 28a4 4 0 1 0 0-8a4 4 0 0 0 0 8Zm14 0a4 4 0 1 0 0-8a4 4 0 0 0 0 8Zm14 0a4 4 0 1 0 0-8a4 4 0 0 0 0 8ZM10 42a4 4 0 1 0 0-8a4 4 0 0 0 0 8Zm14 0a4 4 0 1 0 0-8a4 4 0 0 0 0 8Zm14 0a4 4 0 1 0 0-8a4 4 0 0 0 0 8Z' /></svg>\")"},'notif':{lite:'#FFE0A3',base:'#FFB300',m:"url(\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' aria-hidden='true' role='img' width='1em' height='1em' preserveAspectRatio='xMidYMid meet' viewBox='0 0 32 32'><path fill='currentColor' d='M26 16.586V14h-2v3a1 1 0 0 0 .293.707L27 20.414V22H5v-1.586l2.707-2.707A1 1 0 0 0 8 17v-4a7.985 7.985 0 0 1 12-6.918V3.847a9.896 9.896 0 0 0-3-.796V1h-2v2.05A10.014 10.014 0 0 0 6 13v3.586l-2.707 2.707A1 1 0 0 0 3 20v3a1 1 0 0 0 1 1h7v1a5 5 0 0 0 10 0v-1h7a1 1 0 0 0 1-1v-3a1 1 0 0 0-.293-.707ZM19 25a3 3 0 0 1-6 0v-1h6Z' /><circle cx='26' cy='8' r='4' fill='currentColor' /></svg>\")"},'saya':{lite:'#A7F3D9',base:'#00B894',m:"url(\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' aria-hidden='true' role='img' width='1.4em' height='1.4em' preserveAspectRatio='xMidYMid meet' viewBox='0 0 24 24'><path fill='currentColor' d='M16.5 12c1.38 0 2.49-1.12 2.49-2.5S17.88 7 16.5 7a2.5 2.5 0 0 0 0 5zM9 11c1.66 0 2.99-1.34 2.99-3S10.66 5 9 5S6 6.34 6 8s1.34 3 3 3zm7.5 3c-1.83 0-5.5.92-5.5 2.75V18c0 .55.45 1 1 1h9c.55 0 1-.45 1-1v-1.25c0-1.83-3.67-2.75-5.5-2.75zM9 13c-2.33 0-7 1.17-7 3.5V18c0 .55.45 1 1 1h6v-2.25c0-.85.33-2.34 2.37-3.47C10.5 13.1 9.66 13 9 13z' /></svg>\")"},}
const BI_IDLE = "#9a9a9a"
function biStyle(t: any) {
  const nm = BI_MAP[t.id]; const s = BI_CFG[t.id]
  if (!nm || !s) return {}
  const on = !!t.on
  return { '--m': s.m, '--lite': on ? s.lite : BI_IDLE, '--base': on ? s.base : BI_IDLE, color: on ? s.base : BI_IDLE }
}

import { ref, computed, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useCatalog } from '~/stores/catalog'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import type { Product } from '~/schema/catalog'
import CProductCardThin from '~/components/CProductCardThin.vue'
import manifest from '~/data/ports.json'
import brands from '~/shared/brands'

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
    { id: 3, sku: 'SKU2B', price: 150000, stock: 9, variation_index: [], is_default: true, product_id: 2 }
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
const catalog = useCatalog()
const hubOpen = ref(false)
const { feed, src, rowLabels, feedAll, feedRows, loveCounts, shareCounts } = storeToRefs(catalog)
onMounted(() => catalog.loadOffers())

const storyFaces = ['A','B','C','D','E','F','G']
const chips = Object.values(brands).slice(0, 12)
const capture = manifest.reward.capture.join(' + ')
const pulsaOn = manifest.reward.pulsa_on_points

const slots = computed(() => {
  const fl = manifest.ports.filter(p => p.mount === 'floating')
  const max = manifest.ui.floating_max_slots
  const out = []
  for (let i = 0; i < max; i++) out.push(fl[i] || { id: 'slot-' + (i + 1), kind: 'segera', enabled: false, mount: 'floating' })
  return out
})

// bottom-nav ala Shopee: ikon = TEKS ASCII placeholder, ganti 1 baris pas colok ~icons/carbon lo
const tabs = [
  { id: 'home', label: 'HOME', on: true },
  { id: 'kat', label: 'KAT', on: false },
  { id: 'game', label: 'GAME', on: false },
  { id: 'notif', label: 'NOTIF', on: false },
  { id: 'saya', label: 'SAYA', on: false }
]

const router = useRouter()

async function onLove(p) { await catalog.love(p) }
async function onShare(p) { await catalog.share(p) }
function onSelect(p) {
  router.push('/list')
}
const TAB_ROUTE = { home:'/', kat:'/buyer/home', game:'/sim', notif:'/buyer/notifications', saya:'/buyer/login' }
async function onTab(t) {
  const to = TAB_ROUTE[t.id]
  if (!to) return
  if (t.id === 'saya') {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      router.push(user ? '/buyer/account/dashboard' : to)
      return
    } catch (e) { router.push(to); return }
  }
  if (t.id === 'game') { hubOpen.value = true; return }
  hubOpen.value = false
  router.push(to)
}
</script>

<template>
  <div class="dual">
    <header class="top">
      <span class="logo">shoper</span>
      <span class="tag">katalog affiliate + widget pintasan</span>
      <span class="badge" :class="src">{{ src }}</span>
    </header>

    <div class="storyrail">
      <StoryCircle v-for="(f, i) in storyFaces" :key="f" :label="f" :src="null" :read="i < 1" :size="54" ring="#FF7A45" />
    </div>
    <section class="chips">
      <button v-for="b in chips" :key="b" class="chip">{{ b }}</button>
    </section>

    <aside class="dock">
      <div v-for="w in slots" :key="w.id" class="slot" :class="{ off: !w.enabled }">
        <span class="ic">{{ w.id.slice(0, 2).toUpperCase() }}</span>
        <span class="lb">{{ w.kind }}</span>
        <span v-if="!w.enabled" class="soon">segera</span>
      </div>
    </aside>

    <section v-for="(row, ri) in feedRows" :key="ri" class="feedrow">
      <div class="lbl">{{ rowLabels[ri] || 'Rekomendasi' }}</div>
      <main class="feed">
        <CProductCardThin
          v-for="p in row"
          :key="p.id + '-' + ri"
          :product="p"
          @select="onSelect"
          @love="onLove"
          @share="onShare"
          :love-count="loveCounts[p.id] || 0"
          :share-count="shareCounts[p.id] || 0"
        />
      </main>
    </section>

    <section v-if="pulsaOn" class="reward">
      Main game -> kumpulin poin -> <b>pulsa gratis</b> dari owner
    </section>

    <nav class="botnav">
      <button
        v-for="t in tabs"
        :key="t.id"
        class="btab"
        :class="{ act: t.on }"
        @click="onTab(t)"
      ><span class="bi" :style="biStyle(t)"></span></button>
    </nav>
    <transition name="hub">
      <div v-if="hubOpen" class="hub-bd" @click.self="hubOpen=false">
        <div class="hub-panel">
          <div class="hub-grab"></div>
          <h3 class="hub-title">Gerbang <span>FOMO</span></h3>
          <div class="hub-grid">
            <button class="hub-tile" @click="hubOpen=false; $nextTick(()=>{const a=document.querySelector('aside'); (a||document.body).scrollIntoView({behavior:'smooth',block:'start'})})"><span class="ht-ic">&#9638;</span>Widget</button>
            <button class="hub-tile" @click="hubOpen=false; router.push('/sc1')"><span class="ht-ic">&#9733;</span>Status</button>
            <button class="hub-tile" @click="hubOpen=false; router.push('/gallery')"><span class="ht-ic">&#9654;</span>Vlog<span class="ht-soon">beta</span></button>
            <button class="hub-tile" @click="hubOpen=false; $nextTick(()=>{const f=document.querySelector('.feedrow'); (f||document.body).scrollIntoView({behavior:'smooth',block:'start'})})"><span class="ht-ic">&#128250;</span>Review</button>
            <button class="hub-tile" @click="hubOpen=false; router.push('/ppob')"><span class="ht-ic">&#9889;</span>PPOB</button>
            <button class="hub-tile pink" @click="hubOpen=false; router.push('/sim')"><span class="ht-ic">&#9829;</span>Kencan</button>
          </div>
          <button class="hub-x" @click="hubOpen=false">Tutup</button>
        </div>
      </div>
    </transition>

    <footer class="gate">
      Daftar member: <b>{{ capture }}</b> -> database berharga
    </footer>
  </div>
</template>

<style scoped>
.dual { max-width: 1280px; margin: 0 auto; padding: 12px clamp(12px, 3vw, 32px) 64px; font-family: system-ui, sans-serif; color: #1a1a1a; background: #f7f7f7; min-height: 100vh; }
.top { display: flex; align-items: baseline; gap: 8px; padding: 8px 0; border-bottom: 1px solid #e6e6e6; }
.logo { font-weight: 800; color: #FF7A45; font-size: 20px; }
.tag { font-size: 12px; color: #888; }
.badge { margin-left: auto; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 999px; letter-spacing: .5px; }
.badge.demo { background: #FFE0C2; color: #B34700; }
.badge.live { background: #D8F5DC; color: #1B7A2E; }
.reward { margin: 10px 0; padding: 10px 12px; background: #FFF3E9; border-radius: 10px; font-size: 13px; }
.chips { display: flex; gap: 6px; overflow-x: auto; padding: 6px 0; -webkit-overflow-scrolling: touch; }
.chip { flex: 0 0 auto; border: 1px solid #ddd; background: #fff; border-radius: 999px; padding: 5px 10px; font-size: 12px; cursor: pointer; transition: background .15s, border-color .15s, color .15s; }
.chip:active { background: #FF7A45; border-color: #FF7A45; color: #fff; }
.feedrow { margin: 8px 0; }
.feedrow .lbl { font-size: 13px; font-weight: 700; color: #1a1a1a; padding: 0 2px 4px; }
.feed { display: flex; gap: 10px; overflow-x: auto; scroll-snap-type: x mandatory; -webkit-overflow-scrolling: touch; scrollbar-width: none; margin: 4px 0; }
.feed::-webkit-scrollbar { display: none; }
.feed > * { flex: 0 0 auto; width: 30vw; max-width: 150px; scroll-snap-align: start; }
.rise-item { transition: opacity .35s ease, transform .35s ease; }
.rise-enter-from { opacity: 0; transform: translateY(14px); }
.rise-enter-to { opacity: 1; transform: none; }
.dock { display: grid; grid-template-rows: 1fr; grid-auto-flow: column; grid-auto-columns: 56px; gap: 6px; margin: 8px calc(-1 * clamp(12px, 3vw, 32px)); padding-inline: clamp(12px, 3vw, 32px); overflow-x: auto; scroll-snap-type: x mandatory; -webkit-overflow-scrolling: touch; scrollbar-width: none; }
.dock::-webkit-scrollbar { display: none; }
.dock > * { scroll-snap-align: start; }
.slot { position: relative; background: #fff; border: 1px solid #eee; border-radius: 12px; padding: 8px 2px; text-align: center; transition: background .15s, transform .15s; }
.slot:active { background: #FFF3E9; }
.slot.off { opacity: .5; }
.ic { display: block; font-weight: 800; color: #FF7A45; font-size: 15px; line-height: 1.1; }
.lb { display: block; font-size: 9px; color: #666; margin-top: 2px; }
.soon { position: absolute; top: 2px; right: 2px; font-size: 7px; background: #FF7A45; color: #fff; border-radius: 6px; padding: 1px 3px; }
.botnav { position: fixed; left: 0; right: 0; bottom: 0; display: flex; justify-content: space-around; background: #fff; border-top: 1px solid #e6e6e6; padding: 6px 4px calc(6px + env(safe-area-inset-bottom)); z-index: 5; }
.btab { flex: 1; border: 0; background: transparent; font-size: 10px; font-weight: 700; letter-spacing: .5px; color: #888; padding: 4px 0; cursor: pointer; transition: color .15s; }
.btab.act { color: #FF7A45; }
.gate { text-align: center; font-size: 12px; color: #666; padding: 10px; border-top: 1px solid #e6e6e6; }
.storyrail { display: flex; gap: 10px; overflow-x: auto; padding: 10px clamp(12px,3vw,32px); scrollbar-width: none; -webkit-overflow-scrolling: touch; scroll-snap-type: x mandatory; overscroll-behavior-x: contain; -webkit-mask-image: linear-gradient(90deg, transparent 0, #000 12px, #000 calc(100% - 12px), transparent 100%); mask-image: linear-gradient(90deg, transparent 0, #000 12px, #000 calc(100% - 12px), transparent 100%); }
.storyrail > * { scroll-snap-align: start; }
.storyrail::-webkit-scrollbar { display: none; }

.bi { display: inline-flex; width: 24px; height: 24px; -webkit-mask: var(--m) center / contain no-repeat; mask: var(--m) center / contain no-repeat; background: linear-gradient(180deg, var(--lite), var(--base)); transition: transform .26s cubic-bezier(.34,1.56,.64,1), filter .22s, opacity .2s; }
.btab:not(.act) .bi { opacity: .55; }
.btab.act .bi { transform: translateY(-2px) scale(1.12); filter: drop-shadow(0 4px 8px currentColor); }

.hub-bd{ position:fixed; inset:0; z-index:60; background:rgba(10,10,14,.55); backdrop-filter:blur(8px); display:flex; align-items:flex-end; justify-content:center; }
.hub-panel{ width:100%; max-width:480px; background:linear-gradient(180deg,#1a1018,#0f0a10); border:1px solid #3a2030; border-radius:22px 22px 0 0; padding:14px 16px 22px; box-shadow:0 -12px 40px rgba(255,92,138,.18); }
.hub-grab{ width:42px; height:4px; border-radius:99px; background:#FF8FB1; margin:0 auto 12px; opacity:.7; }
.hub-title{ font-size:15px; font-weight:800; color:#fff; margin:0 0 12px; text-align:center; letter-spacing:.3px; }
.hub-title span{ color:#FF5C8A; }
.hub-grid{ display:grid; grid-template-columns:repeat(3,1fr); gap:10px; }
.hub-tile{ position:relative; display:flex; flex-direction:column; align-items:center; gap:6px; padding:14px 8px; background:#241722; border:1px solid #3a2433; border-radius:16px; color:#ffd6e0; font-size:12px; font-weight:600; cursor:pointer; transition:transform .14s cubic-bezier(.22,1,.36,1), background .14s, border-color .14s; }
.hub-tile:active{ transform:scale(.94); }
.hub-tile.pink{ background:linear-gradient(160deg,#FF5C8A,#FF8FB1); border-color:#FF5C8A; color:#fff; }
.ht-ic{ font-size:20px; line-height:1; }
.ht-soon{ position:absolute; top:6px; right:6px; font-size:8px; font-weight:700; padding:1px 5px; border-radius:99px; background:#FFD6E0; color:#B3477A; }
.hub-x{ width:100%; margin-top:14px; background:transparent; border:1px solid #3a2433; border-radius:12px; padding:10px; color:#c98aa0; font-size:12px; font-weight:600; cursor:pointer; }
.hub-enter-active,.hub-leave-active{ transition:opacity .26s cubic-bezier(.22,1,.36,1), transform .26s cubic-bezier(.22,1,.36,1); }
.hub-enter-from,.hub-leave-to{ opacity:0; }
.hub-enter-from .hub-panel,.hub-leave-to .hub-panel{ transform:translateY(40px) scale(.97); }
.hub-enter-active .hub-panel,.hub-leave-active .hub-panel{ transition:transform .3s cubic-bezier(.22,1,.36,1); }
@media (prefers-reduced-motion: reduce){ .hub-enter-active,.hub-leave-active,.hub-enter-active .hub-panel,.hub-leave-active .hub-panel{ transition:opacity .12s; } .hub-enter-from .hub-panel,.hub-leave-to .hub-panel{ transform:none; } }
</style>

