from pydantic import BaseModel


class PriceSummary(BaseModel):
    average: int
    min: int
    max: int
    currency: str
    unit: str


class MarketMatch(BaseModel):
    market: str
    price: int
    distance_km: float


class RecognitionResponse(BaseModel):
    success: bool
    detected_label: str
    display_name: str
    category: str
    confidence: float
    price: PriceSummary
    bargaining_tip: str
    matches: list[MarketMatch]

