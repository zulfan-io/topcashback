<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
import { BRANDS, LIVE } from '~/config/brands'
import { useTrack } from '~/composables/useTrack'
const { track } = useTrack()
const router=useRouter(); const counts=ref({}); const ready=ref(false)
const sheet=ref(null); const wanted=ref([]); const toast=ref('')
let tT=null
onMounted(async()=>{
  try{const w=localStorage.getItem('brand_want');if(w)wanted.value=JSON.parse(w)||[]}catch(_){}
  const {data}=await supabase.from('shoper_offers').select('network').eq('active',true).limit(3000)
  const m={}; for(const r of (data||[])) m[r.network]=(m[r.network]||0)+1
  counts.value=m; ready.value=true
})
function go(b){track('click',{network:b.key,path:b.to});router.push(b.to)}
function tap(b){ if(b.live){go(b)} else {sheet.value=b;track('want_open',{network:b.key})} }
function notify(){
  const b=sheet.value; if(!b)return
  if(!wanted.value.includes(b.key)){wanted.value=[...wanted.value,b.key];try{localStorage.setItem('brand_want',JSON.stringify(wanted.value))}catch(_){}}
  track('want',{network:b.key})
  toast.value='Dicatat. '+b.name+' dibuka duluan begitu katalognya siap.'
  sheet.value=null; clearTimeout(tT); tT=setTimeout(()=>toast.value='',3600)
}
</script>
<template>
<section class="br">
  <header class="bh">
    <div><h3>Cashback resmi</h3><small>Pilih merek → masuk tokonya. Angka = maksimum campaign, bisa beda per kategori.</small></div>
    <span class="btrust"><Icon name="check" :size="12"/>terverifikasi</span>
  </header>

  <div class="bgrid">
    <button v-for="b in LIVE" :key="b.key" class="bt" @click="go(b)">
      <span class="blogo"><img :src="b.logo" :alt="b.name" loading="lazy" decoding="async"/></span>
      <span class="bname">{{b.name}}</span>
      <span class="bsub">{{b.sub}}</span>
      <span class="brate">s/d {{b.rate}}%</span>
      <span class="bcount"><template v-if="ready">{{counts[b.key]||0}} item</template><template v-else>memuat…</template></span>
      <span class="bgo"><Icon name="chevron" :size="15"/></span>
    </button>
  </div>

  <div class="bwall">
    <div class="bwh"><span class="bwl">Tembok kepercayaan · {{BRANDS.length}} mitra resmi</span><span class="bwn2">logo asli · rate campaign</span></div>
    <div class="bwr">
      <button v-for="b in BRANDS" :key="'w'+b.key" class="bw" :class="{live:b.live,on:wanted.includes(b.key)}" @click="tap(b)">
        <span class="bwi"><img :src="b.logo" :alt="b.name" loading="lazy" decoding="async"/></span>
        <span class="bwn">{{b.name}}</span>
        <span class="bwp">{{b.rate?('s/d '+b.rate+'%'):'rate menyusul'}}</span>
        <span class="bws">
          <template v-if="b.live"><Icon name="chevron" :size="9"/>{{counts[b.key]||0}} item</template>
          <template v-else><Icon :name="wanted.includes(b.key)?'check':'bell'" :size="9"/>{{wanted.includes(b.key)?'dicatat':'kabari'}}</template>
        </span>
      </button>
    </div>
  </div>

  <transition name="bs">
    <div v-if="sheet" class="bov" @click.self="sheet=null">
      <div class="bsheet">
        <div class="bgrab"><i/></div>
        <button class="bx" @click="sheet=null" aria-label="Tutup"><Icon name="x" :size="16"/></button>
        <span class="bsl"><img :src="sheet.logo" :alt="sheet.name"/></span>
        <h4>{{sheet.name}}</h4>
        <p>Campaign sudah disetujui{{sheet.rate?(' · cashback maksimum '+sheet.rate+'%'):''}}. Katalog produknya sedang kami tarik dari feed resmi mitra, jadi belum ada yang bisa dipesan di sini.</p>
        <button class="bsb" @click="notify"><Icon name="bell" :size="15"/>Kabari saya kalau dibuka</button>
        <button class="bsg" @click="sheet=null;router.push('/mall')">Jelajah yang sudah hidup dulu</button>
        <small class="bsn">NOL tombol mati: merek tanpa katalog NOL bisa dipesan, dan NOL angka karangan.</small>
      </div>
    </div>
  </transition>
  <transition name="bf"><div v-if="toast" class="btoast"><Icon name="check" :size="14"/>{{toast}}</div></transition>
