import { supabase } from '~/utils/supabase'

const TIER = { home: 'rekomendasi', laris: 'terlaris', murah: 'termurah', flash: 'flash', baru: 'baru' }

export async function loadTier(key, limit = 12) {
  const { data } = await supabase.from('feed_snapshot')
    .select('*').eq('tier', TIER[key]).order('slot').limit(limit)
  return data || []
}

export async function tap(o, kind) {
  await supabase.rpc('record_event', { p_network: o.network, p_external_id: o.external_id, p_kind: kind })
}

export function share(o) {
  if (navigator.share) navigator.share({ title: o.name, url: o.url }).catch(() => {})
  return tap(o, 'share')
}
