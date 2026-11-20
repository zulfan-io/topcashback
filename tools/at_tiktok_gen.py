#!/usr/bin/env python3
# Isi affiliate_link NULL di storage/downloads/tiktok.txt via supabase/functions/accesstrade
# (secret Accesstrade di vault env function, BUKAN di kode => aturan vault-only lo).
# Prereq: supabase CLI di PATH + `supabase login` + project linked.
import re,subprocess,os,json
SITE="130054"; CAMP="7568"
TEMPLATE_LANDING="{pid}"   # ubah ke "https://shop.tiktok.com/view/product/{pid}" kalau Accesstrade butuh URL shop
F=os.path.expanduser('~/storage/downloads/tiktok.txt')
lines=open(F,encoding='utf-8').read().splitlines()
pend=[]
for i,l in enumerate(lines):
    if not l.startswith('insert into public.shoper_offers'): continue
    if "'tiktok',true,NULL,7568,NULL," not in l: continue
    m=re.search(r"values \('tiktok',true,NULL,7568,NULL,'([^']*)','([^']*)'",l)
    if m: pend.append((i,m.group(1).replace("''","'"),m.group(2).replace("''","'")))
print('produk butuh link:',len(pend))
def invoke(pid,name,img):
    body=json.dumps({"siteId":SITE,"campaignId":CAMP,"landingUrl":TEMPLATE_LANDING.format(pid=pid),
                     "imageUrl":img or None,"anchorText":name or None})
    try:
        r=subprocess.run(["supabase","functions","invoke","accesstrade","--no-verify-jwt","--body",body],
                         capture_output=True,text=True,timeout=40)
        out=r.stdout.strip()
        j=json.loads(out.splitlines()[-1]) if out else {}
        return j.get("affiliateLink")
    except Exception: return None
ok=0
for k,(i,pid,name) in enumerate(pend,1):
    m=re.search(r"values \('tiktok',true,NULL,7568,NULL,'([^']*)'",lines[i])
    img=m.group(1).replace("''","'") if m else ""
    link=invoke(pid,name,img)
    if link:
        lines[i]=lines[i].replace("'tiktok',true,NULL,7568,NULL,","'tiktok',true,'%s',7568,NULL,"%link,1)
        ok+=1
    if k%25==0:
        open(F,'w',encoding='utf-8').write("\n".join(lines)+"\n"); print('  progress',k,'/',len(pend),'| ok:',ok)
open(F,'w',encoding='utf-8').write("\n".join(lines)+"\n")
print('SELESAI: link ke-isi',ok,'/',len(pend),'=> tiktok.txt FINAL di storage/downloads siap copas ulang.')
