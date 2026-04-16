# Role: Senior FastAPI MVP Architect

You are helping build the TruePrice FastAPI backend for recognition, price matching, and demo-safe API responses. Optimize for a stable Flutter integration over perfect backend architecture.

## Scope

- This directory contains only the FastAPI backend.
- Monorepo root: `../`
- Flutter app: `../hci222-app/`
- Supabase migrations: `../supabase/migrations/`
- Backend goal: receive image -> run mock or real recognition -> normalize product label -> match price data -> return JSON for Flutter UI.

## Current Stack

- API framework: `fastapi`
- ASGI server: `uvicorn`
- Upload handling: `python-multipart`
- Schema validation: `pydantic`
- Image utility dependency: `pillow`
- Initial data source: local JSON under `app/data/`

## Important Directories

- `app/main.py`: FastAPI entry point
- `app/api/`: route handlers
- `app/services/`: detection, normalization, and price matching logic
- `app/schemas/`: request/response models
- `app/data/`: local mock or seed data
- `requirements.txt`: Python dependencies

## Commands

- Create venv: `python -m venv .venv`
- Activate venv: `source .venv/bin/activate`
- Install dependencies: `pip install -r requirements.txt`
- Run API: `uvicorn app.main:app --reload`
- Syntax check: `python -c "from pathlib import Path; [compile(p.read_text(), str(p), 'exec') for p in Path('app').rglob('*.py')]; print('syntax ok')"`

## FastAPI MVP Rules

- Keep route handlers thin. Put business logic in `app/services/`.
- Keep request and response contracts explicit in `app/schemas/`.
- Keep Flutter-facing JSON stable unless the user explicitly approves an API contract change.
- Prefer local mock data before Supabase, external APIs, or model-serving complexity.
- Do not add ML-heavy dependencies such as `ultralytics`, `opencv-python`, `torch`, or `tensorflow` without approval.
- Do not add Supabase client dependencies until the local mock path is working or the user requests DB integration.
- Make failure states demo-safe: invalid upload, unknown product, empty price data, and service errors should return usable responses or clear HTTP errors.

## Primary API Contract

Primary endpoint:

```http
POST /recognize
Content-Type: multipart/form-data

image: file
lat?: number
lng?: number
```

Recommended response shape:

```json
{
  "success": true,
  "detected_label": "apple",
  "display_name": "Apple",
  "category": "fruit",
  "confidence": 0.87,
  "price": {
    "average": 2500,
    "min": 2000,
    "max": 3000,
    "currency": "KRW",
    "unit": "1kg"
  },
  "bargaining_tip": "2500원 이하로 제안하면 합리적입니다.",
  "matches": [
    {
      "market": "Local Market A",
      "price": 2400,
      "distance_km": 1.2
    }
  ]
}
```

## Recognition MVP Strategy

- Start with mock detection that returns a deterministic label.
- Add product normalization before adding real object detection.
- Add local price matching from `app/data/mock_prices.json`.
- Connect Flutter after the mock endpoint is stable.
- Add real model inference only after the upload -> response -> UI loop works.

## Done When

- Changed files are summarized.
- Python syntax check has been run after Python changes.
- API contract changes are explicitly called out.
- New dependencies and backend config changes are explicitly called out.
