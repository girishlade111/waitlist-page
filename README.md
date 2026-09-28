# Waitlist Page — Neon Postgres-backed Email Waitlist

A polished waitlist landing page that **stores signups in a real database**. The glassmorphism signup card posts emails to a Next.js API route that inserts them into a **Neon Postgres** table (with duplicate-email detection), and ready-to-run SQL scripts (`scripts/`) create and seed the table.

Originally scaffolded with [v0.app](https://v0.app), then kept in this repo.

## Features

- **Waitlist signup form** (`components/waitlist-form.tsx`) — email validation, loading/success/error states, animated feedback
- **Signup API route** (`app/api/waitlist/route.ts`) — `POST /api/waitlist` inserts the email into Postgres; returns `409` on duplicates
- **Database scripts** (`scripts/`) — `01-create-waitlist-table.sql` (table + unique index on email), `02-seed-waitlist-data.sql` (sample rows)
- **Glassmorphism card UI** — backdrop-blur card over a shader/gradient hero, dark/light mode toggle
- **Theme provider + mode toggle** — `next-themes` based dark/light switching

## Tech stack

- **Framework:** Next.js (App Router), React 19
- **Database:** Neon serverless Postgres (`@neondatabase/serverless`)
- **Styling:** Tailwind CSS + shadcn/ui components, `@paper-design/shaders-react`
- **UI primitives:** Radix UI suite, `lucide-react` icons
- **Forms:** react-hook-form + zod
- **Type safety:** TypeScript

## Quick start

```bash
# 1. install dependencies
npm install        # or: pnpm install

# 2. create the database table (Neon SQL editor, psql, or any client)
#    run scripts/01-create-waitlist-table.sql against your Neon database
#    optionally run scripts/02-seed-waitlist-data.sql for sample data

# 3. configure environment (see below) in .env.local

# 4. run the dev server
npm run dev        # -> http://localhost:3000

# production build
npm run build
npm start
```

## Environment variables

| Variable | Required | Purpose |
|---|---|---|
| `DATABASE_URL` | Yes | Neon Postgres connection string (`postgresql://...`). Used by `/api/waitlist` to insert signups. Without it the form always errors. |

```bash
# .env.local
DATABASE_URL=postgresql://user:password@ep-xxxx.neon.tech/dbname?sslmode=require
```

> Never commit `.env.local` — it is already in `.gitignore`.

## Database schema

```sql
CREATE TABLE waitlist (
  id         SERIAL PRIMARY KEY,
  email      VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

Run `scripts/01-create-waitlist-table.sql` once, then optionally `scripts/02-seed-waitlist-data.sql` to seed demo rows.

## API

- `POST /api/waitlist` — body: `{ "email": "you@example.com" }`
  - `200 { success: true }` — email stored
  - `400 { error }` — invalid email
  - `409 { error: "This email is already on the waitlist" }` — duplicate
  - `500 { error }` — server/DB error

## Project structure

```
waitlist-page/
├── app/
│   ├── api/waitlist/route.ts  # POST -> inserts email into Neon Postgres
│   ├── globals.css            # Tailwind + global styles
│   ├── layout.tsx             # Root layout
│   └── page.tsx               # Landing page
├── components/
│   ├── waitlist-form.tsx      # Signup card with state machine
│   ├── mode-toggle.tsx        # Dark/light toggle
│   ├── theme-provider.tsx     # next-themes wrapper
│   └── ui/                    # shadcn-style primitives
├── lib/utils.ts               # cn() class merge helper
├── scripts/
│   ├── 01-create-waitlist-table.sql  # Schema + index
│   └── 02-seed-waitlist-data.sql     # Sample rows
├── public/                    # Static assets
└── styles/globals.css         # Extra global styles
```

## Deployment notes

- This is a **serverful Next.js app** — the `/api/waitlist` route needs a Node runtime and the `DATABASE_URL` secret, so it does **not** work as a static export. Deploy where server features are available (Vercel, Netlify with the Next.js runtime, or a VPS running `next start`).
- Set `DATABASE_URL` in the host's environment variables, and run the `scripts/*.sql` files against your Neon database before first launch.

---

Built by Girish Lade — [ladestack.in](https://ladestack.in)
