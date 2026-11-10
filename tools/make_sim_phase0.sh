cd "$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p src/pages/sim src/components/sim src/data src/styles

cat > src/styles/sim.css <<'SIMCSS_EOF'
:root{
  --sim-joy:#FF7A45; --sim-action:#FF4D3D; --sim-alarm:#E63946; --sim-cool:#00B8A9; --sim-cream:#FFF7EC;
  --sim-online:var(--sim-cool); --sim-idle:var(--sim-joy); --sim-offline:#5b5b66;
  --sim-bg:#0d0d12; --sim-surface:#15151d; --sim-surface-2:#1d1d27; --sim-border:#2a2a36;
  --sim-text:#f4f4f7; --sim-dim:#9a9aa6;
  --sp-1:8px; --sp-2:16px; --sp-3:24px; --sp-4:32px; --sp-6:48px;
  --t-xs:12px; --t-sm:14px; --t-md:16px; --t-lg:20px; --t-xl:28px; --t-2xl:36px;
  --r-card:24px; --r-pill:999px; --r-ctl:16px;
  --spring:cubic-bezier(.2,0,0,1); --spring-bounce:cubic-bezier(.34,1.56,.64,1);
}
@keyframes sim-pulse{0%{box-shadow:0 0 0 0 rgba(0,184,169,.5)}70%{box-shadow:0 0 0 6px rgba(0,184,169,0)}100%{box-shadow:0 0 0 0 rgba(0,184,169,0)}}
SIMCSS_EOF

cat > src/data/simProfiles.json <<'SIMJSON_EOF'
[
 {"id":1,"name":"Raka","age":27,"bio":"kopi hitam, hujan, dan lagu lama.","images":[],"tags":["kopi","musik"],"stage":1,"presence":"online"},
 {"id":2,"name":"Sena","age":24,"bio":"naik gunung tiap weekend.","images":[],"tags":["outdoor"],"stage":1,"presence":"idle"},
 {"id":3,"name":"Mila","age":26,"bio":"film indie dan buku second-hand.","images":[],"tags":["film","buku"],"stage":1,"presence":"online"},
 {"id":4,"name":"Dio","age":29,"bio":"masak simple, makan bareng.","images":[],"tags":["kuliner"],"stage":1,"presence":"offline"},
 {"id":5,"name":"Nara","age":23,"bio":"foto jalanan sore hari.","images":[],"tags":["fotografi"],"stage":1,"presence":"online"},
 {"id":6,"name":"Yoga","age":28,"bio":"gym pagi, ngopi siang.","images":[],"tags":["fitness"],"stage":1,"presence":"idle"},
 {"id":7,"name":"Tara","age":25,"bio":"tanaman indoor dan podcast.","images":[],"tags":["plant","audio"],"stage":1,"presence":"offline"},
 {"id":8,"name":"Bayu","age":30,"bio":"sepeda lipat, rute baru.","images":[],"tags":["sepeda"],"stage":1,"presence":"online"},
 {"id":9,"name":"Vina","age":22,"bio":"lukis cat air akhir pekan.","images":[],"tags":["art"],"stage":1,"presence":"idle"},
 {"id":10,"name":"Ardi","age":27,"bio":"boardgame dan teh manis.","images":[],"tags":["game"],"stage":1,"presence":"offline"}
]
SIMJSON_EOF

cat > src/components/sim/PresenceDot.vue <<'PD_EOF'
<script setup lang="ts">
import { computed } from 'vue'
const props = withDefaults(defineProps<{ status?: 'online'|'offline'|'idle'; size?: number; absolute?: boolean }>(), { status:'offline', size:8, absolute:false })
const cls = computed(() => props.status)
</script>
<template>
  <span class="dot" :class="[cls, { abs: props.absolute }]" :style="{ width: size+'px', height: size+'px' }" />
