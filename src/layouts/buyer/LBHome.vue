<template>
  <main class="text-center text-gray-700 dark:(text-gray-200 bg-$dark-bg) overflow-x-hidden">
    <CBHeaderTop />
    <CBHead />
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
    <CBFooter />
  </main>
</template>

<style scoped>
@media (max-width: 992px){
  .header-home{
    display: none;
  }
}

.fade-enter-active, .fade-leave-active { transition: opacity .28s cubic-bezier(.22,1,.36,1), transform .28s cubic-bezier(.22,1,.36,1); }
.fade-enter-from { opacity:0; transform: translateY(8px) scale(.985); }
.fade-leave-to { opacity:0; transform: translateY(-6px) scale(.99); }
@media (prefers-reduced-motion: reduce){ .fade-enter-active,.fade-leave-active{ transition:opacity .12s; } .fade-enter-from,.fade-leave-to{ transform:none; } }
</style>
