<template>
  <div class="promo-card" :class="promo.urgency_level || 'low'">
    <img :src="promo.image_url" :alt="promo.title" loading="lazy" />
    <h3>{{ promo.title }}</h3>
    <p v-if="promo.discount_text" class="discount">{{ promo.discount_text }}</p>

    <span v-if="promo.urgency_level === 'critical'" class="fomo-badge critical">
      🔥 BERAKHIR {{ countdown }}
    </span>
    <span v-else-if="promo.urgency_level === 'high'" class="fomo-badge high">
      ⚡ SISA {{ hoursLeft }} JAM
    </span>

    <div v-if="promo.stock_remaining && promo.stock_remaining < 10" class="stock-warning">
      🚨 Hanya tersisa {{ promo.stock_remaining }} voucher!
    </div>

    <button class="cta-button" :class="promo.urgency_level" @click="claim">
      {{ promo.cta_text || 'Klaim Sekarang' }}
      <span v-if="promo.urgency_level === 'critical'" class="pulse">→</span>
    </button>

    <div v-if="promo.claimed_count > 0" class="social-proof">
      ✓ {{ promo.claimed_count }} orang sudah klaim hari ini
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  promo: { type: Object, required: true }
})

const emit = defineEmits(['claim'])

const countdown = computed(() => {
  if (!props.promo.ends_date) return ''
  const diff = new Date(props.promo.ends_date) - Date.now()
  if (diff <= 0) return '00:00:00'
  const h = Math.floor(diff / 3600000)
  const m = Math.floor((diff % 3600000) / 60000)
  const s = Math.floor((diff % 60000) / 1000)
  return `${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`
})

const hoursLeft = computed(() => {
  if (!props.promo.ends_date) return 0
  return Math.max(0, Math.ceil((new Date(props.promo.ends_date) - Date.now()) / 3600000))
})

function claim() {
  emit('claim', props.promo)
  if (navigator.share) {
    navigator.share({ title: props.promo.title, url: props.promo.url }).catch(() => {})
  } else {
    window.open(props.promo.url, '_blank', 'noopener')
  }
}
</script>

<style scoped>
.promo-card {
  background: #fff;
  border-radius: 12px;
  padding: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  position: relative;
  overflow: hidden;
}
.promo-card.critical { border: 2px solid #ff4444; animation: pulse-border 2s infinite; }
.promo-card.high    { border: 2px solid #ff8800; }
.promo-card img { width: 100%; height: 140px; object-fit: cover; border-radius: 8px; }
.promo-card h3 { font-size: 14px; margin: 8px 0 4px; line-height: 1.3;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.discount { color: #e53935; font-weight: 700; font-size: 13px; margin: 0 0 8px; }
.fomo-badge { display: inline-block; padding: 3px 8px; border-radius: 4px;
  font-size: 11px; font-weight: 700; color: #fff; margin-bottom: 6px; }
.fomo-badge.critical { background: linear-gradient(90deg,#ff4444,#ff8800); animation: shake 0.5s infinite; }
.fomo-badge.high     { background: #ff8800; }
.stock-warning { color: #e53935; font-size: 11px; font-weight: 600; margin-bottom: 6px; }
.cta-button { width: 100%; padding: 10px; border: none; border-radius: 8px;
  background: #FF7A1A; color: #fff; font-weight: 700; font-size: 14px; cursor: pointer; }
.cta-button.critical { background: #ff4444; transform: scale(1.02); }
.cta-button:hover { opacity: 0.9; }
.social-proof { font-size: 11px; color: #666; margin-top: 6px; }
@keyframes pulse-border { 0%,100%{border-color:#ff4444} 50%{border-color:#ff8800} }
@keyframes shake { 0%,100%{transform:translateX(0)} 25%{transform:translateX(-2px)} 75%{transform:translateX(2px)} }
</style>