</template>
<style scoped>
@import '../../styles/sim.css';
.dot{display:inline-block;border-radius:50%;border:2px solid var(--sim-bg);background:var(--sim-offline)}
.dot.online{background:var(--sim-online);animation:sim-pulse 2s infinite}
.dot.idle{background:var(--sim-idle)}
.dot.abs{position:absolute;right:0;bottom:0}
</style>
PD_EOF

cat > src/components/sim/SimCard.vue <<'SC_EOF'
<script setup lang="ts">
import { computed } from 'vue'
import PresenceDot from '~/components/sim/PresenceDot.vue'
const props = defineProps<{ profile: any }>()
const initials = computed(() => (props.profile?.name?.[0] || '?').toUpperCase())
</script>
<template>
  <article class="card">
    <div class="mesh" />
    <div class="body">
      <div class="head">
        <div class="av-wrap">
          <div class="av">{{ initials }}</div>
          <PresenceDot :status="profile.presence" :size="10" absolute />
        </div>
        <div class="meta">
          <div class="nm">{{ profile.name }}, {{ profile.age }}</div>
          <div class="bio">{{ profile.bio }}</div>
        </div>
      </div>
      <div class="tags">
        <span v-for="t in profile.tags" :key="t" class="tag">{{ t }}</span>
      </div>
    </div>
  </article>
</template>
<style scoped>
@import '../../styles/sim.css';
.card{position:relative;width:100%;height:100%;border-radius:var(--r-card);overflow:hidden;border:1px solid var(--sim-border);background:var(--sim-surface);box-shadow:0 18px 40px rgba(0,0,0,.45)}
.mesh{position:absolute;inset:0;background:
  radial-gradient(120% 80% at 15% 10%, rgba(255,122,69,.22), transparent 60%),
  radial-gradient(120% 80% at 85% 20%, rgba(0,184,169,.20), transparent 60%),
  radial-gradient(140% 90% at 50% 100%, rgba(255,77,61,.16), transparent 60%),
  var(--sim-surface-2);}
