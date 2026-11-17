import { supabase } from '~/utils/supabase'
const K='shop_anon_id'
let mem=''
function anon(){
  if(mem)return mem
  try{mem=localStorage.getItem(K)||''}catch(_){}
  if(!mem){mem='a'+Date.now().toString(36)+Math.random().toString(36).slice(2,8);try{localStorage.setItem(K,mem)}catch(_){}}
  return mem
}
const sent=new Set<string>()
export function useTrack(){
  async function track(kind:string,p:{network?:string;offer_id?:string;path?:string;meta?:any}={},once=false){
    const key=kind+':'+(p.offer_id||p.network||p.path||'')
    if(once){if(sent.has(key))return;sent.add(key)}
    try{
      const {data}=await supabase.auth.getSession()
      await supabase.from('app_events').insert({
        uid:data.session?.user?.id||null, anon_id:anon(), kind,
        network:p.network||null, offer_id:p.offer_id||null,
        path:p.path||(typeof location!=='undefined'?location.pathname:null),
        meta:p.meta||{}
      })
    }catch(_){}
  }
  return { track }
}
