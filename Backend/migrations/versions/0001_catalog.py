"""Create catalog tables and sync checkpoints."""
import sqlalchemy as sa
from alembic import op

revision = "0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "manga",
        sa.Column("id", sa.Uuid(), primary_key=True),
        sa.Column("title", sa.String(512), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("original_language", sa.String(16), nullable=False),
        sa.Column("content_rating", sa.String(32), nullable=False),
        sa.Column("source_updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("synced_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_manga_source_updated_at", "manga", ["source_updated_at", "id"])
    op.create_table(
        "chapter",
        sa.Column("id", sa.Uuid(), primary_key=True),
        sa.Column("manga_id", sa.Uuid(), sa.ForeignKey("manga.id", ondelete="CASCADE"), nullable=False),
        sa.Column("title", sa.String(512)),
        sa.Column("number", sa.String(64)),
        sa.Column("volume", sa.String(64)),
        sa.Column("language", sa.String(16), nullable=False),
        sa.Column("pages", sa.Integer(), nullable=False),
        sa.Column("published_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("source_updated_at", sa.DateTime(timezone=True), nullable=False),
    )
    op.create_index(
        "ix_chapter_manga_language_published",
        "chapter", ["manga_id", "language", "published_at", "id"],
    )
    op.create_table(
        "sync_checkpoint",
        sa.Column("name", sa.String(64), primary_key=True),
        sa.Column("watermark", sa.DateTime(timezone=True)),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )


def downgrade() -> None:
    op.drop_table("sync_checkpoint")
    op.drop_table("chapter")
    op.drop_table("manga")