.body{position:relative;height:100%;display:flex;flex-direction:column;justify-content:flex-end;padding:var(--sp-3)}
.head{display:flex;gap:var(--sp-2);align-items:flex-end}
.av-wrap{position:relative;flex:0 0 auto}
.av{width:64px;height:64px;border-radius:50%;display:grid;place-items:center;font:800 var(--t-lg) system-ui;color:var(--sim-cream);background:linear-gradient(135deg,var(--sim-joy),var(--sim-action));border:2px solid var(--sim-bg)}
.meta{min-width:0}
.nm{font:800 var(--t-lg) system-ui;color:var(--sim-text)}
.bio{font:400 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:2px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.tags{display:flex;flex-wrap:wrap;gap:var(--sp-1);margin-top:var(--sp-2)}
.tag{font:600 var(--t-xs) system-ui;color:var(--sim-text);background:rgba(255,255,255,.06);border:1px solid var(--sim-border);padding:4px 10px;border-radius:var(--r-pill)}
</style>
SC_EOF

cat > src/components/sim/SwipeDeck.vue <<'SD_EOF'
<script setup lang="ts">
import { ref, computed } from 'vue'
import SimCard from '~/components/sim/SimCard.vue'
const props = defineProps<{ cards: any[] }>()
const emit = defineEmits<{ (e:'decide', p:{dir:string; card:any}):void }>()
const stack = ref<any[]>([...props.cards])
const popped = ref<any[]>([])
const dragging = ref(false)
const dx = ref(0); const dy = ref(0); const sx = ref(0); const sy = ref(0)
const flying = ref<''|'left'|'right'|'up'>('')
const W = computed(() => (typeof window !== 'undefined' ? window.innerWidth : 360))
const TH = computed(() => W.value * 0.4)
const topStyle = computed(() => {
  if (flying.value === 'left') return { transform:'translateX(-120%) rotate(-18deg)', opacity:'0', transition:'transform .38s var(--spring-bounce), opacity .38s linear' }
  if (flying.value === 'right') return { transform:'translateX(120%) rotate(18deg)', opacity:'0', transition:'transform .38s var(--spring-bounce), opacity .38s linear' }
  if (flying.value === 'up') return { transform:'translateY(-120%)', opacity:'0', transition:'transform .38s var(--spring-bounce), opacity .38s linear' }
  if (dragging.value) return { transform:`translate(${dx.value}px, ${dy.value}px) rotate(${dx.value*0.05}deg)`, transition:'none' }
  return { transform:'translate(0,0) rotate(0deg)', transition:'transform .3s var(--spring)' }
})
const likeOp = computed(() => Math.min(1, Math.max(0, dx.value / TH.value)))
const nopeOp = computed(() => Math.min(1, Math.max(0, -dx.value / TH.value)))
const supOp  = computed(() => Math.min(1, Math.max(0, -dy.value / (TH.value * 0.8))))
function down(e:PointerEvent){ if(flying.value) return; dragging.value=true; sx.value=e.clientX; sy.value=e.clientY; (e.currentTarget as HTMLElement).setPointerCapture?.(e.pointerId) }
function move(e:PointerEvent){ if(!dragging.value) return; dx.value=e.clientX-sx.value; dy.value=e.clientY-sy.value }
function up(){ if(!dragging.value) return; dragging.value=false; const x=dx.value, y=dy.value; dx.value=0; dy.value=0; if(x>TH.value) fly('right'); else if(x<-TH.value) fly('left'); else if(y<-TH.value*0.8) fly('up'); }
function fly(dir:'left'|'right'|'up'){ const card=stack.value[0]; if(!card) return; flying.value=dir; popped.value.unshift(card); setTimeout(()=>{ stack.value.shift(); flying.value=''; emit('decide',{dir,card}) },380) }
function like(){ fly('right') } function nope(){ fly('left') } function sup(){ fly('up') }
function undo(){ const c=popped.value.shift(); if(c) stack.value.unshift(c) }
defineExpose({ like, nope, sup, undo })
</script>
<template>
  <div class="deck">
    <div v-if="!stack.length" class="empty">Deck habis — undo atau reload.</div>
    <div v-for="(c,i) in stack.slice(0,3)" :key="c.id" class="slot" :class="{top:i===0}"
      :style="i===0 ? topStyle : { transform:`translateY(${i*10}px) scale(${1-i*0.04})`, zIndex:String(10-i) }"
      @pointerdown="i===0 ? down($event) : null"
      @pointermove="i===0 ? move($event) : null"
      @pointerup="i===0 ? up() : null"
      @pointercancel="i===0 ? up() : null">
      <SimCard :profile="c" />
      <div v-if="i===0" class="ov like" :style="{opacity:likeOp}">LIKE</div>
      <div v-if="i===0" class="ov nope" :style="{opacity:nopeOp}">NOPE</div>
      <div v-if="i===0" class="ov sup"  :style="{opacity:supOp}">SUPER</div>
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.deck{position:relative;width:100%;height:100%;min-height:440px;touch-action:none}
.slot{position:absolute;inset:0}
.ov{position:absolute;top:24px;font:800 var(--t-lg) system-ui;letter-spacing:2px;padding:6px 14px;border:3px solid;border-radius:var(--r-pill);pointer-events:none}
.ov.like{left:24px;color:var(--sim-cool);border-color:var(--sim-cool);transform:rotate(-12deg)}
.ov.nope{right:24px;color:var(--sim-alarm);border-color:var(--sim-alarm);transform:rotate(12deg)}
.ov.sup{left:50%;transform:translateX(-50%);color:var(--sim-joy);border-color:var(--sim-joy)}
.empty{position:absolute;inset:0;display:grid;place-items:center;color:var(--sim-dim)}
</style>
SD_EOF

cat > src/components/sim/StageBadge.vue <<'SB_EOF'
<script setup lang="ts">
withDefaults(defineProps<{ label:string; state?:'locked'|'unlocked'|'earned'; kind?:'reward'|'punish'; count?:number }>(), { state:'locked', kind:'reward' })
</script>
<template>
  <span class="bdg" :class="[state, kind]">
    <i class="pip" />
    <span class="lb">{{ label }}</span>
    <span v-if="count !== undefined" class="ct">{{ count }}</span>
  </span>
</template>
<style scoped>
@import '../../styles/sim.css';
.bdg{display:inline-flex;align-items:center;gap:6px;padding:6px 12px;border-radius:var(--r-pill);border:1px solid var(--sim-border);background:var(--sim-surface-2);font:600 var(--t-xs) system-ui;color:var(--sim-dim)}
.pip{width:8px;height:8px;border-radius:50%;background:var(--sim-offline)}
.unlocked{color:var(--sim-text)} .unlocked .pip{background:var(--sim-cool)}
.earned{color:var(--sim-cream);border-color:var(--sim-joy)} .earned .pip{background:var(--sim-joy)}
.punish.earned{border-color:var(--sim-alarm)} .punish .pip{background:var(--sim-alarm)}
.ct{margin-left:2px;background:rgba(255,255,255,.08);padding:0 6px;border-radius:var(--r-pill)}
</style>
SB_EOF

cat > src/components/sim/WalletChip.vue <<'WC_EOF'
<script setup lang="ts">
defineProps<{ balance:number; currency?:string }>()
const emit = defineEmits<{ (e:'open'):void }>()
function fmt(n:number){ return n.toLocaleString('id-ID') }
</script>
<template>
  <button class="chip" @click="emit('open')">
    <span class="coin" />
    <span class="amt">{{ currency || 'Rp' }}{{ fmt(balance) }}</span>
  </button>
</template>
<style scoped>
@import '../../styles/sim.css';
.chip{display:inline-flex;align-items:center;gap:8px;padding:6px 12px 6px 8px;border-radius:var(--r-pill);border:1px solid var(--sim-border);background:var(--sim-surface-2);cursor:pointer}
.coin{width:18px;height:18px;border-radius:50%;background:radial-gradient(circle at 35% 30%, var(--sim-cream), var(--sim-joy) 60%, var(--sim-action));box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)}
.amt{font:700 var(--t-sm) system-ui;color:var(--sim-text)}
</style>
WC_EOF

