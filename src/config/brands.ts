export type Brand = { key:string; name:string; sub:string; tagline:string; logo:string; hue:string; ic:string; rate:string; live:boolean; to:string }
export const BRANDS: Brand[] = [
  { key:'shopee', name:'Shopee', sub:'Marketplace harian', tagline:'Belanja harian, cashback balik ke saldo.', logo:'/brands/shopee.svg', hue:'fusion', ic:'store', rate:'70', live:true, to:'/mall' },
  { key:'traveloka', name:'Traveloka', sub:'Atraksi & tiket wisata', tagline:'Jelajah hemat, cashback jalan.', logo:'/brands/traveloka.png', hue:'ocean', ic:'compass', rate:'12,61', live:true, to:'/travel' },
  { key:'trip', name:'Trip.com', sub:'Hotel & penerbangan', tagline:'Tiket & hotel global, promo jalan.', logo:'/brands/trip.svg', hue:'sky', ic:'plane', rate:'3,51', live:true, to:'/trip' },
  { key:'game', name:'UniPin', sub:'Game & voucher digital', tagline:'Top up resmi, bonus kelihatan.', logo:'/brands/game.png', hue:'ocean', ic:'gamepad', rate:'0,6', live:true, to:'/game' },
  { key:'tokopedia', name:'Tokopedia', sub:'Marketplace lokal', tagline:'Penawaran resmi Tokopedia.', logo:'/brands/tokopedia.png', hue:'mint', ic:'store', rate:'24', live:false, to:'/shop/tokopedia' },
  { key:'lazada', name:'Lazada', sub:'Marketplace regional', tagline:'Penawaran resmi Lazada.', logo:'/brands/lazada.jpg', hue:'violet', ic:'store', rate:'70', live:false, to:'/shop/lazada' },
  { key:'blibli', name:'Blibli', sub:'Elektronik & rumah', tagline:'Penawaran resmi Blibli.', logo:'/brands/blibli.svg', hue:'sky', ic:'store', rate:'70', live:false, to:'/shop/blibli' },
  { key:'tiktokshop', name:'TikTok Shop', sub:'Belanja sosial', tagline:'Penawaran resmi TikTok Shop.', logo:'/brands/tiktokshop.svg', hue:'fusion', ic:'tv', rate:'25,23', live:false, to:'/shop/tiktokshop' },
  { key:'bukalapak', name:'Bukalapak', sub:'Warung & UMKM', tagline:'Penawaran resmi Bukalapak.', logo:'/brands/bukalapak.svg', hue:'fusion', ic:'store', rate:'', live:false, to:'/shop/bukalapak' },
  { key:'tiket', name:'tiket.com', sub:'Tiket & atraksi', tagline:'Penawaran resmi tiket.com.', logo:'/brands/tiket.png', hue:'sky', ic:'ticket', rate:'', live:false, to:'/shop/tiket' },
  { key:'klook', name:'Klook', sub:'Atraksi global', tagline:'Penawaran resmi Klook.', logo:'/brands/klook.svg', hue:'fusion', ic:'compass', rate:'7,2', live:false, to:'/shop/klook' },
  { key:'pelago', name:'Pelago', sub:'Wisata pilihan', tagline:'Penawaran resmi Pelago.', logo:'/brands/pelago.png', hue:'ocean', ic:'globe', rate:'5,6', live:false, to:'/shop/pelago' },
]
export const LIVE = BRANDS.filter(b=>b.live)
export const SOON = BRANDS.filter(b=>!b.live)
export function byKey(k:string){ return BRANDS.find(b=>b.key===k) }
export function rateNum(r:string){ const n=parseFloat(String(r||'').replace(',','.')); return isNaN(n)?0:n }
