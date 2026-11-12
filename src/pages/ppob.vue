<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { usePpob } from '~/stores/ppob'
const { products, order, busy, err, load, create, poll } = usePpob()
const code = ref(''); const target = ref(''); let timer = null
onMounted(() => { load(); timer = setInterval(poll, 4000) })
onUnmounted(() => clearInterval(timer))
</script>
<template>
  <div class="pp">
    <h1>PPOB <span>transfer-duluan</span></h1>
    <p class="sub">Bayar dulu → top-up instant. NOL ongkir/retur/float.</p>
    <div v-if="err" class="msg err">{{ err }}</div>
    <div class="grid">
      <button v-for="p in products" :key="p.code" class="tile" :class="{ on: code === p.code }" @click="code = p.code">
        <b>{{ p.name }}</b><span>Rp{{ p.price.toLocaleString('id') }}</span>
      </button>
    </div>
    <input v-model="target" placeholder="No HP / No Meter / No Pelanggan" inputmode="numeric" />
    <button class="go" :disabled="busy || !code || !target" @click="create(code, target)">{{ busy ? 'Memproses…' : 'Buat Order & Bayar' }}</button>
    <div v-if="order" class="ord">
      <p>Status: <b>{{ order.status }}</b></p>
      <p v-if="order.pay_url && order.status === 'pending'">Bayar: <a :href="order.pay_url" target="_blank" rel="noopener">buka pembayaran</a> (Rp{{ order.amount }})</p>
      <p v-if="order.status === 'fulfilled'" class="ok">Top-up sukses ✔</p>
    </div>
  </div>
</template>
<style scoped>
.pp{max-width:640px;margin:0 auto;padding:20px 16px 80px;font-family:system-ui,sans-serif;color:#1a1a1a}
h1{font-size:22px;font-weight:800;color:#FF7A45}h1 span{color:#00B8A9;font-size:13px}
.sub{font-size:12px;color:#777}.msg{padding:8px 12px;border-radius:10px;font-size:13px;margin:8px 0}.err{background:#FDECEA;color:#B3261E}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:8px;margin:12px 0}
.tile{display:flex;flex-direction:column;gap:2px;padding:12px;border:1px solid #eee;border-radius:12px;background:#fff;cursor:pointer;text-align:left}
.tile.on{border-color:#FF7A45;background:#FFF3E9}.tile span{color:#FF7A45;font-weight:700}
input{width:100%;box-sizing:border-box;padding:12px;border:1px solid #ddd;border-radius:10px;font-size:15px;margin:8px 0}
.go{width:100%;padding:13px;border:0;border-radius:12px;background:#FF7A45;color:#fff;font-weight:700;font-size:15px;cursor:pointer}.go:disabled{opacity:.5}
.ord{margin-top:14px;padding:12px;border:1px solid #eee;border-radius:12px;background:#fff}.ok{color:#1B7A2E;font-weight:700}
</style>