cat > src/components/sim/SocialRail.vue <<'SR_EOF'
<script setup lang="ts">
import { computed } from 'vue'
import PresenceDot from '~/components/sim/PresenceDot.vue'
const props = defineProps<{ stories:any[] }>()
const items = computed(() => props.stories.slice(0,8))
function ini(n:string){ return (n?.[0]||'?').toUpperCase() }
</script>
<template>
  <div class="rail">
    <div class="col mine">
      <div class="ring add"><span class="plus">+</span></div>
      <div class="nm">Story</div>
    </div>
    <div v-for="(s,i) in items" :key="s.id" class="col">
      <div class="ring" :class="{seen:i>2}">
        <div class="av">{{ ini(s.name) }}</div>
        <PresenceDot :status="s.presence" :size="9" absolute />
        <span v-if="i===1" class="nd" />
      </div>
      <div class="nm">{{ s.name }}</div>
    </div>
  </div>
  <div class="dots"><i v-for="n in 4" :key="n" :class="{on:n===1}" /></div>
</template>
<style scoped>
@import '../../styles/sim.css';
.rail{display:flex;gap:var(--sp-2);overflow-x:auto;padding:var(--sp-2) var(--sp-3);scrollbar-width:none}
.rail::-webkit-scrollbar{display:none}
.col{flex:0 0 auto;width:64px;text-align:center}
.ring{position:relative;width:60px;height:60px;margin:0 auto;border-radius:50%;padding:2px;background:conic-gradient(from 210deg, var(--sim-cool), var(--sim-joy), var(--sim-action), var(--sim-cool))}
.ring.seen{background:var(--sim-border)}
.ring.add{background:var(--sim-surface-2);display:grid;place-items:center;border:1px dashed var(--sim-border)}
.plus{font:700 var(--t-lg) system-ui;color:var(--sim-dim)}
.av{width:100%;height:100%;border-radius:50%;display:grid;place-items:center;font:800 var(--t-md) system-ui;color:var(--sim-cream);background:var(--sim-surface);border:2px solid var(--sim-bg)}
.nd{position:absolute;top:-2px;right:-2px;width:12px;height:12px;border-radius:50%;background:var(--sim-alarm);border:2px solid var(--sim-bg)}
.nm{font:500 var(--t-xs) system-ui;color:var(--sim-dim);margin-top:6px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.dots{display:flex;gap:5px;justify-content:center;padding-bottom:var(--sp-1)}
.dots i{width:6px;height:6px;border-radius:50%;background:var(--sim-border)}
.dots i.on{background:var(--sim-cool);width:16px;border-radius:var(--r-pill)}
</style>
SR_EOF

cat > src/pages/sim/index.vue <<'PGI_EOF'
<script setup lang="ts">
import SocialRail from '~/components/sim/SocialRail.vue'
import profilesRaw from '~/data/simProfiles.json'
const profiles = profilesRaw as any[]
const tiles = [
  { to:'/sim/match', t:'Match', d:'swipe deck' },
  { to:'/sim/stage', t:'Stage', d:'dunia 1' },
  { to:'/sim/wallet', t:'Wallet', d:'money digital' },
  { to:'/sim/profile', t:'Profile', d:'badge & pansos' },
]
</script>
<template>
  <div class="hub">
    <header class="hd"><span class="br">shoper</span><span class="tg">sim</span></header>
    <SocialRail :stories="profiles" />
    <div class="grid">
      <router-link v-for="x in tiles" :key="x.to" :to="x.to" class="tile">
        <div class="tt">{{ x.t }}</div><div class="dd">{{ x.d }}</div>
      </router-link>
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.hub{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding-bottom:var(--sp-6)}
.hd{display:flex;align-items:baseline;gap:8px;padding:var(--sp-2) var(--sp-3)}
.br{font:800 var(--t-xl) system-ui;color:var(--sim-joy)}
.tg{font:600 var(--t-sm) system-ui;color:var(--sim-dim)}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-2);padding:var(--sp-2) var(--sp-3)}
.tile{display:block;padding:var(--sp-3);border-radius:var(--r-card);border:1px solid var(--sim-border);background:var(--sim-surface);text-decoration:none;color:inherit;transition:transform .25s var(--spring)}
.tile:active{transform:scale(.97)}
.tt{font:800 var(--t-lg) system-ui}
.dd{font:500 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:4px}
</style>
PGI_EOF

