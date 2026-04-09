-- ============================================================
-- FAMÍLIA SILVA — Schema Supabase
-- Execute no SQL Editor do projeto gpswaosnwuoswwvjilnj
-- Supabase → SQL Editor → New query → cole tudo → Run
-- ============================================================

-- 1. Membros da família
CREATE TABLE IF NOT EXISTS membros (
  id           TEXT PRIMARY KEY,
  nome         TEXT NOT NULL,
  emoji        TEXT NOT NULL,
  cor          TEXT NOT NULL,
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Progresso (devocionais concluídos + missões)
CREATE TABLE IF NOT EXISTS progresso (
  id          UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  membro_id   TEXT    NOT NULL,
  tipo        TEXT    NOT NULL,   -- 'devocional' ou 'missao'
  referencia  TEXT    NOT NULL,   -- data (YYYY-MM-DD) ou id de missão (WEEK_KEY-N)
  criado_em   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (membro_id, tipo, referencia)
);

-- 3. Mural de orações (resetado semanalmente via filtro de data)
CREATE TABLE IF NOT EXISTS oracoes (
  id          UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  autor_id    TEXT    NOT NULL,
  autor_nome  TEXT,
  autor_emoji TEXT,
  texto       TEXT    NOT NULL,
  data_br     TEXT,
  criado_em   TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Intercessões (quem orou por qual pedido)
CREATE TABLE IF NOT EXISTS intercessions (
  id          UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  oracao_id   UUID    REFERENCES oracoes(id) ON DELETE CASCADE,
  membro_id   TEXT    NOT NULL,
  criado_em   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (oracao_id, membro_id)
);

-- 5. Comentários diários no devocional
CREATE TABLE IF NOT EXISTS comentarios (
  id               UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  autor_id         TEXT    NOT NULL,
  data_devocional  TEXT    NOT NULL,   -- YYYY-MM-DD
  texto            TEXT    NOT NULL,
  hora             TEXT,
  criado_em        TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE membros       ENABLE ROW LEVEL SECURITY;
ALTER TABLE progresso     ENABLE ROW LEVEL SECURITY;
ALTER TABLE oracoes       ENABLE ROW LEVEL SECURITY;
ALTER TABLE intercessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE comentarios   ENABLE ROW LEVEL SECURITY;

-- Políticas públicas (adequadas para app familiar sem autenticação)
CREATE POLICY "public_all_membros"
  ON membros FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "public_all_progresso"
  ON progresso FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "public_all_oracoes"
  ON oracoes FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "public_all_intercessions"
  ON intercessions FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "public_all_comentarios"
  ON comentarios FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- ÍNDICES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_progresso_membro   ON progresso (membro_id);
CREATE INDEX IF NOT EXISTS idx_progresso_tipo      ON progresso (tipo);
CREATE INDEX IF NOT EXISTS idx_oracoes_criado      ON oracoes (criado_em);
CREATE INDEX IF NOT EXISTS idx_intercessions_oracao ON intercessions (oracao_id);
CREATE INDEX IF NOT EXISTS idx_comentarios_data    ON comentarios (data_devocional);
