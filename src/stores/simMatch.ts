// KANTONG 3 — MATCH FIXTURE store (FASE 1). Self-contained, NOL pinia, NOL dep luar.
// moneyGated=false per bullet merah FASE 1: NOL blokir test.
import { ref, computed } from 'vue'
import profilesRaw from '~/data/simProfiles.json'

const list = profilesRaw as any[]
const currentIdx = ref(0)
const swipeHistory = ref<{ id: string; dir: 'like' | 'nope' | 'sup' | 'undo' }[]>([])
const matchQueue = ref<string[]>(['p01'])
const moneyGated = ref(false) // FASE 1: super-like/undo GRATIS dulu (wallet = FASE 3)
let undoUsedThisSession = false

export function useSimMatch() {
  const current = computed(() => list[currentIdx.value] ?? null)
  const deck = computed(() => list.slice(currentIdx.value, currentIdx.value + 1))
  const remaining = computed(() => Math.max(0, list.length - currentIdx.value))

  function decide(dir: 'like' | 'nope' | 'sup') {
    const p = current.value
    if (!p) return
    swipeHistory.value.push({ id: String(p.id), dir })
    if (dir === 'like' || dir === 'sup') matchQueue.value.push(String(p.id)) // fixture: simulasi mutual
    currentIdx.value += 1
  }
  function undo() {
    if (undoUsedThisSession) return false       // 1x/session
    if (currentIdx.value <= 0) return false
    if (moneyGated.value) return false          // FASE 3 nanti: cost; FASE 1 gratis
    const last = swipeHistory.value.pop()
    if (last) {
      currentIdx.value -= 1
      matchQueue.value = matchQueue.value.filter(id => id !== last.id)
      undoUsedThisSession = true
      return true
    }
    return false
  }
  function reset() { currentIdx.value = 0; swipeHistory.value = []; matchQueue.value = []; undoUsedThisSession = false }

  return { list, current, deck, remaining, currentIdx, swipeHistory, matchQueue, moneyGated, decide, undo, reset }
}
