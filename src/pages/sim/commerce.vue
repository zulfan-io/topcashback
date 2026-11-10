<script setup lang="ts">
import SimWalletChip from '~/components/sim/SimWalletChip.vue'
import { useSimCommerce } from '~/stores/simCommerce'
const { feed, cart, vouchers, cartTotal, cartCount, addToCart, removeFromCart, clearCart, checkout } = useSimCommerce()
</script>

<template>
  <SimWalletChip />
  <div class="commerce-shell">
    <h2>Feeds Sim</h2>
    <div class="commerce-grid">
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
        <button class="stage-badge" @click="checkout()" aria-label="Checkout">Checkout</button>
        <button class="stage-badge" @click="clearCart()" aria-label="Kosongkan">Kosongkan</button>
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
