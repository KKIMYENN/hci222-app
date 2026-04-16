from fastapi import APIRouter, File, UploadFile

from app.schemas.recognition import RecognitionResponse
from app.services.detection_service import detect_product
from app.services.price_match_service import match_price

router = APIRouter(tags=["recognition"])


@router.post("/recognize", response_model=RecognitionResponse)
async def recognize_product(image: UploadFile = File(...)) -> RecognitionResponse:
    detection = await detect_product(image)
    price = match_price(detection["label"])

    return RecognitionResponse(
        success=True,
        detected_label=detection["label"],
        display_name=price["display_name"],
        category=price["category"],
        confidence=detection["confidence"],
        price=price["price"],
        bargaining_tip=price["bargaining_tip"],
        matches=price["matches"],
    )

