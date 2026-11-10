#  LEGODONE - status kanonik (privat $HOME, git buta)
> Renderer = legodone.sh. Centang=niat; byte/commit=bukti.

## [OK] TERBUKTI BYTE
- ☑ cashflow: diabelanja global; boot diam+poll-curl JUJUR; GERBANG A 560a9a1; 18lem->pipa be546a7.
- ☑ ImageKilat + rename_gen SRC diarahin ke downloads/ImageKilat.
- ☑ SUPABASE GATE R: GRANT SELECT anon+policy+seed => anon_bisa_baca=3. Frontend anon BISA baca.
- ☑ PALET FUSION: joy FF7A45/action FF4D3D/alarm E63946/penyejuk 00B8A9/krem FFF7EC. HARAM EE4D2D.
- ☑ ACCESSTRADE doc: Campaign+LinkGen+Report ADA => [PEGANG] lama MISREAD. Mapper 11/11.
- ☑ MULTI-AFFILIATE: network=colokan netral; adapter 5-metode; meta_json=kantong. +affiliate=+1 file.
- ☑ FRIDA: BLOK 28/29/30 firing; marquee 24b-24h kelar; dock+vault+pipa downloads.
- ☑ GUNUNG3 SEO mendarat (lo 1 malam): CF build b6b2ad1 Success 716 file, .html ke-prerender.
- ☑ GUNUNG1 skema FINAL (M1): 11 kolom kebukti.
- ☑ GUNUNG8 sosmed: sc1 MENANG; primitif+backend shoper_status/loves/shares ADA => PARALEL.

## [!!] GATE OPEN (keliatan kelar, sebenernya bolong)
- ☐ rename_gen v2 BELUM ast.parse.
- ☐ convert.py cashflow BELUM ada.
- ☐ 🔴 ffmpeg TIDAK terpasang (^C 13%) => slot gerak DIEM tanpa error.
- ☐ 1.mp4 hero SUDAH digenerate tapi BELUM diproses/drop.
- ☐ 🔴 18 pipa /img/gen = 404 SAMPAI berkas di-drop.
- ☐ 🔴 KOTAK HITAM HERO penyebab BELUM teridentifikasi (bukan di daftar 18).
- ☐ 🔴 RLS M2/M3b breakdown BELUM lapor (anon=3 tau HASIL bukan MEKANISME).
- ☐ GENERASI 40 aset: cuma 1 (mp4); kursi 2-40 BELUM.
- ☐ 🔴 FRIDA YATIM catch/try = jahitan rapuh; ZERO-TOUCH larang nambal.
- ☐ 🔴 FRIDA CONVERT: re-probe anchor LIVE; Lottie=.json => ffmpeg MUSTAHIL.

## [GO] NEXT
- ☐ 🟢 UI-DULU: buktiin 3 seed nongol di frontend (anon); grep duality read-only dulu.
- ☐ 🟡 pilih WADAH A(kartu click-out)|B(floating) => mapper C 11/11.
- ☐ quack-fire-2d (codespace ada).

## NGEOLOG
- 2026-10-31 03:16 :: [cashflowku] 2f9bc5f fix(render): / = duality langsung; buang index shopee + router.replace (biang keredip)

## GUNUNG 9 — SIM 3-IN-1 (dating x sim x social-commerce) · canang Coi 2026-11-10
> Upgrade terbesar = KETAMBAHAN SIMULASI. INDUK nelen GUNUNG 8 jadi 1 layer commerce. NOL clone aset Tinder/Bumble/IG/Shopee — orisinal, feel doang, palet Fusion = jangkar visual.

### FASE 0 — UI/UX SHELL (WAJIB DULU, NOL logic/store/API)
- ☐ src/pages/sim/ file-based: /sim /sim/match /sim/stage /sim/wallet /sim/profile
- ☐ design token = palet Fusion (FF7A45/FF4D3D/E63946/00B8A9/FFF7EC), spring, 8px grid, typo 4-level
- ☐ component orisinal: SimCard SwipeDeck PresenceDot StageBadge WalletChip SocialRail
- ☐ PresenceDot semua avatar: hijau/abu/oranye, 8px pojok kb, pulse 2s
- ☐ SwipeDeck = drag 40% fly-out spring undo-ghost (feel Tinder), visual orisinal radius 24px mesh
- ☐ stage = stub 1 set dummy dulu (theme beneran = FASE 2); social rail = IG elegance; commerce = Shopee density + widget scarcity 1-baris-12-slot-kepotong

### FASE 1 — MATCHING (fixture-first)
- ☐ stores/simMatch.ts: deck currentIdx swipeHistory matchQueue
- ☐ kanan=like→mutual→confetti-micro; kiri=pass; atas=super-like; undo 1x/session
- ☐ 🟡 mechanic final = Tinder swipe + Bumble presence-dot (dot WAJIB, kagak ada di Tinder)
- ☐ 🔴 super-like/undo money-gated tapi wallet=FASE 3 → FASE 1 jalan moneyGated=false, NOL blokir test
- ☐ 🔴 PresenceDot realtime Supabase = boros battery → debounce 3s + fallback poll 30s, NOL hard-depend
- ☐ mock src/data/simProfiles.json 10 profil, API-ready tapi fixture

### FASE 2 — STAGE (simulasi hidup)
- ☐ stores/simStage.ts: currentStageId unlocked stageProgress dailyLimit
- ☐ stage = world pack theme.json + rules.json (swipe-limit badge-cost unlock-cond)
- ☐ naik = condition-based (bukan timer); badge TERBATAS/hari dailyCap reset 00:00 UTC counter di WalletChip
- ☐ badge = pansos: pin profil + social feed + toast unlocked; rekursif Stage3+ mini-game dalem stage
- ☐ 🔴 ambient auto-play = diblok browser + cache SW bengkak → opt-in lazy

### FASE 3 — WALLET (semua lewat money digital)
- ☐ stores/simWallet.ts: balance txLog pendingReward
- ☐ SEMUA badge/progress/undo/super-like = cost, NOL free path; top-up Midtrans/Xendit sandbox
- ☐ earn = affiliate click-out (shoper) + social bonus (love/share > threshold); WalletChip header selalu visible
- ☐ anti-inflation: cost scale per stage (S1 10k S5 100k), dailyCap ketat

### FASE 4 — COMMERCE 3-IN-1 satu napas
- ☐ social post sisip produk affiliate (reuse CGiftRow) tap→out-link tracked
- ☐ stage reward = voucher pulsa/marketplace (reuse ports.json)
- ☐ commerce card profil = "dia lagi beli apa" privacy opt-in; match celebration = coupon pair
- ☐ 🔴 coupon-pair tanpa port (ports.json = rel eksternal) → reuse voucher ATAU +1 rel, NOL di luar port-colok
- ☐ NOL nyentuh duality.vue / list.vue (aturan GUNUNG 8)

### FASE 5 — POLISH & DEPLOY
- ☐ motion audit semua spring NOL linear; dark/light adaptif per stage; lazy-load + prefetch next-stage
- ☐ a11y swipe alt=button + PresenceDot aria-label; deploy via CI commit=auto NOL manual
- ☐ PWA start_url=/sim display=standalone icon keranjang (fix udah lo tembak ronde CI)

### GERGATE GUNUNG 9
- FASE 0→1→2→3→4→5 NOL lompat; NOL sentuh GUNUNG 3 SSR sampai FASE 0 nongol di browser; NOL sentuh APK/vendor sampai FASE 5; NOL sentuh GUNUNG 8 duality/list kecuali lewat port.
