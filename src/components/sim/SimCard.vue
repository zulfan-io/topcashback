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
