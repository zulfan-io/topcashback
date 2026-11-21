<script setup lang="ts">
import { computed } from 'vue'
import type { Product } from '~/schema/catalog'

const props = defineProps<{ product: Product; loveCount?: number; shareCount?: number }>()
const emit = defineEmits<{ (e: 'select', p: Product): void; (e: 'love', p: Product): void; (e: 'share', p: Product): void }>()

const priceText = computed(() => {
  const p = props.product
  if (p.price != null) return 'Rp' + p.price.toLocaleString('id-ID')
  const ms = (p.models || []).map(m => m.price).filter(v => v != null)
  if (!ms.length) return '-'
  const mn = Math.min(...ms)
  const mx = Math.max(...ms)
  return mn === mx ? 'Rp' + mn.toLocaleString('id-ID') : 'Rp' + mn.toLocaleString('id-ID') + ' - Rp' + mx.toLocaleString('id-ID')
})
const soldText = computed(() => (props.product.sold || 0).toLocaleString('id-ID'))
const out = computed(() => (props.product.stock || 0) <= 0)
</script>

<template>
  <article class="thin" @click="emit('select', props.product)">
    <div class="ph">
      <img v-if="props.product.image" :src="props.product.image" :alt="props.product.name" />
      <img v-else :src="'https://picsum.photos/seed/shoper-' + props.product.id + '/400/400'" alt="" loading="lazy" />
      <span v-if="out" class="badge">Habis</span>
    </div>
    <div class="body">
      <h3 class="nm">{{ props.product.name }}</h3>
      <p class="pr">{{ priceText }}</p>
      <div class="mt">
        <span class="rt">{{ (props.product.rating || 0).toFixed(1) }}</span>
        <span class="sd">{{ soldText }} terjual</span>
      </div>
      <div class="act">
      <div class="fab-row">
        <button class="fab love" @click.stop="emit('love', props.product)">&#9825;<span class="n" v-if="loveCount > 0">{{ loveCount }}</span></button>
        <button class="fab share" @click.stop="emit('share', props.product)">&#8618;<span class="n" v-if="shareCount > 0">{{ shareCount }}</span></button>
      </div>
      </div>
    </div>
  </article>
</template>

<style scoped>
.thin { background: #fff; border: 1px solid #eee; border-radius: 12px; overflow: hidden; cursor: pointer; transition: transform .15s, box-shadow .15s; }
.thin:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(0,0,0,.08); }
.ph { position: relative; aspect-ratio: 1 / 1; background: linear-gradient(135deg, #f3f3f3, #e9e9e9); display: flex; align-items: center; justify-content: center; }
.ph img { width: 100%; height: 100%; object-fit: cover; }
.ph-t { font-size: 12px; color: #aaa; }
.badge { position: absolute; top: 6px; left: 6px; background: rgba(0,0,0,.6); color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 6px; }
.body { padding: 8px; }
.nm { font-size: 13px; font-weight: 600; line-height: 1.3; margin: 0 0 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.pr { font-size: 15px; color: #FF7A45; font-weight: 800; margin: 0; }
.mt { display: flex; align-items: center; justify-content: space-between; margin-top: 4px; }
.rt { font-size: 11px; color: #f5a623; font-weight: 700; }
.sd { font-size: 11px; color: #888; }
.act { display: flex; gap: 8px; margin-top: 6px; }
.img-wrap { position: relative; aspect-ratio: 1; overflow: hidden; border-radius: 8px; margin-bottom: 8px; }
.img-wrap img { width: 100%; height: 100%; object-fit: cover; }
.fab-row { position: absolute; top: 8px; right: 8px; display: flex; gap: 6px; z-index: 2; }
.fab { width: 34px; height: 34px; border-radius: 50%; border: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.88); backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px);
  box-shadow: 0 2px 8px rgba(0,0,0,.14); display: grid; place-items: center;
  font-size: 15px; color: #1a1a1a; -webkit-text-stroke: .9px currentColor; font-weight: 900; cursor: pointer; transition: transform .15s; }
.fab:active { transform: scale(.92); }
.fab .n { position: absolute; bottom: -6px; right: -4px; background: #10B981; color: #fff;
  font-size: 9px; font-weight: 800; padding: 1px 5px; border-radius: 999px; -webkit-text-stroke: 0; }
</style>

