-- ===========================================================================
-- Kitabu admin - database schema (v2)
-- Drops and recreates the books table with the updated field structure.
-- Run this in the Supabase dashboard -> SQL Editor before running
-- upload_data.py. Storage buckets are created by the script automatically.
-- ===========================================================================

create extension if not exists pgcrypto;

-- ---- cleanup -----------------------------------------------------------------
drop policy   if exists "Public can read published books" on public.books;
drop policy   if exists "Public can read all books"       on public.books;
drop index    if exists books_language_idx;
drop index    if exists books_status_idx;
drop index    if exists books_featured_idx;
drop index    if exists books_category_idx;
drop index    if exists books_year_idx;
drop index    if exists books_is_free_idx;
drop table    if exists public.books cascade;

-- ---- new table ---------------------------------------------------------------
create table public.books (
    id              uuid          primary key default gen_random_uuid(),
    title           text          not null,
    author          text,
    description     text,
    year            integer,
    category        text,
    tags            text[],
    is_free         boolean       not null default false,
    price           numeric(12,2),
    discount_price  numeric(12,2),
    file_url        text,
    file_format     text,
    is_downloadable boolean       not null default false,
    file_size       bigint        not null default 0,
    cover_url       text,
    page_count      integer       not null default 0,
    view_count      integer       not null default 0,
    download_count  integer       not null default 0,
    uploaded_at     timestamptz   not null default now(),
    created_at      timestamptz   not null default now(),
    updated_at      timestamptz   not null default now(),
    constraint books_title_author_key unique (title, author)
);

create index books_category_idx on public.books (category);
create index books_year_idx     on public.books (year);
create index books_is_free_idx  on public.books (is_free);

-- ---- row-level security ------------------------------------------------------
alter table public.books enable row level security;

create policy "Public can read all books"
    on public.books for select
    using (true);
