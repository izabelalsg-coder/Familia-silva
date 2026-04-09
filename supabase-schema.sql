-- ============================================================
-- FAMÍLIA SILVA — Schema Supabase
-- Execute este script no SQL Editor do seu projeto Supabase:
-- https://supabase.com → seu projeto → SQL Editor → New query
-- ============================================================

-- 1. Comentários diários no devocional
CREATE TABLE IF NOT EXISTS daily_comments (
  id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id     TEXT        NOT NULL,
  devotional_date TEXT      NOT NULL,   -- formato YYYY-MM-DD
  comment       TEXT        NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Mural de orações (resetado semanalmente via week_key)
CREATE TABLE IF NOT EXISTS prayers (
  id         UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id  TEXT        NOT NULL,
  text       TEXT        NOT NULL,
  week_key   TEXT        NOT NULL,     -- formato YYYY-WNN  ex: 2025-W15
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Conclusão de missões semanais
CREATE TABLE IF NOT EXISTS mission_completions (
  id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id   TEXT        NOT NULL,
  mission_id  TEXT        NOT NULL,   -- formato WEEK_KEY-N  ex: 2025-W15-1
  week_key    TEXT        NOT NULL,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (member_id, mission_id)       -- evita duplicatas
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS) — permite leitura e escrita pública
-- Ajuste conforme a necessidade de privacidade da sua família
-- ============================================================

ALTER TABLE daily_comments     ENABLE ROW LEVEL SECURITY;
ALTER TABLE prayers            ENABLE ROW LEVEL SECURITY;
ALTER TABLE mission_completions ENABLE ROW LEVEL SECURITY;

-- Política: qualquer pessoa (anon) pode ler e escrever
-- (adequado para app familiar privado sem autenticação)

CREATE POLICY "public_select_daily_comments"
  ON daily_comments FOR SELECT USING (true);

CREATE POLICY "public_insert_daily_comments"
  ON daily_comments FOR INSERT WITH CHECK (true);

CREATE POLICY "public_select_prayers"
  ON prayers FOR SELECT USING (true);

CREATE POLICY "public_insert_prayers"
  ON prayers FOR INSERT WITH CHECK (true);

CREATE POLICY "public_select_missions"
  ON mission_completions FOR SELECT USING (true);

CREATE POLICY "public_insert_missions"
  ON mission_completions FOR INSERT WITH CHECK (true);

CREATE POLICY "public_delete_missions"
  ON mission_completions FOR DELETE USING (true);

-- ============================================================
-- ÍNDICES para performance
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_comments_date
  ON daily_comments (devotional_date);

CREATE INDEX IF NOT EXISTS idx_prayers_week
  ON prayers (week_key);

CREATE INDEX IF NOT EXISTS idx_missions_week
  ON mission_completions (week_key);

CREATE INDEX IF NOT EXISTS idx_missions_member
  ON mission_completions (member_id);
