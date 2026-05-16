-- Kitabu Database Schema
-- Run this first in Supabase SQL Editor

-- ── Categories ────────────────────────────────────────────────────────────────
create table if not exists categories (
  id          serial primary key,
  slug        text not null unique,
  name        text not null,
  icon        text not null default '📚',
  color       text not null default '#C0532B',
  book_count  int not null default 0,
  created_at  timestamptz not null default now()
);

-- ── Books ──────────────────────────────────────────────────────────────────────
create table if not exists books (
  id              serial primary key,
  slug            text not null unique,
  title           text not null,
  author          text not null,
  description     text not null default '',
  category        text not null references categories(slug),
  rating          numeric(3,1) not null default 4.0,
  review_count    int not null default 0,
  page_count      int not null default 200,
  is_free         boolean not null default false,
  digital_price   numeric(10,2) not null default 0,
  physical_price  numeric(10,2),
  cover_url       text,
  language        text not null default 'English',
  published_year  int,
  publisher       text,
  tags            text[] not null default '{}',
  created_at      timestamptz not null default now()
);

-- ── Library (user's digital shelf) ───────────────────────────────────────────
create table if not exists library (
  id              serial primary key,
  user_id         uuid not null default '00000000-0000-0000-0000-000000000001',
  book_id         int not null references books(id),
  read_progress   numeric(4,3) not null default 0,
  added_at        timestamptz not null default now(),
  last_read_at    timestamptz,
  unique(user_id, book_id)
);

-- ── Requests ──────────────────────────────────────────────────────────────────
create table if not exists requests (
  id          serial primary key,
  user_id     uuid not null default '00000000-0000-0000-0000-000000000001',
  title       text not null,
  author      text not null default '',
  note        text not null default '',
  status      text not null default 'pending'
              check (status in ('pending','in_review','sourcing','available','unavailable')),
  created_at  timestamptz not null default now()
);

-- ── Request Events (timeline) ─────────────────────────────────────────────────
create table if not exists request_events (
  id          serial primary key,
  request_id  int not null references requests(id) on delete cascade,
  status      text not null
              check (status in ('pending','in_review','sourcing','available','unavailable')),
  note        text not null default '',
  created_at  timestamptz not null default now()
);

-- ── Orders ────────────────────────────────────────────────────────────────────
create table if not exists orders (
  id                  serial primary key,
  user_id             uuid not null default '00000000-0000-0000-0000-000000000001',
  book_id             int not null references books(id),
  quantity            int not null default 1,
  total_price         numeric(10,2) not null,
  status              text not null default 'processing'
                      check (status in ('processing','shipped','delivered','cancelled')),
  tracking_number     text,
  estimated_delivery  date,
  shipping_address    text,
  created_at          timestamptz not null default now()
);

-- ── Order Steps (fulfillment timeline) ───────────────────────────────────────
create table if not exists order_steps (
  id           serial primary key,
  order_id     int not null references orders(id) on delete cascade,
  label        text not null,
  completed_at timestamptz
);

-- ── Row Level Security ────────────────────────────────────────────────────────
alter table categories     enable row level security;
alter table books          enable row level security;
alter table library        enable row level security;
alter table requests       enable row level security;
alter table request_events enable row level security;
alter table orders         enable row level security;
alter table order_steps    enable row level security;

-- Public read access for catalog data
create policy "Public read categories"     on categories     for select using (true);
create policy "Public read books"          on books          for select using (true);
create policy "Public read library"        on library        for select using (true);
create policy "Public read requests"       on requests       for select using (true);
create policy "Public read request_events" on request_events for select using (true);
create policy "Public read orders"         on orders         for select using (true);
create policy "Public read order_steps"    on order_steps    for select using (true);
