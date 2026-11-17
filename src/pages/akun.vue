<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '~/utils/supabase'
import Icon from '~/components/Icon.vue'
const router=useRouter()
const session=ref(null); const email=ref(''); const busy=ref(false); const msg=ref(''); const saved=ref({})
const nama=ref(''); const phone=ref(''); const kota=ref(''); const wa=ref(false); const pbusy=ref(false); const pmsg=ref(''); const ploaded=ref(false)
async function loadProfil(){
  if(!session.value)return
  const {data}=await supabase.from('profiles').select('*').eq('uid',session.value.user.id).maybeSingle()
  if(data){nama.value=data.nama||'';phone.value=data.phone||'';kota.value=data.kota||'';wa.value=!!data.wa_opt_in}
  ploaded.value=true
}
async function simpanProfil(){
  if(!session.value){pmsg.value='Masuk dulu buat menyimpan.';return}
  const hp=phone.value.replace(/[^0-9+]/g,'')
  if(hp && hp.replace('+','').length<9){pmsg.value='Nomor WhatsApp kelihatan kurang lengkap.';return}
  pbusy.value=true;pmsg.value=''
  const {error}=await supabase.from('profiles').upsert({uid:session.value.user.id,nama:nama.value.trim()||null,phone:hp||null,kota:kota.value.trim()||null,wa_opt_in:wa.value,sumber:'akun',diubah:new Date().toISOString()},{onConflict:'uid'})
  pmsg.value=error?('Gagal simpan: '+error.message):'Tersimpan. Cuma lo dan tim yang bisa lihat.'
  pbusy.value=false
}
const LINKS=[['mall','store','Mall Cashback'],['game','gamepad','Game & Voucher'],['travel','compass','Traveloka Xperience'],['trip','plane','Trip.com'],['ppob','zap','PPOB']]
const total=computed(()=>Object.values(saved.value).reduce((a,b)=>a+b,0))
onMounted(async()=>{
  const m={}
  for(const [k] of LINKS){try{const s=localStorage.getItem('shop_saved_'+k);m[k]=s?(JSON.parse(s)||[]).length:0}catch(_){m[k]=0}}
  try{const o=localStorage.getItem('tv_saved_v1');if(o)m.travel=Math.max(m.travel||0,(JSON.parse(o)||[]).length)}catch(_){}
  saved.value=m
  try{const {data}=await supabase.auth.getSession();session.value=data.session||null}catch(_){}
  await loadProfil()
})
async function masuk(){
  if(!email.value.includes('@')){msg.value='Masukkan email yang valid.';return}
  busy.value=true;msg.value=''
  try{const {error}=await supabase.auth.signInWithOtp({email:email.value.trim(),options:{emailRedirectTo:location.origin+'/akun'}})
    msg.value=error?error.message:'Tautan masuk dikirim. Buka email lo, klik tautannya.'}catch(e){msg.value='Gagal kirim tautan.'}
  busy.value=false
}
async function keluar(){try{await supabase.auth.signOut();session.value=null;ploaded.value=false;msg.value='Sudah keluar.'}catch(_){}}
</script>
<template>
<main class="ak">
  <header class="bar"><button class="ib" @click="router.push('/')" aria-label="Beranda"><Icon name="back" :size="19"/></button><b>Akun</b><span class="sp"/></header>
  <section class="card">
    <div class="av"><Icon :name="session?'users':'users'" :size="26"/></div>
    <div class="who">
      <b>{{session?session.user.email:'Mode Tamu'}}</b>
      <small>{{session?'Masuk · simpanan tersinkron di perangkat ini':'Jelajah & simpan tanpa perlu daftar. Masuk cuma kalau mau sinkron.'}}</small>
    </div>
  </section>
  <section class="stat">
    <div><b>{{total}}</b><span>Total disimpan</span></div>
    <div><b>{{Object.keys(saved).length}}</b><span>Katalog</span></div>
  </section>
  <section class="list">
    <button v-for="[k,i,l] in LINKS" :key="k" @click="router.push('/'+k)">
      <span class="li"><Icon :name="i" :size="18"/></span>
      <span class="lt">{{l}}</span>
      <span class="ln">{{saved[k]||0}}</span>
      <Icon name="chevron" :size="16"/>
    </button>
  </section>
  <section class="auth">
    <template v-if="!session">
      <h3>Masuk opsional</h3>
      <p>Simpanan lo sudah aman di perangkat. Masuk pakai email kalau mau lanjut di perangkat lain.</p>
      <div class="row"><input v-model="email" type="email" placeholder="email@contoh.com" aria-label="Email"/><button :disabled="busy" @click="masuk">{{busy?'Mengirim…':'Kirim tautan'}}</button></div>
    </template>
    <template v-else><button class="out" @click="keluar">Keluar</button></template>
    <p v-if="msg" class="msg">{{msg}}</p>
  </section>
  <section v-if="session" class="auth">
    <h3>Biar cashback nggak hangus</h3>
    <p>Kami ingatkan lewat WhatsApp kalau saldo masuk, misi hampir lewat, atau merek yang lo tunggu dibuka. NOL spam, berhenti kapan aja.</p>
    <div class="pform">
      <input v-model="nama" type="text" placeholder="Nama panggilan" aria-label="Nama"/>
      <input v-model="phone" type="tel" inputmode="tel" placeholder="Nomor WhatsApp (08…)" aria-label="WhatsApp"/>
      <input v-model="kota" type="text" placeholder="Kota (biar promo lokal pas)" aria-label="Kota"/>
      <label class="ck"><input v-model="wa" type="checkbox"/><span>Saya setuju dihubungi lewat WhatsApp soal cashback & promo. Data tidak dibagikan ke pihak lain.</span></label>
      <button class="pbtn" :disabled="pbusy||!wa" @click="simpanProfil">{{pbusy?'Menyimpan…':'Aktifkan pengingat'}}</button>
      <p v-if="pmsg" class="msg">{{pmsg}}</p>
      <small class="priv">Nomor & email lo terenkripsi di database, cuma bisa dibaca akun lo sendiri dan tim internal. NOL dijual, NOL tampil publik. Lo bisa hapus kapan aja.</small>
    </div>
  </section>
  <section class="info">
    <h3>Cara cashback jalan</h3>
    <ol><li>Pilih penawaran di katalog, tap <b>Pesan</b>.</li><li>Selesaikan pembayaran di halaman mitra resmi.</li><li>Transaksi tervalidasi mitra → cashback tercatat.</li></ol>
    <small>Angka cashback yang tampil adalah estimasi maksimum kategori campaign, bukan janji per item.</small>
  </section>
