# TruePrice

TruePrice MVP monorepo.

## Structure

```text
TruePrice/
├── hci222-app/      # Flutter mobile app
├── trueprice-api/   # FastAPI recognition and price matching API
└── supabase/        # Database schema and migrations
```

## Flutter

```bash
cd hci222-app
flutter pub get
flutter run
```

## FastAPI

```bash
cd trueprice-api
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Supabase

Keep database migrations under `supabase/migrations/`.

