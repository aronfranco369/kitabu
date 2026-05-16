-- Kitabu Seed Data
-- Run AFTER schema.sql

-- ── Categories ────────────────────────────────────────────────────────────────
insert into categories (slug, name, icon, color, book_count) values
  ('fiction',     'Fiction',     '📖', '#C0532B', 9),
  ('historical',  'Historical',  '🏛️', '#1A3A5C', 2),
  ('thriller',    'Thriller',    '🔍', '#6B4C8A', 3),
  ('non-fiction', 'Non-Fiction', '📚', '#2E7D4E', 2),
  ('education',   'Education',   '🎓', '#B8723A', 1),
  ('biography',   'Biography',   '👤', '#8A3A4A', 0)
on conflict (slug) do nothing;

-- ── Books ──────────────────────────────────────────────────────────────────────
insert into books (slug, title, author, description, category, rating, review_count, page_count, is_free, digital_price, physical_price, language, published_year, publisher, tags) values
('things-fall-apart', 'Things Fall Apart', 'Chinua Achebe',
 'A seminal African novel that follows Okonkwo, a respected warrior in the Ibo tribe of Nigeria, and the disruption of his life when Christian missionaries arrive.',
 'fiction', 4.7, 3842, 209, true, 0.00, 850.00, 'English', 1958, 'Heinemann',
 ARRAY['african literature', 'colonialism', 'classic', 'nigeria']),

('weep-not-child', 'Weep Not, Child', 'Ngũgĩ wa Thiong''o',
 'The first novel published in English by an East African author. Set during Kenya''s struggle for independence.',
 'fiction', 4.5, 1203, 154, false, 450.00, 1200.00, 'English', 1964, 'Heinemann',
 ARRAY['kenya', 'independence', 'east africa', 'coming of age']),

('purple-hibiscus', 'Purple Hibiscus', 'Chimamanda Ngozi Adichie',
 'A powerful story of adolescence and redemption in post-colonial Nigeria.',
 'fiction', 4.6, 2891, 307, false, 550.00, 1450.00, 'English', 2003, 'Algonquin Books',
 ARRAY['nigeria', 'family', 'religion', 'coming of age']),

('half-of-a-yellow-sun', 'Half of a Yellow Sun', 'Chimamanda Ngozi Adichie',
 'Set during the Nigerian Civil War of the 1960s, this novel follows the lives of three characters through the tragedy of the Biafran conflict.',
 'fiction', 4.8, 4521, 433, false, 650.00, 1650.00, 'English', 2006, 'Knopf',
 ARRAY['nigeria', 'civil war', 'biafra', 'historical']),

('river-between', 'The River Between', 'Ngũgĩ wa Thiong''o',
 'Two rival Gikuyu ridges stand on either side of a river in Kenya. Waiyaki tries to bridge the divide between tradition and progress.',
 'fiction', 4.3, 876, 152, true, 0.00, 950.00, 'English', 1965, 'Heinemann',
 ARRAY['kenya', 'tradition', 'colonialism', 'gikuyu']),

('season-of-migration', 'Season of Migration to the North', 'Tayeb Salih',
 'Often called the most important Arabic novel of the 20th century. A Sudanese man returns from England to find a mysterious stranger.',
 'fiction', 4.4, 1567, 139, false, 400.00, 1100.00, 'English', 1966, 'NYRB Classics',
 ARRAY['sudan', 'postcolonial', 'arabic literature', 'classic']),

('god-small-things', 'The God of Small Things', 'Arundhati Roy',
 'A story about the childhood experiences of fraternal twins Rahel and Estha in Ayemenem, India.',
 'fiction', 4.7, 5123, 321, false, 600.00, 1500.00, 'English', 1997, 'Random House',
 ARRAY['india', 'caste', 'family', 'booker prize']),

('petals-blood', 'Petals of Blood', 'Ngũgĩ wa Thiong''o',
 'Set in post-independence Kenya, this ambitious novel follows four residents of the small village of Ilmorog.',
 'fiction', 4.4, 987, 345, false, 500.00, 1350.00, 'English', 1977, 'Heinemann',
 ARRAY['kenya', 'neo-colonialism', 'corruption', 'marxist']),

('chiefs-daughter', 'The Chief''s Daughter', 'Seun Coker',
 'A gripping thriller set in contemporary Lagos. Detective Amaka Osei navigates politics, crime, and traditional power structures.',
 'thriller', 4.2, 643, 278, false, 480.00, 1200.00, 'English', 2021, 'Cassava Republic',
 ARRAY['nigeria', 'thriller', 'lagos', 'detective']),

