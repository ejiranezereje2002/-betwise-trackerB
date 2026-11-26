-- Run this once in Supabase: SQL Editor > New query > paste > Run
create table profiles (id uuid primary key references auth.users on delete cascade, capital double precision not null default 5000);
create table bankrolls (id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users on delete cascade, name text not null, created_at timestamptz default now());
create table bets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  date date not null, event text not null, sel text, sport text, type text,
  odds double precision not null, stake double precision not null,
  status text not null default 'pending' check (status in ('pending','won','lost','push')),
  bankroll text, created_at timestamptz default now());
create index on bets(user_id, date desc);
alter table profiles enable row level security;
alter table bankrolls enable row level security;
alter table bets enable row level security;
create policy "own profile" on profiles for all using (id = auth.uid()) with check (id = auth.uid());
create policy "own bankrolls" on bankrolls for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own bets" on bets for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Table permissions (required on newer Supabase projects)
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.profiles  to authenticated;
grant select, insert, update, delete on public.bankrolls to authenticated;
grant select, insert, update, delete on public.bets      to authenticated;
