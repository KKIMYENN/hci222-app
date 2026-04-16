import json
from pathlib import Path
from typing import Any

DATA_PATH = Path(__file__).resolve().parents[1] / "data" / "mock_prices.json"


def match_price(label: str) -> dict[str, Any]:
    prices = json.loads(DATA_PATH.read_text(encoding="utf-8"))

    for item in prices:
        if item["label"] == label:
            return item

    return {
        "label": label,
        "display_name": label.title(),
        "category": "unknown",
        "price": {
            "average": 0,
            "min": 0,
            "max": 0,
            "currency": "KRW",
            "unit": "unknown",
        },
        "bargaining_tip": "가격 데이터가 없어 현장 가격을 먼저 확인하세요.",
        "matches": [],
    }

