<script setup>
import { useRouter } from 'vue-router'
import { useAdmin } from '~/stores/admin'
import AuthRequest from '~/services/auth-request'

const admin = useAdmin()
const router = useRouter()

const adminAvatar = ref('/img/admin/avatar_sample.png')

const signOut = async() => {
  await AuthRequest.logoutAdmin().then(() => {
    localStorage.removeItem('token')
    localStorage.removeItem('admin')
    router.push({ path: '/admin/login' })
  })
}

</script>

<template>
  <main class="text-gray-700 dark:text-gray-200 overflow-x-hidden">
    <SHead />
    <div class="bg-[#F6F6F6] flex dark:bg-black">
      <div class="w-100 bg-white px-3">
        <div class="flex justify-end text-gray-400 hover:text-black cursor-pointer py-1">
          <IEdit />
        </div>
        <div class="flex justify-center py-10 px-5">
          <img :src="adminAvatar" alt="avatar" width="226" height="226" class="rounded-full shadow-light-800 shadow-md">
        </div>
        <div class="flex justify-center">
          <h2 class="font-semibold text-xl">
            Hi, {{ admin.payget.email }}!
          </h2>
        </div>
        <div class="grid grid-cols-4 items-center gap-2">
          <div class="text-white flex justify-around items-center border-1 border-solid border-gray rounded-lg col-span-3 cursor-pointer py-2 bg-[#00C689] hover:(bg-transparent text-gray-500) duration-200 shadow-md shadow-gray-200">
            <img :src="adminAvatar" alt="avatar" width="40" height="40" class="rounded-full shadow-light-800 shadow-md">
            <div>
              <h4>{{ admin.payget.username }}</h4>
              <p class="text-xs opacity-60">
                Logged in successfully!
              </p>
            </div>
          </div>
          <div class="text-gray-400 text-xl font-bold flex justify-center items-center border-2 border-solid border-gray rounded-lg col-span-1 h-full cursor-pointer hover:(bg-[#00C689] text-white) duration-200 shadow-md shadow-gray-200" @click="signOut">
            <ILogout />
          </div>
        </div>
        <nav class="admin-menu">
          <router-link to="/admin/dashboard" active-class="am-on" class="am-item"><span class="am-ic">▦</span> Dashboard</router-link>
          <router-link to="/admin/affiliate" active-class="am-on" class="am-item"><span class="am-ic">🔗</span> Affiliate CRUD</router-link>
          <router-link to="/admin/category/attributes" active-class="am-on" class="am-item"><span class="am-ic">☰</span> Kategori</router-link>
          <router-link to="/admin/account/reset" active-class="am-on" class="am-item"><span class="am-ic">↺</span> Reset</router-link>
        </nav>
      </div>
      <div class="flex justify-center w-full p-3">
        <router-view />
      </div>
    </div>
  </main>
</template>

<style scoped>
.admin-menu{ display:flex; flex-direction:column; gap:6px; padding:12px 8px 4px; margin-top:10px; border-top:1px solid #eee; }
.am-item{ display:flex; align-items:center; gap:8px; padding:9px 12px; border-radius:10px; font-size:13px; font-weight:600; color:#666; text-decoration:none; transition:background .15s, color .15s, transform .15s; }
.am-item:active{ transform:scale(.98); }
.am-item.am-on{ background:#FFF3E9; color:#FF7A45; }
.am-ic{ font-size:15px; width:18px; text-align:center; }
</style>
