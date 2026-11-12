-- PPOB 1 kesatuan (transfer-duluan). catalog.ts UTUH, NOL disentuh.
create table if not exists public.ppob_products (
  id bigint generated always as identity primary key,
  code text unique not null,
  name text not null,
  category text not null,           -- pulsa|data|pln|pdam|internet
  cost int not null default 0,      -- harga supplier (COGS)
  price int not null,               -- harga jual lo (margin)
  active boolean default true,
  sort int default 0
);
create table if not exists public.ppob_orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  product_code text not null,
  target text not null,             -- no HP / no meter / no pelanggan
  status text not null default 'pending',  -- pending|paid|fulfilled|failed|refund
  payment_ref text, pay_url text, amount int, cost int,
  created_at timestamptz default now()
);
-- READ produk: publik
drop policy if exists ppob_prod_read on public.ppob_products;
create policy ppob_prod_read on public.ppob_products for select to anon, authenticated using (active=true);
-- ORDERS: user lihat & buat miliknya sendiri; update HANYA service-role (edge function)
drop policy if exists ppob_ord_sel on public.ppob_orders;
create policy ppob_ord_sel on public.ppob_orders for select to authenticated using (auth.uid()=user_id);
drop policy if exists ppob_ord_ins on public.ppob_orders;
create policy ppob_ord_ins on public.ppob_orders for insert to authenticated with check (auth.uid()=user_id);
-- seed contoh (harga SAMPLE, owner adjust via dashboard/SQL)
insert into public.ppob_products (code,name,category,cost,price,sort) values
 ('PLS5','Pulsa 5.000','pulsa',5300,6000,1),
 ('PLS10','Pulsa 10.000','pulsa',10300,11000,2),
 ('DATA1','Data 1GB','data',9000,10500,3),
 ('PLN20','Token PLN 20.000','pln',20300,21500,4),
 ('PDAM','Tagihan PDAM','pdam',0,2500,5),
 ('NET','Voucher Internet','internet',8000,9500,6)
on conflict (code) do nothing;