</section>
</template>
<style scoped>
.br{padding:14px 14px 4px;max-width:1280px;margin:0 auto}
.bh{display:flex;justify-content:space-between;align-items:flex-start;gap:10px;margin-bottom:11px}
.bh h3{margin:0;font-size:16px;font-weight:900;color:#1a1a1a;letter-spacing:-.2px}
.bh small{display:block;font-size:10.5px;color:#7b7268;margin-top:3px;line-height:1.4;max-width:260px}
.btrust{flex:0 0 auto;display:flex;gap:4px;align-items:center;font-size:9.5px;font-weight:900;color:#0a6b5e;background:#D8F5DC;padding:4px 9px;border-radius:999px}
.bgrid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}
@media(min-width:720px){.bgrid{grid-template-columns:repeat(4,1fr)}}
.bt{position:relative;display:flex;flex-direction:column;align-items:flex-start;border:0;border-radius:18px;padding:13px 12px 12px;cursor:pointer;text-align:left;color:#fff;
 background:linear-gradient(155deg,#FF8A4D,#FF4D3D 70%,#E63946);box-shadow:0 8px 20px rgba(255,77,61,.24);transition:transform .16s cubic-bezier(.22,1,.36,1);overflow:hidden}
.bt::after{content:'';position:absolute;right:-26px;top:-26px;width:88px;height:88px;border-radius:50%;background:rgba(255,255,255,.12)}
.bt:active{transform:scale(.965)}
.blogo{position:relative;width:46px;height:46px;display:grid;place-items:center;border-radius:14px;background:#fff;margin-bottom:7px;box-shadow:0 3px 10px rgba(0,0,0,.16)}
.blogo img{width:32px;height:32px;object-fit:contain;display:block}
.bname{position:relative;font-size:15px;font-weight:900;letter-spacing:-.2px}
.bsub{position:relative;font-size:9.5px;opacity:.9;line-height:1.3}
.brate{position:relative;margin-top:8px;font-size:12.5px;font-weight:900;color:#B34700;background:#FFE0C2;padding:3px 10px;border-radius:999px}
.bcount{position:relative;font-size:9px;font-weight:700;opacity:.92;margin-top:5px}
.bgo{position:absolute;right:10px;bottom:10px;opacity:.85}
.bwall{margin-top:12px;border:1px solid #eadfd0;background:#fff;border-radius:16px;padding:11px 12px}
.bwh{display:flex;justify-content:space-between;align-items:baseline;gap:8px;margin-bottom:9px}
.bwl{font-size:9.5px;font-weight:900;letter-spacing:.4px;color:#9a8f82;text-transform:uppercase}
.bwn2{font-size:8.5px;color:#b5a99c;font-weight:700}
.bwr{display:grid;grid-template-columns:repeat(4,1fr);gap:7px}
@media(min-width:560px){.bwr{grid-template-columns:repeat(6,1fr)}}
@media(min-width:960px){.bwr{grid-template-columns:repeat(12,1fr)}}
.bw{display:flex;flex-direction:column;align-items:center;gap:3px;border:1px solid #f0e5d6;border-radius:12px;background:#FFFBF6;padding:8px 4px;cursor:pointer;transition:transform .14s,border-color .14s,background .14s}
.bw:active{transform:scale(.93)}
.bw.live{border-color:#ffd3b8;background:#FFF3E9}
.bw.on{border-color:#00B8A9;background:#F0FBF9}
.bwi{width:30px;height:30px;display:grid;place-items:center;border-radius:9px;background:#fff;border:1px solid #f3e9dc}
.bwi img{width:22px;height:22px;object-fit:contain;display:block}
.bwn{font-size:8.5px;font-weight:800;color:#1a1a1a;text-align:center;line-height:1.15;max-width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.bwp{font-size:7.5px;font-weight:900;color:#B34700;background:#FFE0C2;padding:1px 5px;border-radius:99px;white-space:nowrap}
.bws{display:flex;gap:2px;align-items:center;font-size:7.5px;font-weight:800;color:#9a8f82}
.bw.live .bws{color:#B34700}
.bw.on .bws{color:#0a6b5e}
.bov{position:fixed;inset:0;z-index:80;background:rgba(20,12,6,.55);backdrop-filter:blur(5px);display:flex;align-items:flex-end;justify-content:center}
.bsheet{position:relative;width:100%;max-width:520px;background:#FFF7EC;border-radius:22px 22px 0 0;padding:0 18px calc(18px + env(safe-area-inset-bottom));box-shadow:0 -14px 40px rgba(0,0,0,.35);text-align:center}
.bgrab{padding:10px 0 6px;display:grid;place-items:center}
.bgrab i{width:42px;height:4px;border-radius:99px;background:#e2cdb6}
.bx{position:absolute;top:12px;right:12px;width:30px;height:30px;display:grid;place-items:center;border:0;border-radius:10px;background:#fff;color:#7b7268;cursor:pointer}
.bsl{display:inline-grid;place-items:center;width:56px;height:56px;border-radius:17px;background:#fff;border:1px solid #eadfd0;margin-top:4px}
.bsl img{width:34px;height:34px;object-fit:contain}
.bsheet h4{margin:10px 0 6px;font-size:18px;font-weight:900;color:#1a1a1a}
.bsheet p{margin:0 0 14px;font-size:12px;line-height:1.6;color:#7b7268}
.bsb{display:flex;gap:8px;align-items:center;justify-content:center;width:100%;border:0;border-radius:13px;padding:13px;font-size:13px;font-weight:900;color:#fff;background:linear-gradient(135deg,#FF7A45,#FF4D3D);cursor:pointer}
.bsg{width:100%;margin-top:8px;border:1px solid #eadfd0;border-radius:13px;padding:11px;font-size:12px;font-weight:800;color:#B34700;background:#fff;cursor:pointer}
.bsn{display:block;margin-top:11px;font-size:10px;color:#9a8f82;line-height:1.4}
.btoast{position:fixed;left:14px;right:14px;bottom:calc(78px + env(safe-area-inset-bottom));z-index:90;display:flex;gap:8px;align-items:center;background:#0d3b46;color:#EAF7F7;border-radius:13px;padding:12px 14px;font-size:12px;font-weight:700;box-shadow:0 12px 30px rgba(0,0,0,.4)}
.bs-enter-active,.bs-leave-active{transition:opacity .22s}
.bs-enter-active .bsheet,.bs-leave-active .bsheet{transition:transform .26s cubic-bezier(.22,1,.36,1)}
.bs-enter-from,.bs-leave-to{opacity:0}
.bs-enter-from .bsheet,.bs-leave-to .bsheet{transform:translateY(100%)}
.bf-enter-active,.bf-leave-active{transition:opacity .2s,transform .2s}
.bf-enter-from,.bf-leave-to{opacity:0;transform:translateY(8px)}
</style>