('homegoing', 'Homegoing', 'Yaa Gyasi',
 'Beginning with two half-sisters in 18th-century Ghana, each chapter follows successive generations across 300 years.',
 'historical', 4.8, 6789, 300, false, 700.00, 1750.00, 'English', 2016, 'Knopf',
 ARRAY['ghana', 'slavery', 'diaspora', 'historical']),

('americanah', 'Americanah', 'Chimamanda Ngozi Adichie',
 'Ifemelu and Obinze are young and in love in Lagos. When Ifemelu leaves for America, she must navigate race, identity, and belonging.',
 'fiction', 4.6, 3421, 477, false, 600.00, 1600.00, 'English', 2013, 'Knopf',
 ARRAY['nigeria', 'race', 'diaspora', 'america']),

('famished-road', 'The Famished Road', 'Ben Okri',
 'Azaro is a spirit child who straddles the worlds of the living and the dead in 1950s Nigeria.',
 'fiction', 4.3, 1102, 500, false, 550.00, 1400.00, 'English', 1991, 'Jonathan Cape',
 ARRAY['nigeria', 'magical realism', 'booker prize', 'spirit world']),

('dust-on-wind', 'Dust on the Wind', 'Meja Mwangi',
 'Set in Nairobi during the turbulent post-independence era, this thriller follows Jack Zollo.',
 'thriller', 4.1, 423, 214, true, 0.00, 900.00, 'English', 1979, 'Longman',
 ARRAY['kenya', 'nairobi', 'urban', 'thriller']),

('arrow-god', 'Arrow of God', 'Chinua Achebe',
 'The chief priest Ezeulu leads the Ibo clan of Umuaro. When colonial authorities try to co-opt him, his resistance brings crisis.',
 'historical', 4.5, 1876, 230, false, 450.00, 1100.00, 'English', 1964, 'Heinemann',
 ARRAY['nigeria', 'colonialism', 'religion', 'ibo']),

('pedagogy-oppressed', 'Pedagogy of the Oppressed', 'Paulo Freire',
 'An influential work in critical pedagogy that challenges traditional education''s banking model.',
 'education', 4.6, 4231, 183, true, 0.00, 1050.00, 'English', 1968, 'Herder and Herder',
 ARRAY['education', 'critical theory', 'liberation', 'pedagogy']),

('coloniser-colonised', 'The Colonizer and the Colonized', 'Albert Memmi',
 'A seminal text in postcolonial theory examining the psychological portrait of both colonizer and colonized.',
 'non-fiction', 4.4, 892, 164, false, 420.00, 1050.00, 'English', 1957, 'Beacon Press',
 ARRAY['postcolonial', 'theory', 'north africa', 'identity']),

('nairobi-heat', 'Nairobi Heat', 'Mukoma wa Ngugi',
 'American detective Ishmael and Kenyan cop David Odhiambo team up to solve a murder linking two continents.',
 'thriller', 4.0, 312, 188, false, 430.00, 1100.00, 'English', 2009, 'Melville House',
 ARRAY['kenya', 'thriller', 'detective', 'diaspora']),

('decolonising-mind', 'Decolonising the Mind', 'Ngũgĩ wa Thiong''o',
 'Ngugi''s manifesto on the importance of African languages and the psychological injury of colonialism.',
 'non-fiction', 4.7, 2145, 114, true, 0.00, 800.00, 'English', 1986, 'James Currey',
 ARRAY['africa', 'language', 'colonialism', 'theory'])
on conflict (slug) do nothing;

-- ── Library entries ───────────────────────────────────────────────────────────
insert into library (book_id, read_progress, added_at, last_read_at)
select id, 0.65, '2025-03-10', '2025-05-14' from books where slug = 'things-fall-apart'
on conflict do nothing;

insert into library (book_id, read_progress, added_at, last_read_at)
select id, 1.0, '2025-02-20', '2025-03-05' from books where slug = 'purple-hibiscus'
on conflict do nothing;

insert into library (book_id, read_progress, added_at, last_read_at)
select id, 0.32, '2025-04-01', '2025-05-10' from books where slug = 'americanah'
on conflict do nothing;

insert into library (book_id, read_progress, added_at, last_read_at)
select id, 0.88, '2025-01-15', '2025-04-28' from books where slug = 'pedagogy-oppressed'
on conflict do nothing;

insert into library (book_id, read_progress, added_at, last_read_at)
select id, 0.12, '2025-05-01', '2025-05-13' from books where slug = 'decolonising-mind'
on conflict do nothing;

