from fastapi.testclient import TestClient
from sqlalchemy.exc import OperationalError

from app.database import get_session
from app.main import app


def test_liveness_does_not_require_database():
    with TestClient(app) as client:
        response = client.get("/health/live")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_readiness_reports_database_failure():
    class UnavailableSession:
        def execute(self, statement):
            raise OperationalError("SELECT 1", {}, Exception("unavailable"))

    app.dependency_overrides[get_session] = lambda: UnavailableSession()
    try:
        with TestClient(app) as client:
            response = client.get("/health/ready")
        assert response.status_code == 503
        assert response.json() == {"detail": "Database is not ready"}
    finally:
        app.dependency_overrides.clear()