cat > src/pages/sim/match.vue <<'PGM_EOF'
<script setup lang="ts">
import { ref } from 'vue'
import SwipeDeck from '~/components/sim/SwipeDeck.vue'
import WalletChip from '~/components/sim/WalletChip.vue'
import profilesRaw from '~/data/simProfiles.json'
const profiles = profilesRaw as any[]
const deck = ref<{ like:()=>void; nope:()=>void; sup:()=>void; undo:()=>void } | null>(null)
const swiped = ref(0)
function onDecide(){ swiped.value++ }
</script>
<template>
  <div class="mt">
    <div class="bar">
      <router-link to="/sim" class="bk">←</router-link>
      <span class="ti">match</span>
      <WalletChip :balance="0" />
    </div>
    <div class="stage"><SwipeDeck ref="deck" :cards="profiles" @decide="onDecide" /></div>
    <div class="ctl">
      <button class="c undo" @click="deck?.undo()">↺</button>
      <button class="c nope" @click="deck?.nope()">✕</button>
      <button class="c sup"  @click="deck?.sup()">★</button>
      <button class="c like" @click="deck?.like()">♥</button>
    </div>
    <div class="cnt">swiped: {{ swiped }}</div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.mt{height:100vh;display:flex;flex-direction:column;background:var(--sim-bg);color:var(--sim-text)}
