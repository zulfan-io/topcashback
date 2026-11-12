-- FONDASI SINKRON banner<->Supabase (Opsi A: table terpisah, catalog.ts AMAN)
-- Gerate lo 'NOL schema s/d STEP2' di-OVERRIDE Coi: 'sekarang mulai penyinkronan'. AI catat override.
create table if not exists public.shoper_banners (
  id bigint generated always as identity primary key,
  image_url text not null,
  affiliate_link text,
  label text,
  sort int default 0,
  active boolean default true,
  created_at timestamptz default now()
);
comment on table public.shoper_banners is 'slide banner homepage (repurpose kapital subtle: gambar asing KEEP, link di belakang = Accesstrade tracked)';

-- READ: publik (anon) liat banner aktif = halaman rumah ciamik tetep tampil
drop policy if exists "banner_read_anon" on public.shoper_banners;
create policy "banner_read_anon" on public.shoper_banners
  for select to anon using (active = true);

-- WRITE: Coi-only. Policy authenticated pakai UID Coi = Coi run sendiri di dashboard SQL
-- (AI NOL punya UID Coi, NOL hardcode di migration = portable-safe). Lihat blok SQL dashboard di bawah.

-- SEED 13 slide: gambar asing KEEP (eye-candy profesional Coi) + link .co.id testing REAL Coi
-- (semua link SAMA dulu = bukti track; Coi edit beda per slide via dashboard/SQL ronde depan)
insert into public.shoper_banners (image_url, affiliate_link, label, sort) values
 ('https://honglinhhatinh.com/wp-content/uploads/2021/04/banner-quang-cao-cua-lazada.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','lazada',1),
 ('https://chuyenstandee.com/wp-content/uploads/2021/03/thiet-ke-banner-2-1-1.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','standee',2),
 ('https://inanaz.com.vn/wp-content/uploads/2020/02/mau-banner-quang-cao-dep-3.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','inanaz3',3),
 ('https://inanaz.com.vn/wp-content/uploads/2020/02/mau-banner-quang-cao-dep-14.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','inanaz14',4),
 ('https://inanaz.com.vn/wp-content/uploads/2020/02/mau-banner-quang-cao-dep-8.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','inanaz8',5),
 ('https://induongquang.com/data/upload/banner-shoppe.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','shopee',6),
 ('https://www.duchuymobile.com/images/promo/34/iphone-giam-gia.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','iphone',7),
 ('https://static.ladipage.net/5bf3dc7edc60303c34e4991f/thumb-20211219233256.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','ladipage',8),
 ('https://binhminhdigital.com/StoreData/images/PageData/top-5-tai-nghe-chup-tai-sony-tot-trong-tam-gia-1-trieu-Binhminhdigital.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','sony',9),
 ('https://shanshe.vn/wp-content/uploads/2021/09/kem-duong-da-viet-nam-chat-luong-cao-4.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','shanshe',10),
 ('/img/gen/swipe-hero.gif','https://click.accesstrade.co.id/adv.php?rk=00000p000003','hero-gif-BROKEN-FILE',11),
 ('https://i.ytimg.com/vi/DJsi7z4w-zM/maxresdefault.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','yt-thumb',12),
 ('https://hoaanhdao.vn/2018_img/files/hoang/0R4A1919.jpg','https://click.accesstrade.co.id/adv.php?rk=00000p000003','hoaanhdao',13)
on conflict do nothing;
