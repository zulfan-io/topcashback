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
function tap(b){const to=b.brands||('/shop/'+b.key);track('click',{network:b.key,path:to});router.push(to)}
function notify(){
  const b=sheet.value; if(!b)return
  if(!wanted.value.includes(b.key)){wanted.value=[...wanted.value,b.key];try{localStorage.setItem('brand_want',JSON.stringify(wanted.value))}catch(_){}}
  track('want',{network:b.key}); toast.value='Dicatat. '+b.name+' dibuka duluan begitu katalognya siap.'
  sheet.value=null; clearTimeout(tT); tT=setTimeout(()=>toast.value='',3600)
}
</script>
<template>
<section class="br">
  <div class="brc">
    <header class="bh">
      <div><h3>Cashback resmi</h3></div>
      <span class="btrust"><Icon name="check" :size="12"/>terverifikasi</span>
    </header>
    <div class="doors">
      <button v-for="b in LIVE" :key="b.key" class="door" @click="go(b)">
        <span class="dlogo"><img :src="b.logo" :alt="b.name" loading="lazy" decoding="async"/></span>
        <span class="dtxt"><b>{{b.name}}</b><small><template v-if="ready">{{counts[b.key]||0}} item resmi</template><template v-else>memuat…</template></small></span>
        <Icon name="chevron" :size="15"/>
      </button>
    </div>
    <div class="bdiv"></div>
    <div class="bwr">
      <button v-for="b in BRANDS" :key="'w'+b.key" class="bw" :class="{live:b.live,on:wanted.includes(b.key)}" @click="tap(b)">
        <span class="bwi"><img :src="b.logo" :alt="b.name" loading="lazy" decoding="async"/></span>
        <span class="bwn">{{b.name}}</span>
        <span class="bwp">{{b.live?'katalog resmi':'segera'}}</span>
        <span class="bws">
          <template v-if="b.live"><Icon name="chevron" :size="9"/></template>
          <template v-else><Icon :name="wanted.includes(b.key)?'check':'bell'" :size="9"/></template>
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
        <p>Campaign sudah disetujui{{sheet.rate?(' · cashback maksimum '+sheet.rate+'%'):''}}. Katalog produknya sedang kami tarik dari feed resmi mitra.</p>
        <button class="bsb" @click="notify"><Icon name="bell" :size="15"/>Kabari saya kalau dibuka</button>
        <button class="bsg" @click="sheet=null;router.push('/mall')">Jelajah yang sudah hidup dulu</button>
      </div>
    </div>
  </transition>
  <transition name="bf"><div v-if="toast" class="btoast"><Icon name="check" :size="14"/>{{toast}}</div></transition>
</section>
</template>
<style scoped>
.br{padding:0;max-width:none;margin:0;width:100vw;margin-left:calc(50% - 50vw)}
.brc{border:0;border-radius:0;border-top:3px solid;border-bottom:3px solid;border-color:#FF4D3D;background:linear-gradient(180deg,#ffffff,#FFF3E9 70%,#FFE9D6);padding:14px 14px 16px;box-shadow:0 12px 34px rgba(255,77,61,.14)}
.bh{display:flex;justify-content:space-between;align-items:flex-start;gap:10px;margin-bottom:10px}
.bh h3{margin:0;font-size:17px;letter-spacing:-.3px;font-weight:900;color:#1a1a1a;letter-spacing:-.2px}
.bh small{display:block;font-size:9.5px;color:#9a8f82;margin-top:2px;font-weight:700}
.btrust{box-shadow:0 4px 12px rgba(0,184,154,.25);flex:0 0 auto;display:flex;gap:4px;align-items:center;font-size:9px;font-weight:900;color:#0a6b5e;background:#D8F5DC;padding:4px 8px;border-radius:999px}
.doors{display:flex;gap:8px;overflow-x:auto;padding-bottom:6px;scrollbar-width:thin;scrollbar-color:#FF7A45 #f3e9dc}
.doors::-webkit-scrollbar{height:5px}
.doors::-webkit-scrollbar-track{background:#f3e9dc;border-radius:99px}
.doors::-webkit-scrollbar-thumb{background:linear-gradient(90deg,#FF7A45,#FF4D3D);border-radius:99px}
.door{flex:0 0 auto;display:flex;gap:9px;align-items:center;border:0;border-radius:14px;padding:8px 13px 8px 8px;cursor:pointer;text-align:left;color:#fff;
 background:linear-gradient(150deg,#FF8A4D,#FF4D3D 75%,#E63946);box-shadow:0 6px 16px rgba(255,77,61,.22);transition:transform .15s}
.door:active{transform:scale(.95)}
.dlogo{width:34px;height:34px;flex:0 0 auto;display:grid;place-items:center;border-radius:10px;background:#fff}
.dlogo img{width:24px;height:24px;object-fit:contain}
.dtxt b{display:block;font-size:13px;font-weight:900;letter-spacing:-.2px}
.dtxt small{display:block;font-size:9px;opacity:.92;font-weight:700}
.door :deep(svg){opacity:.85}
.bdiv{height:1px;background:#f0e5d6;margin:4px 0 9px}
.bwr{display:grid;grid-template-columns:repeat(4,1fr);gap:7px}
@media(min-width:560px){.bwr{grid-template-columns:repeat(6,1fr)}}
@media(min-width:960px){.bwr{grid-template-columns:repeat(12,1fr)}}
.bw{display:flex;flex-direction:column;align-items:center;gap:3px;border:1px solid #f0e5d6;border-radius:12px;background:#FFFBF6;padding:8px 4px;cursor:pointer;transition:transform .14s,border-color .14s}
.bw:active{transform:scale(.93)}
.bw.live{border-color:#ffd3b8;background:#FFF3E9}
.bw.on{border-color:#00B8A9;background:#F0FBF9}
.bwi{width:30px;height:30px;display:grid;place-items:center;border-radius:9px;background:#fff;border:1px solid #f3e9dc}
.bwi img{width:22px;height:22px;object-fit:contain}
.bwn{font-size:8.5px;font-weight:800;color:#1a1a1a;max-width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.bwp{font-size:7.5px;font-weight:900;color:#B34700;background:#FFE0C2;padding:1px 5px;border-radius:99px;white-space:nowrap}
.bws{display:flex;align-items:center;color:#9a8f82}
.bw.live .bws{color:#B34700}
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
.btoast{position:fixed;left:14px;right:14px;bottom:calc(78px + env(safe-area-inset-bottom));z-index:90;display:flex;gap:8px;align-items:center;background:#0d3b46;color:#EAF7F7;border-radius:13px;padding:12px 14px;font-size:12px;font-weight:700;box-shadow:0 12px 30px rgba(0,0,0,.4)}
.bs-enter-active,.bs-leave-active{transition:opacity .22s}
.bs-enter-active .bsheet,.bs-leave-active .bsheet{transition:transform .26s cubic-bezier(.22,1,.36,1)}
.bs-enter-from,.bs-leave-to{opacity:0}
.bs-enter-from .bsheet,.bs-leave-to .bsheet{transform:translateY(100%)}
.bf-enter-active,.bf-leave-active{transition:opacity .2s,transform .2s}
.bf-enter-from,.bf-leave-to{opacity:0;transform:translateY(8px)}
</style>