.bar{display:flex;align-items:center;gap:var(--sp-2);padding:var(--sp-2) var(--sp-3)}
.bk{font:700 var(--t-lg) system-ui;color:var(--sim-dim);text-decoration:none}
.ti{flex:1;font:800 var(--t-lg) system-ui}
.stage{flex:1;padding:0 var(--sp-3)}
.ctl{display:flex;justify-content:center;gap:var(--sp-3);padding:var(--sp-3)}
.c{width:56px;height:56px;border-radius:50%;border:1px solid var(--sim-border);background:var(--sim-surface-2);font:700 var(--t-xl) system-ui;color:var(--sim-text);cursor:pointer;transition:transform .2s var(--spring-bounce)}
.c:active{transform:scale(.9)}
.c.undo{color:var(--sim-joy)} .c.nope{color:var(--sim-alarm)} .c.sup{color:var(--sim-joy)} .c.like{color:var(--sim-cool)}
.cnt{text-align:center;font:500 var(--t-xs) system-ui;color:var(--sim-dim);padding-bottom:var(--sp-2)}
</style>
PGM_EOF

cat > src/pages/sim/stage.vue <<'PGS_EOF'
<script setup lang="ts">
import StageBadge from '~/components/sim/StageBadge.vue'
const badges = [
  { label:'First Match', state:'earned', kind:'reward', count:1 },
  { label:'Streak 3', state:'unlocked', kind:'reward' },
  { label:'Daily Cap', state:'locked', kind:'reward', count:0 },
  { label:'Skip Penalty', state:'earned', kind:'punish', count:2 },
  { label:'World 2', state:'locked', kind:'reward' },
  { label:'Pansos', state:'unlocked', kind:'reward' },
]
</script>
<template>
  <div class="sg">
    <header class="hd"><span class="cur">Dunia 1</span><span class="sub">stub · theme beneran = FASE 2</span></header>
    <div class="row">
      <StageBadge v-for="b in badges" :key="b.label" v-bind="b" />
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.sg{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding:var(--sp-3)}
.hd{margin-bottom:var(--sp-3)}
.cur{font:800 var(--t-2xl) system-ui;color:var(--sim-joy)}
.sub{display:block;font:500 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:4px}
.row{display:flex;flex-wrap:wrap;gap:var(--sp-2)}
</style>
PGS_EOF

cat > src/pages/sim/wallet.vue <<'PGW_EOF'
<script setup lang="ts">
import WalletChip from '~/components/sim/WalletChip.vue'
const bal = 0
const tx: any[] = []
</script>
<template>
  <div class="wl">
    <div class="big"><span class="cur">Rp</span><span class="num">{{ bal.toLocaleString('id-ID') }}</span></div>
    <div class="hint">top-up & earn = FASE 3 (Midtrans/Xendit sandbox). NOL free path.</div>
    <div class="list">
      <div v-if="!tx.length" class="empty">Belum ada transaksi.</div>
    </div>
    <div class="foot"><WalletChip :balance="bal" /></div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.wl{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding:var(--sp-4) var(--sp-3);display:flex;flex-direction:column;gap:var(--sp-3)}
.big{display:flex;align-items:baseline;gap:6px}
.cur{font:700 var(--t-lg) system-ui;color:var(--sim-dim)}
.num{font:800 var(--t-2xl) system-ui;color:var(--sim-cream)}
.hint{font:500 var(--t-sm) system-ui;color:var(--sim-dim)}
.list{flex:1;border:1px dashed var(--sim-border);border-radius:var(--r-card);padding:var(--sp-3)}
.empty{color:var(--sim-dim);font:500 var(--t-sm) system-ui}
.foot{display:flex;justify-content:center}
</style>
PGW_EOF

