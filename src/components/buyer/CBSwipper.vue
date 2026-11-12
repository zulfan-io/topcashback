<script setup>
import { supabase } from '~/utils/supabase'
const FALLBACK = [
  {src:'https://honglinhhatinh.com/wp-content/uploads/2021/04/banner-quang-cao-cua-lazada.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'lazada'},
  {src:'https://chuyenstandee.com/wp-content/uploads/2021/03/thiet-ke-banner-2-1-1.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'standee'},
  {src:'https://inanaz.com.vn/wp-content/uploads/2020/02/mau-banner-quang-cao-dep-3.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'inanaz3'},
  {src:'https://inanaz.com.vn/wp-content/uploads/2020/02/mau-banner-quang-cao-dep-14.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'inanaz14'},
  {src:'https://inanaz.com.vn/wp-content/uploads/2020/02/mau-banner-quang-cao-dep-8.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'inanaz8'},
  {src:'https://induongquang.com/data/upload/banner-shoppe.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'shopee'},
  {src:'https://www.duchuymobile.com/images/promo/34/iphone-giam-gia.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'iphone'},
  {src:'https://static.ladipage.net/5bf3dc7edc60303c34e4991f/thumb-20211219233256.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'ladipage'},
  {src:'https://binhminhdigital.com/StoreData/images/PageData/top-5-tai-nghe-chup-tai-sony-tot-trong-tam-gia-1-trieu-Binhminhdigital.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'sony'},
  {src:'https://shanshe.vn/wp-content/uploads/2021/09/kem-duong-da-viet-nam-chat-luong-cao-4.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'shanshe'},
  {src:'/img/gen/swipe-hero.gif',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'hero-gif-BROKEN-FILE'},
  {src:'https://i.ytimg.com/vi/DJsi7z4w-zM/maxresdefault.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'yt-thumb'},
  {src:'https://hoaanhdao.vn/2018_img/files/hoang/0R4A1919.jpg',link:'https://click.accesstrade.co.id/adv.php?rk=00000p000003',label:'hoaanhdao'},
]
const banners = ref(FALLBACK)  // fallback hardcode = banner SELALU tampil walau Supabase kosong/error
const timer = ref(null)
const currentIndex = ref(0)

const currentImg = computed(() => {
  return banners.value[Math.abs(currentIndex.value) % banners.value.length]
})

const next = setInterval(() => {
  currentIndex.value += 1
}, 4000)
const prev = () => {
  currentIndex.value -= 1
}

function openBanner(s) {
  try {
    const log = JSON.parse(localStorage.getItem('banner_track') || '[]')
    log.push({ t: Date.now(), src: s.src, link: s.link, label: s.label })
    localStorage.setItem('banner_track', JSON.stringify(log.slice(-200)))
  } catch (e) {}
  if (s && s.link) window.open(s.link, '_blank', 'noopener')
}

onMounted(async () => {
  try {
    const { data } = await supabase.from('shoper_banners').select('image_url,affiliate_link,label,sort').eq('active', true).order('sort')
    if (data && data.length) banners.value = data.map(r => ({ src: r.image_url, link: r.affiliate_link, label: r.label }))
  } catch (e) {}  // Supabase paused/error = fallback hardcode tetep jalan (NOL rusak rumah)
})
</script>

<template>
  <div class="swipper-container min-w-screen-md h-150">
    <transition-group name="fade" tag="div">
      <div v-for="i in [currentIndex]" :key="i">
        <img :src="currentImg.src" @click="openBanner(currentImg)" style="cursor:pointer">
      </div>
    </transition-group>
    <a class="prev" href="#" @click="prev">&#10094;</a>
    <a class="next" href="#" @click="next">&#10095;</a>
  </div>
</template>
<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: all 0.9s ease;
  overflow: hidden;
  visibility: visible;
  position: absolute;
  width:100%;
  opacity: 1;
}

.fade-enter,
.fade-leave-to {
  visibility: hidden;
  width:100%;
  opacity: 0;
}

img {
  height:600px;
  width:100%
}

.prev, .next {
  cursor: pointer;
  position: absolute;
  top: 50%;
  width: 3rem;
  height: 3rem;
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
  font-weight: bold;
  font-size: 18px;
  transition: 0.7s ease;
  border-radius: 50%;
  text-decoration: none;
  user-select: none;
}

.next {
  right: 1rem;
}

.prev {
  left: 1rem;
}

.prev:hover, .next:hover {
  background-color: rgba(0,0,0,0.9);
}
@media (max-width: 1024px){
  transition-group{
    height: 30rem;
  }
}
</style>
