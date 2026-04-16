# TruePrice API

FastAPI backend for the TruePrice MVP.

Initial responsibility:

- Receive product images from the Flutter app
- Return a demo-safe recognition result
- Match recognized labels to local price data

Run locally:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

