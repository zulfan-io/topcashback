<script setup lang="ts">
import { ref } from 'vue'
import SimWalletChip from '~/components/sim/SimWalletChip.vue'
import { useSimCommerce } from '~/stores/simCommerce'
import { useSimWallet } from '~/stores/simWallet'
import { useSimMatch } from '~/stores/simMatch'

const { feed, cart, vouchers, cartTotal, cartCount, addToCart, removeFromCart, clearCart } = useSimCommerce()
const { balance, spend } = useSimWallet()
const { matchQueue } = useSimMatch()

const flash = ref('')

function doCheckout() {
  if (cartCount.value === 0) { flash.value = 'Keranjang kosong'; return }
  if (spend(cartTotal.value, 'checkout commerce')) {
    clearCart()
    flash.value = 'Pembayaran berhasil (saldo dipotong)'
  } else {
    flash.value = 'Saldo kurang — top-up dulu'
  }
}
</script>

<template>
  <SimWalletChip />
  <div class="commerce-shell">
    <h2>Feeds Sim</h2>
    <div class="wallet-chip">Saldo Dompet Rp {{ balance }}</div>
    <div v-if="flash" class="swipe-ghost">{{ flash }}</div>

    <div class="commerce-scroll">
      <div v-for="p in feed" :key="p.id" class="sim-card spr-pop">
        <span class="presence-dot pulse"></span>
        <h3>{{ p.name }}</h3>
        <p>{{ p.cat }} · {{ p.aff }}</p>
        <div class="wallet-chip">Rp {{ p.price }}</div>
        <button class="stage-badge" @click="addToCart(p)" aria-label="Tambah">+ Keranjang</button>
      </div>
    </div>

    <div class="commerce-cart">
      <div class="wallet-chip">Keranjang {{ cartCount }} · Rp {{ cartTotal }}</div>
      <ul v-if="cart.length" class="tx-list">
        <li v-for="i in cart" :key="i.id" class="swipe-ghost">
          {{ i.name }} x{{ i.qty }}
          <button class="stage-badge" @click="removeFromCart(i.id)" aria-label="Hapus">Hapus</button>
        </li>
      </ul>
      <div v-else class="swipe-ghost">Keranjang kosong.</div>
      <div class="social-rail">
        <button class="stage-badge" @click="doCheckout()" aria-label="Bayar">Bayar</button>
        <button class="stage-badge" @click="clearCart()" aria-label="Kosongkan">Kosongkan</button>
      </div>
    </div>

    <div v-if="matchQueue.length > 0" class="commerce-coupon">
      <h3>Coupon Pair (match celebration)</h3>
      <div class="social-rail">
        <button class="stage-badge" aria-label="Coupon pair 1">DISKON10</button>
        <button class="stage-badge" aria-label="Coupon pair 2">CASHBACK5</button>
      </div>
    </div>

    <div class="commerce-voucher">
      <h3>Voucher Stub</h3>
      <div class="social-rail">
        <button v-for="v in vouchers" :key="v" class="stage-badge" aria-label="Voucher">{{ v }}</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.commerce-scroll{display:flex;gap:12px;overflow-x:auto;scroll-snap-type:x mandatory;-webkit-overflow-scrolling:touch;padding:4px 2px 12px;scrollbar-width:thin}
.commerce-scroll::-webkit-scrollbar{height:6px}
.commerce-scroll::-webkit-scrollbar-thumb{background:rgba(0,184,169,.4);border-radius:9999px}
.commerce-scroll>.sim-card{flex:0 0 78%;scroll-snap-align:center;min-width:0}
@media (max-width:480px){.commerce-scroll>.sim-card{flex:0 0 82%}}
</style>
