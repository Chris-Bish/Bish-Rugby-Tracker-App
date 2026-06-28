-- ============================================================
-- RUGBY TEAM MANAGER — SUPABASE DATABASE SCHEMA
-- Run this entire file in the Supabase SQL Editor
-- ============================================================

-- PLAYERS
create table if not exists players (
  id          bigint primary key generated always as identity,
  first       text not null,
  last        text not null,
  dob         date,
  pos         text,
  pos2        text,
  jersey      int,
  height      int,
  weight      int,
  phone       text,
  status      text default 'Active',
  notes       text,
  appearances int default 0,
  created_at  timestamptz default now()
);

-- MATCHES
create table if not exists matches (
  id           bigint primary key generated always as identity,
  date         date not null,
  opp          text not null,
  venue        text default 'Home',
  score_us     int default 0,
  score_them   int default 0,
  comp         text,
  motm         bigint references players(id) on delete set null,
  status       text default 'Upcoming',
  notes        text,
  events       jsonb default '[]',
  created_at   timestamptz default now()
);

-- TRY SCORERS (many-to-many: match <-> player)
create table if not exists try_scorers (
  id         bigint primary key generated always as identity,
  match_id   bigint not null references matches(id) on delete cascade,
  player_id  bigint not null references players(id) on delete cascade
);

-- YELLOW CARDS
create table if not exists yellow_cards (
  id         bigint primary key generated always as identity,
  match_id   bigint not null references matches(id) on delete cascade,
  player_id  bigint not null references players(id) on delete cascade
);

-- RED CARDS
create table if not exists red_cards (
  id         bigint primary key generated always as identity,
  match_id   bigint not null references matches(id) on delete cascade,
  player_id  bigint not null references players(id) on delete cascade
);

-- TRAINING SESSIONS
create table if not exists training (
  id         bigint primary key generated always as identity,
  date       date not null,
  focus      text,
  duration   int default 90,
  notes      text,
  created_at timestamptz default now()
);

-- ATTENDANCE
create table if not exists attendance (
  id         bigint primary key generated always as identity,
  event_key  text not null,   -- e.g. 'match_3' or 'training_7'
  player_id  bigint not null references players(id) on delete cascade,
  status     text not null,   -- 'present' or 'absent'
  unique(event_key, player_id)
);

-- SQUADS (saved named squads linked to a match)
create table if not exists squads (
  id         bigint primary key generated always as identity,
  match_id   bigint references matches(id) on delete set null,
  club_name  text default 'My RFC',
  slots      jsonb default '{}',  -- { "1": playerId, "b1": playerId, ... }
  created_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Everyone with the anon key can read.
-- Only authenticated users (your coaches) can write.
-- ============================================================

alter table players    enable row level security;
alter table matches    enable row level security;
alter table try_scorers enable row level security;
alter table yellow_cards enable row level security;
alter table red_cards  enable row level security;
alter table training   enable row level security;
alter table attendance enable row level security;
alter table squads     enable row level security;

-- READ: anyone with the URL can read (change to authenticated if you want login-only)
create policy "Public read players"     on players     for select using (true);
create policy "Public read matches"     on matches     for select using (true);
create policy "Public read try_scorers" on try_scorers for select using (true);
create policy "Public read yellow_cards" on yellow_cards for select using (true);
create policy "Public read red_cards"   on red_cards   for select using (true);
create policy "Public read training"    on training    for select using (true);
create policy "Public read attendance"  on attendance  for select using (true);
create policy "Public read squads"      on squads      for select using (true);

-- WRITE: only signed-in users can insert/update/delete
create policy "Auth write players"     on players     for all using (auth.role() = 'authenticated');
create policy "Auth write matches"     on matches     for all using (auth.role() = 'authenticated');
create policy "Auth write try_scorers" on try_scorers for all using (auth.role() = 'authenticated');
create policy "Auth write yellow_cards" on yellow_cards for all using (auth.role() = 'authenticated');
create policy "Auth write red_cards"   on red_cards   for all using (auth.role() = 'authenticated');
create policy "Auth write training"    on training    for all using (auth.role() = 'authenticated');
create policy "Auth write attendance"  on attendance  for all using (auth.role() = 'authenticated');
create policy "Auth write squads"      on squads      for all using (auth.role() = 'authenticated');
