# Família Silva — Devocional Familiar

App de devocional diário, mural de orações, missões semanais e tabuleiro de progresso.

---

## Passo 1 — Criar o repositório no GitHub

1. Acesse https://github.com/new
2. Preencha:
   - **Repository name:** `familia-silva`
   - **Visibility:** Public (obrigatório para GitHub Pages gratuito)
3. Clique em **Create repository**

---

## Passo 2 — Criar o projeto no Supabase

1. Acesse https://supabase.com e entre na sua conta
2. Clique em **New project**
3. Escolha a organização e preencha:
   - **Name:** familia-silva
   - **Database password:** (anote em lugar seguro)
   - **Region:** South America (São Paulo) — recomendado
4. Clique em **Create new project** e aguarde (~2 min)

---

## Passo 3 — Criar as tabelas no Supabase

1. No painel do projeto, vá em **SQL Editor** → **New query**
2. Cole o conteúdo do arquivo `supabase-schema.sql`
3. Clique em **Run** (ou Ctrl+Enter)
4. Confirme que as tabelas apareceram em **Table Editor**

---

## Passo 4 — Obter as credenciais Supabase

1. No painel do projeto, vá em **Settings** → **API**
2. Copie:
   - **Project URL** (ex: `https://xxxxxxxxxxx.supabase.co`)
   - **anon public** key (começa com `eyJ...`)

---

## Passo 5 — Configurar o app

Abra o arquivo `index.html` e edite as linhas no topo:

```javascript
const SUPABASE_URL      = 'COLE_AQUI_SUA_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'COLE_AQUI_SUA_SUPABASE_ANON_KEY';
```

Personalize também os membros da família:

```javascript
const MEMBERS = [
  { id: 'pai',    name: 'José',   emoji: '👨', color: '#3B82F6' },
  { id: 'mae',    name: 'Maria',  emoji: '👩', color: '#EC4899' },
  { id: 'filho1', name: 'Pedro',  emoji: '👦', color: '#F59E0B' },
  { id: 'filho2', name: 'Ana',    emoji: '👧', color: '#10B981' },
];
```

> O campo `id` deve ser único e sem espaços. Ele é usado como chave no banco de dados.

---

## Passo 6 — Subir para o GitHub

```bash
git init
git add .
git commit -m "primeira versão"
git branch -M main
git remote add origin https://github.com/izabelalsg-coder/familia-silva.git
git push -u origin main
```

---

## Passo 7 — Ativar GitHub Pages

1. No repositório, vá em **Settings** → **Pages**
2. Em **Source**, selecione: **Deploy from a branch**
3. Em **Branch**, selecione: `main` / `/ (root)`
4. Clique em **Save**
5. Aguarde 2-3 minutos
6. Acesse: `https://izabelalsg-coder.github.io/familia-silva`

---

## Estrutura dos arquivos

```
familia-silva/
├── index.html          ← App completo (React via CDN)
├── devocionais.json    ← 31 devocionais (adicione mais conforme precisar)
├── supabase-schema.sql ← SQL para criar as tabelas
└── README.md           ← Este guia
```

---

## Devocionais

O app carrega `devocionais.json` e busca a entrada com `data` igual à data de hoje (`YYYY-MM-DD`).
Se não encontrar, usa `dia do ano % total de entradas` como fallback.

Para adicionar devocionais com datas específicas, edite o campo `data`:

```json
{
  "dia": 1,
  "data": "2025-04-13",
  "titulo": "Título aqui",
  ...
}
```

---

## Formato dos IDs de missão

As missões seguem o padrão: `YYYY-WNN-N`

Exemplos:
- `2025-W15-1` → semana 15 de 2025, missão 1
- `2025-W15-3` → semana 15 de 2025, missão 3

O mural de orações é filtrado pela `week_key` atual, portanto é renovado automaticamente a cada semana.

---

## Fases do Tabuleiro de Progresso

| Fase      | Emoji | Missões concluídas |
|-----------|-------|--------------------|
| Semente   | 🌱    | 0 – 4              |
| Broto     | 🌿    | 5 – 14             |
| Planta    | 🌳    | 15 – 29            |
| Árvore    | 🌲    | 30 – 49            |
| Floresta  | ✨    | 50+                |

---

## Suporte

Em caso de dúvidas, verifique:
- Documentação Supabase: https://supabase.com/docs
- GitHub Pages: https://docs.github.com/en/pages
