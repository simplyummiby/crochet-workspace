-- Supabase setup for Crochet Workspace cloud sync
-- Run this in Supabase Dashboard > SQL Editor.

create table if not exists public.crochet_workspaces (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.crochet_workspaces enable row level security;

drop policy if exists "Users can read their own crochet workspace" on public.crochet_workspaces;
create policy "Users can read their own crochet workspace"
  on public.crochet_workspaces
  for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own crochet workspace" on public.crochet_workspaces;
create policy "Users can insert their own crochet workspace"
  on public.crochet_workspaces
  for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own crochet workspace" on public.crochet_workspaces;
create policy "Users can update their own crochet workspace"
  on public.crochet_workspaces
  for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
