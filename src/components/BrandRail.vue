<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
import { useTrack } from '~/composables/useTrack'
const { track } = useTrack()
const router=useRouter(); const counts=ref({}); const sheet=ref(false); const ready=ref(false)
const LIVE=[
 {k:'shopee',name:'Shopee',to:'/mall',rate:'8,82%',logo:'https://cdn.simpleicons.org/shopee/ffffff',mono:true,sub:'Marketplace harian'},
 {k:'traveloka',name:'Traveloka',to:'/travel',rate:'12,61%',logo:'https://logo.clearbit.com/traveloka.com',mono:false,sub:'Atraksi & tiket wisata'},
 {k:'trip',name:'Trip.com',to:'/trip',rate:'3,51%',logo:'https://logo.clearbit.com/trip.com',mono:false,sub:'Hotel & penerbangan'},
 {k:'game',name:'UniPin',to:'/game',rate:'0,6%',logo:'https://logo.clearbit.com/unipin.com',mono:false,sub:'Game & voucher digital'}
]
const SOON=[
 {name:'Tokopedia',rate:'s/d 24%',logo:'https://cdn.simpleicons.org/tokopedia/22c55e'},
 {name:'Lazada',rate:'s/d 70%',logo:'https://logo.clearbit.com/lazada.co.id'},
 {name:'Blibli',rate:'s/d 70%',logo:'https://logo.clearbit.com/blibli.com'},
 {name:'TikTok Shop',rate:'s/d 25,23%',logo:'https://cdn.simpleicons.org/tiktok/111111'},
 {name:'tiket.com',rate:'belum affiliasi',logo:'https://logo.clearbit.com/tiket.com'}
]
onMounted(async()=>{
  const {data}=await supabase.from('shoper_offers').select('network').eq('active',true).limit(3000)
  const m={}; for(const r of (data||[])) m[r.network]=(m[r.network]||0)+1
  counts.value=m; ready.value=true
})
function go(t){track('click',{network:t.k,path:t.to});router.push(t.to)}
</script>
<template>
<section class="br">
  <header class="bh">
    <div><h3>Cashback resmi</h3><small>Pilih merek → masuk katalognya. Rate maksimum campaign.</small></div>
    <span class="btrust"><Icon name="check" :size="12"/>terverifikasi</span>
  </header>

  <div class="bgrid">
    <button v-for="b in LIVE" :key="b.k" class="bt" @click="go(b)">
      <span class="blogo" :class="{plain:b.mono}"><img :src="b.logo" :alt="b.name" loading="lazy" decoding="async"/></span>
      <span class="bname">{{b.name}}</span>
      <span class="bsub">{{b.sub}}</span>
      <span class="brate">{{b.rate}}</span>
      <span class="bcount"><template v-if="ready">{{counts[b.k]||0}} item</template><template v-else>memuat…</template></span>
      <span class="bgo"><Icon name="chevron" :size="15"/></span>
    </button>
  </div>

  <button class="bmore" @click="sheet=true">
    <Icon name="grid" :size="14"/>{{SOON.length}} merek lain sedang disiapkan<Icon name="chevron" :size="14"/>
  </button>

  <transition name="bs">
    <div v-if="sheet" class="bov" @click.self="sheet=false">
      <div class="bsheet">
        <div class="bgrab"><i/></div>
        <button class="bx" @click="sheet=false" aria-label="Tutup"><Icon name="x" :size="16"/></button>
        <h4>Merek berikutnya</h4>
        <p>Rate di bawah adalah angka resmi campaign. Katalognya belum dibuka — begitu dibuka, tombolnya langsung hidup di baris atas.</p>
        <ul class="blist">
          <li v-for="s in SOON" :key="s.name">
            <span class="bl"><img :src="s.logo" :alt="s.name" loading="lazy" decoding="async"/></span>
            <span class="bn">{{s.name}}</span>
            <span class="br2">{{s.rate}}</span>
          </li>
        </ul>
        <small class="bnote">NOL janji: merek tanpa katalog tidak bisa diklik sampai datanya masuk.</small>
      </div>
    </div>
  </transition>
