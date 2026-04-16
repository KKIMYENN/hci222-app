from fastapi import UploadFile


async def detect_product(image: UploadFile) -> dict[str, str | float]:
    await image.read()

    return {
        "label": "apple",
        "confidence": 0.87,
    }

