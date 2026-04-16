from fastapi import FastAPI

from app.api.recognition import router as recognition_router

app = FastAPI(title="TruePrice API")

app.include_router(recognition_router)


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}