-- ── Requests ──────────────────────────────────────────────────────────────────
insert into requests (id, title, author, note, status, created_at) values
(1, 'Grain of Wheat', 'Ngũgĩ wa Thiong''o', 'Looking for the revised 1986 edition with author notes.', 'available', '2025-04-05'),
(2, 'Sundiata: An Epic of Old Mali', 'D.T. Niane', 'The oral tradition retelling by Djibril Tamsir Niane.', 'sourcing', '2025-04-20'),
(3, 'Season of Crimson Blossoms', 'Abubakar Adam Ibrahim', 'Award-winning Nigerian novel from Parresia Publishers.', 'in_review', '2025-05-02'),
(4, 'Unbowed: A Memoir', 'Wangari Maathai', 'Would love the Nobel laureate''s autobiography.', 'pending', '2025-05-10'),
(5, 'Black Skin, White Masks', 'Frantz Fanon', 'The 1952 classic on colonialism and identity.', 'unavailable', '2025-03-15')
on conflict (id) do nothing;

-- ── Request Events ────────────────────────────────────────────────────────────
insert into request_events (request_id, status, note, created_at) values
(1, 'pending',   'Request submitted.',                              '2025-04-05'),
(1, 'in_review', 'Our team is reviewing availability.',            '2025-04-06'),
(1, 'sourcing',  'Book located with a partner publisher.',         '2025-04-08'),
(1, 'available', 'Now available! Added to the catalog.',           '2025-04-12'),
(2, 'pending',   'Request submitted.',                             '2025-04-20'),
(2, 'in_review', 'Reviewing licensing options.',                   '2025-04-21'),
(2, 'sourcing',  'In contact with the publisher.',                 '2025-04-23'),
(3, 'pending',   'Request received.',                              '2025-05-02'),
(3, 'in_review', 'Team review in progress.',                       '2025-05-03'),
(4, 'pending',   'Request received. Queue position: 3.',           '2025-05-10'),
(5, 'pending',   'Request submitted.',                             '2025-03-15'),
(5, 'in_review', 'Checking digital licensing.',                    '2025-03-16'),
(5, 'unavailable','Unable to obtain digital rights at this time.', '2025-03-22');

-- ── Orders ────────────────────────────────────────────────────────────────────
insert into orders (id, book_id, quantity, total_price, status, tracking_number, estimated_delivery, shipping_address, created_at)
select 1, id, 2, 1700.00, 'delivered', 'KE-TRK-00123456', '2025-03-20', '14 Kimathi Street, Nairobi 00100', '2025-03-12'
from books where slug = 'things-fall-apart' on conflict (id) do nothing;

insert into orders (id, book_id, quantity, total_price, status, tracking_number, estimated_delivery, shipping_address, created_at)
select 2, id, 1, 1650.00, 'shipped', 'KE-TRK-00189012', '2025-05-18', '14 Kimathi Street, Nairobi 00100', '2025-05-08'
from books where slug = 'half-of-a-yellow-sun' on conflict (id) do nothing;

insert into orders (id, book_id, quantity, total_price, status, shipping_address, created_at)
select 3, id, 1, 1750.00, 'processing', '14 Kimathi Street, Nairobi 00100', '2025-05-14'
from books where slug = 'homegoing' on conflict (id) do nothing;

insert into orders (id, book_id, quantity, total_price, status, tracking_number, estimated_delivery, shipping_address, created_at)
select 4, id, 1, 1600.00, 'delivered', 'KE-TRK-00099876', '2025-01-28', '14 Kimathi Street, Nairobi 00100', '2025-01-20'
from books where slug = 'americanah' on conflict (id) do nothing;

-- ── Order Steps ───────────────────────────────────────────────────────────────
insert into order_steps (order_id, label, completed_at) values
(1, 'Order Placed',      '2025-03-12'),
(1, 'Payment Confirmed', '2025-03-12'),
(1, 'Processing',        '2025-03-13'),
(1, 'Shipped',           '2025-03-15'),
(1, 'Delivered',         '2025-03-19'),
(2, 'Order Placed',      '2025-05-08'),
(2, 'Payment Confirmed', '2025-05-08'),
(2, 'Processing',        '2025-05-09'),
(2, 'Shipped',           '2025-05-11'),
(2, 'Delivered',         null),
(3, 'Order Placed',      '2025-05-14'),
(3, 'Payment Confirmed', '2025-05-14'),
(3, 'Processing',        null),
(3, 'Shipped',           null),
(3, 'Delivered',         null),
(4, 'Order Placed',      '2025-01-20'),
(4, 'Payment Confirmed', '2025-01-20'),
(4, 'Processing',        '2025-01-21'),
(4, 'Shipped',           '2025-01-23'),
(4, 'Delivered',         '2025-01-27');
