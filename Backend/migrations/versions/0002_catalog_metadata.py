"""Preserve localized metadata and chapter releases."""
import sqlalchemy as sa
from alembic import op

revision = "0002"
down_revision = "0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    for name, default in (
        ("titles", "{}"), ("alternate_titles", "[]"), ("descriptions", "{}"),
        ("source_links", "{}"), ("tags", "[]"), ("creators", "[]"),
    ):
        op.add_column("manga", sa.Column(name, sa.JSON(), nullable=False, server_default=default))
        op.alter_column("manga", name, server_default=None)
    op.add_column("manga", sa.Column("status", sa.String(32), nullable=False, server_default="unknown"))
    op.alter_column("manga", "status", server_default=None)
    op.add_column("manga", sa.Column("year", sa.Integer()))
    op.add_column("manga", sa.Column("cover_filename", sa.String(512)))
    op.add_column("chapter", sa.Column("groups", sa.JSON(), nullable=False, server_default="[]"))
    op.alter_column("chapter", "groups", server_default=None)
    op.add_column("chapter", sa.Column("external_url", sa.Text()))


def downgrade() -> None:
    op.drop_column("chapter", "external_url")
    op.drop_column("chapter", "groups")
    for name in (
        "cover_filename", "year", "status", "creators", "tags", "source_links",
        "descriptions", "alternate_titles", "titles",
    ):
        op.drop_column("manga", name)
