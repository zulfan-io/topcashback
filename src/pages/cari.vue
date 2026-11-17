<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const router=useRouter(); const q=ref(''); const inp=ref(null); const res=ref([]); const busy=ref(false); const warn=ref(''); const recent=ref([])
const BAD=/\b(porn|porno|sex|seks|bokep|jav|nude|telanjang|bugil|kill|bunuh|bom|narkoba|judi|slot|togel)\b/i
onMounted(async()=>{ try{recent.value=JSON.parse(localStorage.getItem('cari_recent')||'[]')}catch(_){}; await nextTick(); inp.value&&inp.value.focus() })
async function run(){
  warn.value=''; const t=q.value.trim()
  if(!t){res.value=[];return}
  if(BAD.test(t)){ warn.value='Kata ini melanggar ketentuan. Info & cashback di sini berharga; penyalahgunaan dicatat dan akun bisa dibekukan / dilaporkan ke pihak berwajib.';
    try{await supabase.from('app_events').insert({kind:'abuse',anon_id:'q',meta:{q:t}})}catch(_){}
    res.value=[]; return }
  busy.value=true
  const {data}=await supabase.from('shoper_offers').select('*').eq('active',true).ilike('title','%'+t+'%').limit(40)
  res.value=data||[]; busy.value=false
  recent.value=[t,...recent.value.filter(x=>x!==t)].slice(0,6); try{localStorage.setItem('cari_recent',JSON.stringify(recent.value))}catch(_){}
}
function open(r){window.open(r.url,'_blank','noopener')}
function rp(n){return 'Rp'+Number(n||0).toLocaleString('id-ID')}
</script>
<template>
<main class="cr">
  <header class="bar"><button class="ib" @click="router.push('/')" aria-label="Kembali"><Icon name="back" :size="18"/></button>
    <label class="sb"><Icon name="search" :size="15"/><input ref="inp" v-model="q" @input="run" type="search" placeholder="Cari top up, viu, game, brand, toko…" aria-label="Cari"/></label>
  </header>
  <div v-if="warn" class="warn"><Icon name="x" :size="16"/><p>{{warn}}</p></div>
  <div v-if="!q&&!warn" class="rec"><span>Terakhir dicari</span><div class="chips"><button v-for="r in recent" :key="r" @click="q=r;run()">{{r}}</button></div></div>
  <div v-if="busy" class="msg">Mencari…</div>
  <div v-else-if="q&&!warn&&!res.length" class="msg">NOL hasil buat “{{q}}”. Coba kata lain.</div>
  <div class="list">
    <button v-for="r in res" :key="r.id" class="row" @click="open(r)">
      <img :src="r.image_url" :alt="r.title" loading="lazy" decoding="async"/>
      <span class="tx"><b>{{r.title}}</b><small>{{r.network}}<template v-if="r.price"> · {{rp(r.price)}}</template></small></span>
      <Icon name="chevron" :size="16"/>
    </button>
  </div>
</main>
</template>
<style scoped>
.cr{min-height:100vh;background:#FFF7EC;padding-bottom:90px;font-family:system-ui,sans-serif}
.bar{position:sticky;top:0;z-index:20;display:flex;gap:9px;align-items:center;padding:calc(9px + env(safe-area-inset-top)) 12px 9px;background:rgba(255,247,236,.94);backdrop-filter:blur(12px);border-bottom:1px solid #eadfd0}
.ib{width:36px;height:36px;display:grid;place-items:center;border:1px solid #eadfd0;border-radius:11px;background:#fff;cursor:pointer}
.sb{flex:1;display:flex;gap:8px;align-items:center;background:#fff;border:1px solid #FF7A45;border-radius:12px;padding:9px 12px;color:#9a8f82}
.sb input{flex:1;border:0;outline:none;background:none;font-size:13px;color:#1a1a1a}
.warn{display:flex;gap:9px;margin:12px 14px;padding:12px;border-radius:14px;background:#FDE8E8;border:1px solid #E63946;color:#8C1D26}
.warn p{margin:0;font-size:12px;line-height:1.5;font-weight:600}
.rec{padding:12px 14px}.rec span{font-size:10px;font-weight:800;color:#9a8f82}
.chips{display:flex;gap:7px;flex-wrap:wrap;margin-top:8px}
.chips button{border:1px solid #eadfd0;background:#fff;border-radius:99px;padding:6px 12px;font-size:11px;font-weight:700;cursor:pointer}
.msg{padding:30px 20px;text-align:center;color:#9a8f82;font-size:12px}
.list{padding:0 14px;display:flex;flex-direction:column;gap:8px}
.row{display:flex;gap:10px;align-items:center;border:1px solid #eadfd0;background:#fff;border-radius:14px;padding:8px;cursor:pointer;text-align:left}
.row img{width:48px;height:48px;object-fit:cover;border-radius:10px}
.tx{flex:1;min-width:0}.tx b{display:block;font-size:12px;color:#1a1a1a;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.tx small{font-size:10px;color:#9a8f82}
</style>
