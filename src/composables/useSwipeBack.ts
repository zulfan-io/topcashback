import { onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
export function useSwipeBack(){
  const r=useRouter(); let sx=0,sy=0,on=false
  const ts=(e:TouchEvent)=>{const t=e.touches[0]; if(t.clientX<28){on=true;sx=t.clientX;sy=t.clientY}else on=false}
  const te=(e:TouchEvent)=>{if(!on)return;const t=e.changedTouches[0];const dx=t.clientX-sx,dy=Math.abs(t.clientY-sy); if(dx>70&&dy<50)r.back(); on=false}
  onMounted(()=>{addEventListener('touchstart',ts,{passive:true});addEventListener('touchend',te,{passive:true})})
  onUnmounted(()=>{removeEventListener('touchstart',ts);removeEventListener('touchend',te)})
}
