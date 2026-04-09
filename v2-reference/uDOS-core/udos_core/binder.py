from __future__ import annotations

class BinderEngine:
    def __init__(self) -> None:
        self.binders: dict[str, dict] = {}

    def create(self, binder_id: str) -> dict:
        if binder_id in self.binders:
            return {"binder_id": binder_id, "created": False, "reason": "exists"}
        self.binders[binder_id] = {"tasks": [], "docs": [], "notes": []}
        return {"binder_id": binder_id, "created": True}

    def summary(self) -> dict:
        return {"count": len(self.binders), "binders": sorted(self.binders.keys())}
