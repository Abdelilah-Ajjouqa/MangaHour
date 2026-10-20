import httpx
import pytest

from app.mangadex import MangaDexClient, MangaDexError


class Clock:
    def __init__(self):
        self.now = 0.0

    def sleep(self, seconds):
        self.now += seconds


def make_client(handler, clock):
    http = httpx.Client(base_url="https://example.test", transport=httpx.MockTransport(handler))
    return MangaDexClient(http, sleep=clock.sleep, monotonic=lambda: clock.now, wall_time=lambda: clock.now)


def test_throttles_requests_and_respects_exhausted_quota():
    calls = []
    clock = Clock()

    def handler(request):
        calls.append(clock.now)
        return httpx.Response(200, json={"result": "ok"}, headers={
            "X-RateLimit-Remaining": "0", "X-RateLimit-Retry-After": "10",
        })

    client = make_client(handler, clock)
    client.get("/manga")
    client.get("/manga")
    assert calls == [0, 11]
    client.client.close()


def test_rate_limit_ends_run_without_repeated_requests():
    calls = []

    def handler(request):
        calls.append(request)
        return httpx.Response(429)

    client = make_client(handler, Clock())
    with pytest.raises(MangaDexError, match="rate limited"):
        client.get("/manga")
    assert len(calls) == 1
    client.client.close()


def test_server_failures_have_bounded_retries():
    calls = []

    def handler(request):
        calls.append(request)
        return httpx.Response(503)

    client = make_client(handler, Clock())
    with pytest.raises(MangaDexError, match="unavailable"):
        client.get("/manga")
    assert len(calls) == 3
    client.client.close()


def test_malformed_json_does_not_retry():
    client = make_client(lambda request: httpx.Response(200, text="not json"), Clock())
    with pytest.raises(MangaDexError, match="invalid"):
        client.get("/manga")
    client.client.close()
