# Loading Data into Supabase

## Step 1 — Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **New project**, choose a name (e.g. `kitabu`) and set a database password
3. Wait ~2 minutes for provisioning

## Step 2 — Run the schema

1. In your project dashboard click **SQL Editor** (left sidebar)
2. Click **New query**
3. Open `supabase/schema.sql` from this repo, paste the entire contents, click **Run**
4. You should see "Success. No rows returned"

## Step 3 — Seed the data

1. Still in SQL Editor, create another new query
2. Open `supabase/seed.sql`, paste contents, click **Run**
3. You should see "Success. No rows returned" (all inserts use `on conflict do nothing`)

## Step 4 — Get your credentials

1. Go to **Project Settings → API**
2. Copy:
   - **Project URL** → this is your `SUPABASE_URL`
   - **anon public** key → this is your `SUPABASE_ANON_KEY`

## Step 5 — Run the app with Supabase

Create a file `env.json` in the project root (git-ignored):

```json
{
  "SUPABASE_URL": "https://xxxxxxxxxxxxxxxxxxxx.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

Then run:

```bash
flutter run --dart-define-from-file=env.json
```

Or for a specific device:

```bash
flutter run -d chrome --dart-define-from-file=env.json
flutter run -d <your-device-id> --dart-define-from-file=env.json
```

## Without Supabase (offline mode)

Simply run `flutter run` with no flags — the app falls back to the bundled fixture data and works fully offline.

## Verify data loaded correctly

In Supabase Table Editor you should see:
- **books** → 18 rows
- **categories** → 6 rows
- **library** → 5 rows
- **requests** → 5 rows
- **request_events** → 13 rows
- **orders** → 4 rows
- **order_steps** → 20 rows
