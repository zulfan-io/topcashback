// KANTONG 4 — STAGE STUB store (FASE 2 ringan)
// Self-contained, NOL pinia, NOL Supabase, NOL wallet beneran.
import { ref, computed } from 'vue'
import stagesRaw from '~/data/simStages.json'

const stages = stagesRaw as any[]
const currentStageId = ref(stages[0]?.id ?? '')
const unlocked = ref<string[]>([stages[0]?.id ?? ''])
const stageProgress = ref<Record<string, number>>({})
const dailyUsed = ref(0)
const dailyCap = 3

export function useSimStage() {
  const current = computed(() => stages.find((s: any) => s.id === currentStageId.value) ?? null)
  const progress = computed(() => stageProgress.value[currentStageId.value] ?? 0)
  const canUnlock = computed(() => dailyUsed.value < dailyCap)

  function nextStage() {
    if (!canUnlock.value) return false
    const idx = stages.findIndex((s: any) => s.id === currentStageId.value)
    const nxt = stages[idx + 1]
    if (!nxt) return false

    currentStageId.value = nxt.id
    if (!unlocked.value.includes(nxt.id)) unlocked.value.push(nxt.id)
    dailyUsed.value += 1
    stageProgress.value[nxt.id] = 0
    return true
  }

  function addProgress(n = 10) {
    const id = currentStageId.value
    if (!id) return
    stageProgress.value[id] = Math.min(100, (stageProgress.value[id] || 0) + n)
  }

  function resetDay() {
    dailyUsed.value = 0
  }

  function resetAll() {
    currentStageId.value = stages[0]?.id ?? ''
    unlocked.value = [stages[0]?.id ?? '']
    stageProgress.value = {}
    dailyUsed.value = 0
  }

  return {
    stages,
    current,
    currentStageId,
    unlocked,
    stageProgress,
    dailyUsed,
    dailyCap,
    progress,
    canUnlock,
    nextStage,
    addProgress,
    resetDay,
    resetAll
  }
}
