from __future__ import annotations

class PluginRegistry:
    def __init__(self) -> None:
        self._plugins: dict[str, dict] = {}

    def register(self, name: str, capability: str) -> dict:
        self._plugins[name] = {"capability": capability}
        return {"name": name, "capability": capability}

    def list_plugins(self) -> dict:
        return {"count": len(self._plugins), "plugins": self._plugins}