</main>
</template>
<style scoped>
.ak{min-height:100vh;background:#FFF7EC;color:#1a1a1a;font-family:system-ui,sans-serif;padding-bottom:40px}
.bar{position:sticky;top:0;z-index:20;display:flex;gap:10px;align-items:center;padding:calc(10px + env(safe-area-inset-top)) 14px 10px;background:rgba(255,247,236,.9);backdrop-filter:blur(12px);border-bottom:1px solid #eadfd0}
.bar b{font-size:15px}.sp{flex:1}
.ib{width:36px;height:36px;display:grid;place-items:center;border:1px solid #eadfd0;border-radius:11px;background:#fff;cursor:pointer}
.card{display:flex;gap:12px;align-items:center;margin:14px;padding:14px;border-radius:18px;background:linear-gradient(135deg,#FF7A45,#FF4D3D);color:#fff}
.av{width:48px;height:48px;flex:0 0 auto;display:grid;place-items:center;border-radius:16px;background:rgba(255,255,255,.2)}
.who b{display:block;font-size:15px}.who small{display:block;font-size:11px;opacity:.9;margin-top:3px;line-height:1.4}
.stat{display:flex;gap:10px;margin:0 14px 14px}
.stat div{flex:1;background:#fff;border:1px solid #eadfd0;border-radius:14px;padding:11px 13px}
.stat b{display:block;font-size:19px;color:#FF4D3D}.stat span{font-size:10px;color:#7b7268;font-weight:700}
.list{margin:0 14px 14px;background:#fff;border:1px solid #eadfd0;border-radius:16px;overflow:hidden}
.list button{display:flex;gap:11px;align-items:center;width:100%;border:0;border-bottom:1px solid #f3e9dc;background:none;padding:13px 14px;cursor:pointer;color:#1a1a1a;text-align:left}
.list button:last-child{border-bottom:0}
.list button:active{background:#FFF3E9}
.li{width:34px;height:34px;display:grid;place-items:center;border-radius:11px;background:#FFF3E9;color:#FF7A45}
.lt{flex:1;font-size:13px;font-weight:700}
.ln{font-size:11px;font-weight:900;color:#fff;background:#00B8A9;border-radius:99px;padding:2px 8px}
.auth,.info{margin:0 14px 14px;background:#fff;border:1px solid #eadfd0;border-radius:16px;padding:14px}
.auth h3,.info h3{margin:0 0 6px;font-size:14px}
.auth p,.info small{margin:0 0 10px;font-size:11.5px;color:#7b7268;line-height:1.5}
.row{display:flex;gap:8px}
.row input{flex:1;min-width:0;border:1px solid #eadfd0;border-radius:11px;padding:10px 12px;font-size:13px;outline:none;background:#FFF7EC}
.row button,.out{border:0;border-radius:11px;padding:10px 14px;font-weight:900;font-size:12px;color:#fff;background:linear-gradient(135deg,#FF7A45,#FF4D3D);cursor:pointer}
.row button:disabled{opacity:.6}
.msg{margin:10px 0 0;font-size:11.5px;color:#B34700;font-weight:700}
.pform{display:flex;flex-direction:column;gap:8px}
.pform input[type=text],.pform input[type=tel]{border:1px solid #eadfd0;border-radius:11px;padding:10px 12px;font-size:13px;outline:none;background:#FFF7EC;color:#1a1a1a}
.ck{display:flex;gap:8px;align-items:flex-start;font-size:10.5px;color:#7b7268;line-height:1.45}
.ck input{margin-top:2px;accent-color:#FF4D3D}
.pbtn{border:0;border-radius:11px;padding:11px;font-weight:900;font-size:12.5px;color:#fff;background:linear-gradient(135deg,#FF7A45,#FF4D3D);cursor:pointer}
.pbtn:disabled{opacity:.5}
.priv{font-size:9.5px;color:#9a8f82;line-height:1.45}
.info ol{margin:0 0 10px;padding-left:18px;font-size:12px;line-height:1.7;color:#4a4239}
</style>