cat > src/pages/sim/profile.vue <<'PGP_EOF'
<script setup lang="ts">
import PresenceDot from '~/components/sim/PresenceDot.vue'
import StageBadge from '~/components/sim/StageBadge.vue'
import profilesRaw from '~/data/simProfiles.json'
const me = (profilesRaw as any[])[0]
const pinned = [ {label:'First Match',state:'earned',kind:'reward'}, {label:'Pansos',state:'unlocked',kind:'reward'} ]
</script>
<template>
  <div class="pf">
    <div class="top">
      <div class="av-wrap"><div class="av">{{ me.name[0] }}</div><PresenceDot :status="me.presence" :size="12" absolute /></div>
      <div class="who"><div class="nm">{{ me.name }}, {{ me.age }}</div><div class="bio">{{ me.bio }}</div></div>
    </div>
    <div class="sec">
      <div class="lbl">badge di-pin (pansos)</div>
      <div class="row"><StageBadge v-for="b in pinned" :key="b.label" v-bind="b" /></div>
    </div>
    <div class="sec">
      <div class="lbl">dia lagi beli apa</div>
      <div class="ph">opt-in · commerce card = FASE 4</div>
    </div>
  </div>
</template>
<style scoped>
@import '../../styles/sim.css';
.pf{min-height:100%;background:var(--sim-bg);color:var(--sim-text);padding:var(--sp-3);display:flex;flex-direction:column;gap:var(--sp-4)}
.top{display:flex;gap:var(--sp-2);align-items:center}
.av-wrap{position:relative}
.av{width:72px;height:72px;border-radius:50%;display:grid;place-items:center;font:800 var(--t-xl) system-ui;color:var(--sim-cream);background:linear-gradient(135deg,var(--sim-joy),var(--sim-action));border:2px solid var(--sim-bg)}
.nm{font:800 var(--t-lg) system-ui}
.bio{font:500 var(--t-sm) system-ui;color:var(--sim-dim);margin-top:2px}
.lbl{font:700 var(--t-sm) system-ui;color:var(--sim-dim);margin-bottom:var(--sp-1)}
.row{display:flex;flex-wrap:wrap;gap:var(--sp-1)}
.ph{border:1px dashed var(--sim-border);border-radius:var(--r-card);padding:var(--sp-3);color:var(--sim-dim);font:500 var(--t-sm) system-ui}
</style>
PGP_EOF

# ---- verifikasi (soft, NOL set -e biar grep 0-match nggak abort) ----
miss=0
for p in src/styles/sim.css src/data/simProfiles.json \
  src/components/sim/PresenceDot.vue src/components/sim/SimCard.vue src/components/sim/SwipeDeck.vue \
  src/components/sim/StageBadge.vue src/components/sim/WalletChip.vue src/components/sim/SocialRail.vue \
  src/pages/sim/index.vue src/pages/sim/match.vue src/pages/sim/stage.vue src/pages/sim/wallet.vue src/pages/sim/profile.vue; do
  [ -f "$p" ] || { echo "MISSING: $p"; miss=1; }
done
[ "$miss" = 1 ] && { echo "FASE0 FAIL: ada file nggak ke-create"; exit 1; }
echo "=== TREE ==="
find src/pages/sim src/components/sim -name '*.vue' | sort
ls -1 src/styles/sim.css src/data/simProfiles.json
echo "=== JSON ==="
node -e "const d=JSON.parse(require('fs').readFileSync('src/data/simProfiles.json','utf8'));console.log('json OK n='+d.length)" 2>&1 || echo "json PARSE FAIL"
echo "=== TAG BALANCE (harus semua OK) ==="
for f in $(find src/pages/sim src/components/sim -name '*.vue'); do
  a=$(grep -c '<template>' "$f"); b=$(grep -c '</template>' "$f"); c=$(grep -c '<script' "$f"); d=$(grep -c '</script>' "$f")
  [ "$a" = "$b" ] && [ "$c" = "$d" ] && echo "OK  $f" || echo "BAD $f (tpl $a/$b scr $c/$d)"
done
echo "=== PRIMITIF GUNUNG8 (path buat swap FASE1, NOL ditebak sekarang) ==="
find src -name 'StoryCircle.vue' -o -name 'Dots.vue' -o -name 'NotifDot.vue' 2>/dev/null
echo "=== FASE0 SHELL CREATED ==="
