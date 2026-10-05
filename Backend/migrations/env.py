from alembic import context

from app import models  # noqa: F401
from app.config import get_settings
from app.database import Base, get_engine


def run_migrations() -> None:
    if context.is_offline_mode():
        context.configure(
            url=get_settings().database_url,
            target_metadata=Base.metadata,
            literal_binds=True,
            dialect_opts={"paramstyle": "named"},
        )
        with context.begin_transaction():
            context.run_migrations()
    else:
        with get_engine().connect() as connection:
            context.configure(connection=connection, target_metadata=Base.metadata)
            with context.begin_transaction():
                context.run_migrations()


run_migrations()
