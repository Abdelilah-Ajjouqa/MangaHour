import time
from collections.abc import Callable

import httpx


class MangaDexError(RuntimeError):
    pass


class MangaDexClient:
    """Sequential client; the importer holds a database lock across all upstream work."""

    def __init__(
        self,
        client: httpx.Client,
        requests_per_second: float = 2,
        max_attempts: int = 3,
        sleep: Callable = time.sleep,
        monotonic: Callable = time.monotonic,
        wall_time: Callable = time.time,
    ):
        self.client = client
        self.interval = 1 / requests_per_second
        self.max_attempts = max_attempts
        self.sleep = sleep
        self.monotonic = monotonic
        self.wall_time = wall_time
        self.next_request = 0.0

    def _delay(self, seconds: float) -> None:
        self.next_request = max(self.next_request, self.monotonic() + max(0, seconds))

    def get(self, path: str, params=None) -> dict:
        for attempt in range(self.max_attempts):
            self.sleep(max(0, self.next_request - self.monotonic()))
            self.next_request = self.monotonic() + self.interval
            try:
                response = self.client.get(path, params=params)
            except httpx.TransportError as exc:
                if attempt + 1 == self.max_attempts:
                    raise MangaDexError("MangaDex network request failed") from exc
                self._delay(2 ** attempt)
                continue

            retry_at = response.headers.get("X-RateLimit-Retry-After")
            delay = 60.0
            if retry_at:
                try:
                    delay = max(1, float(retry_at) - self.wall_time() + 1)
                except ValueError:
                    pass
            if response.status_code == 429 or response.headers.get("X-RateLimit-Remaining") == "0":
                self._delay(delay)
            if response.status_code == 429:
                # End this run rather than repeatedly probing an upstream restriction.
                raise MangaDexError(f"MangaDex rate limited the import; retry after {delay:.0f} seconds")
            if response.status_code >= 500:
                if attempt + 1 < self.max_attempts:
                    self._delay(2 ** attempt)
                    continue
                raise MangaDexError(f"MangaDex unavailable: HTTP {response.status_code}")
            try:
                response.raise_for_status()
                payload = response.json()
            except (httpx.HTTPStatusError, ValueError) as exc:
                raise MangaDexError("MangaDex returned an invalid or unsuccessful response") from exc
            if not isinstance(payload, dict) or payload.get("result") != "ok":
                raise MangaDexError("MangaDex returned an unsuccessful payload")
            return payload
        raise MangaDexError("MangaDex attempts exhausted")

    def manga(self, manga_id: str) -> dict:
        return self.get(
            f"/manga/{manga_id}",
            [("includes[]", "cover_art"), ("includes[]", "author"), ("includes[]", "artist")],
        )["data"]

    def chapters(self, manga_id: str, offset: int) -> dict:
        return self.get(
            f"/manga/{manga_id}/feed",
            [
                ("limit", "100"), ("offset", str(offset)),
                ("translatedLanguage[]", "ar"), ("translatedLanguage[]", "en"),
                ("contentRating[]", "safe"), ("contentRating[]", "suggestive"),
                ("order[createdAt]", "asc"), ("includeFutureUpdates", "0"),
                ("includeExternalUrl", "1"), ("includes[]", "scanlation_group"),
            ],
        )