</section>
</template>
<style scoped>
.br{padding:14px 14px 4px;max-width:1280px;margin:0 auto}
.bh{display:flex;justify-content:space-between;align-items:flex-start;gap:10px;margin-bottom:11px}
.bh h3{margin:0;font-size:16px;font-weight:900;color:#1a1a1a;letter-spacing:-.2px}
.bh small{display:block;font-size:10.5px;color:#7b7268;margin-top:3px;line-height:1.4}
.btrust{flex:0 0 auto;display:flex;gap:4px;align-items:center;font-size:9.5px;font-weight:900;color:#0a6b5e;background:#D8F5DC;padding:4px 9px;border-radius:999px}
.bgrid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}
@media(min-width:720px){.bgrid{grid-template-columns:repeat(4,1fr)}}
.bt{position:relative;display:flex;flex-direction:column;align-items:flex-start;gap:2px;border:0;border-radius:18px;padding:13px 12px 12px;cursor:pointer;text-align:left;color:#fff;
 background:linear-gradient(155deg,#FF8A4D,#FF4D3D 70%,#E63946);box-shadow:0 8px 20px rgba(255,77,61,.24);transition:transform .16s cubic-bezier(.22,1,.36,1),box-shadow .16s;overflow:hidden}
.bt::after{content:'';position:absolute;right:-26px;top:-26px;width:88px;height:88px;border-radius:50%;background:rgba(255,255,255,.12)}
.bt:active{transform:scale(.965);box-shadow:0 4px 12px rgba(255,77,61,.3)}
.blogo{position:relative;width:46px;height:46px;display:grid;place-items:center;border-radius:14px;background:#fff;margin-bottom:7px;box-shadow:0 3px 10px rgba(0,0,0,.16)}
.blogo.plain{background:rgba(255,255,255,.18);box-shadow:none}
.blogo img{width:30px;height:30px;object-fit:contain;display:block}
.blogo.plain img{width:32px;height:32px}
.bname{position:relative;font-size:15px;font-weight:900;letter-spacing:-.2px}
.bsub{position:relative;font-size:9.5px;opacity:.9;line-height:1.3}
.brate{position:relative;margin-top:8px;font-size:13px;font-weight:900;color:#B34700;background:#FFE0C2;padding:3px 10px;border-radius:999px}
.bcount{position:relative;font-size:9px;font-weight:700;opacity:.92;margin-top:5px}
.bgo{position:absolute;right:10px;bottom:10px;opacity:.85}
.bmore{display:flex;gap:7px;align-items:center;justify-content:center;width:100%;margin-top:10px;border:1px dashed #e2cdb6;background:#fff;color:#B34700;border-radius:13px;padding:10px;font-size:11.5px;font-weight:800;cursor:pointer}
.bmore:active{background:#FFF3E9}
.bov{position:fixed;inset:0;z-index:80;background:rgba(20,12,6,.55);backdrop-filter:blur(5px);display:flex;align-items:flex-end;justify-content:center}
.bsheet{position:relative;width:100%;max-width:520px;background:#FFF7EC;border-radius:22px 22px 0 0;padding:0 16px calc(18px + env(safe-area-inset-bottom));box-shadow:0 -14px 40px rgba(0,0,0,.35)}
.bgrab{padding:10px 0 6px;display:grid;place-items:center}
.bgrab i{width:42px;height:4px;border-radius:99px;background:#e2cdb6}
.bx{position:absolute;top:12px;right:12px;width:30px;height:30px;display:grid;place-items:center;border:0;border-radius:10px;background:#fff;color:#7b7268;cursor:pointer}
.bsheet h4{margin:2px 0 6px;font-size:16px;font-weight:900;color:#1a1a1a}
.bsheet p{margin:0 0 12px;font-size:11.5px;line-height:1.55;color:#7b7268}
.blist{list-style:none;margin:0;padding:0;display:flex;flex-direction:column;gap:8px}
.blist li{display:flex;gap:10px;align-items:center;background:#fff;border:1px solid #eadfd0;border-radius:13px;padding:9px 11px}
.bl{width:32px;height:32px;flex:0 0 auto;display:grid;place-items:center;border-radius:9px;background:#FFF3E9}
.bl img{width:22px;height:22px;object-fit:contain}
.bn{flex:1;font-size:12.5px;font-weight:800;color:#1a1a1a}
.br2{font-size:10.5px;font-weight:900;color:#B34700;background:#FFE0C2;padding:3px 8px;border-radius:99px}
.bnote{display:block;margin-top:11px;font-size:10px;color:#9a8f82;line-height:1.4}
.bs-enter-active,.bs-leave-active{transition:opacity .22s}
.bs-enter-active .bsheet,.bs-leave-active .bsheet{transition:transform .26s cubic-bezier(.22,1,.36,1)}
.bs-enter-from,.bs-leave-to{opacity:0}
.bs-enter-from .bsheet,.bs-leave-to .bsheet{transform:translateY(100%)}
</style>
