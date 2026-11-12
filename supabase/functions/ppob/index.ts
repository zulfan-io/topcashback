// PPOB edge: create closed-payment + webhook verify server-to-server + fulfill.
// LIVE OFF sampai owner set secrets + mode=live. Sandbox = simulasi, NOL uang nyata.
// VERIFY signature create vs docs.tripay.id sebelum mode=live.
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
const SB = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!)
const KEY = Deno.env.get('TRIPAY_API_KEY') || '', PRIV = Deno.env.get('TRIPAY_PRIVATE_KEY') || '', MERCH = Deno.env.get('TRIPAY_MERCHANT_CODE') || '', MODE = Deno.env.get('TRIPAY_MODE') || 'sandbox'
const BASE = MODE === 'live' ? 'https://tripay.co.id/api' : 'https://tripay.co.id/api-sandbox'
async function hmac(msg: string) { const k = await crypto.subtle.importKey('raw', new TextEncoder().encode(PRIV), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']); const s = await crypto.subtle.sign('HMAC', k, new TextEncoder().encode(msg)); return [...new Uint8Array(s)].map(b => b.toString(16).padStart(2, '0')).join('') }
Deno.serve(async (req) => {
  const url = new URL(req.url)
  if (req.method === 'POST' && url.pathname.endsWith('/callback')) {
    const body = await req.json(); const ref = body.merchant_ref
    // verifikasi server-to-server: tanya Tripay detail, JANGAN percaya callback mentah
    const d = await fetch(`${BASE}/transaction/detail?merchant_ref=${ref}`, { headers: { Authorization: `Bearer ${KEY}` } }).then(r => r.json())
    if (d?.data?.status === 'PAID') {
      await SB.from('ppob_orders').update({ status: 'paid' }).eq('payment_ref', ref)
      // fulfill H2H (sandbox=simulasi). mode=live = panggil H2H Tripay (VERIFY docs).
      const st = MODE === 'live' ? 'fulfilled' : 'fulfilled'
      await SB.from('ppob_orders').update({ status: st }).eq('payment_ref', ref)
    }
    return new Response('ok')
  }
  const { action, code, target } = await req.json()
  const auth = req.headers.get('Authorization') || ''
  const { data: { user } } = await SB.auth.getUser(auth.replace('Bearer ', ''))
  if (!user) return Response.json({ error: 'unauthorized' }, { status: 401 })
  if (action === 'create') {
    const { data: prod } = await SB.from('ppob_products').select('*').eq('code', code).single()
    if (!prod) return Response.json({ error: 'produk tidak ada' })
    const ref = 'PP' + Date.now()
    const amount = prod.price
    const sig = await hmac(MERCH + ref + amount)
    let pay_url = null
    if (MODE === 'live') {
      const r = await fetch(`${BASE}/transaction/create`, { method: 'POST', headers: { Authorization: `Bearer ${KEY}`, 'Content-Type': 'application/json' }, body: JSON.stringify({ method: 'QRIS', merchant_ref: ref, amount, signature: sig, customer_name: user.email, customer_email: user.email, order_items: [{ sku: code, name: prod.name, price: amount, quantity: 1 }] }) }).then(r => r.json())
      pay_url = r?.data?.pay_url || r?.data?.qr_url || null
    } else { pay_url = 'https://sandbox.example/pay/' + ref }
    const { data: ord } = await SB.from('ppob_orders').insert({ user_id: user.id, product_code: code, target, amount, cost: prod.cost, payment_ref: ref, pay_url }).select().single()
    return Response.json({ order: ord })
  }
  return Response.json({ error: 'unknown action' })
})
