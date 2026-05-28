-- Contract: feedback storage schema
-- Owner: feedback-team
-- Consumers: feedback API handlers, analytics aggregator (read-only)
-- Update this file in the same migration that changes the schema.
-- Engine: Postgres 15+.

CREATE TABLE IF NOT EXISTS feedback (
    id           uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
    source       text          NOT NULL,
    email        text          NULL,
    message      text          NOT NULL,
    tags         text[]        NOT NULL DEFAULT '{}',
    created_at   timestamptz   NOT NULL DEFAULT now(),
    deleted_at   timestamptz   NULL,

    CONSTRAINT feedback_source_check
        CHECK (source IN ('web', 'mobile', 'zapier', 'api')),
    CONSTRAINT feedback_message_length_check
        CHECK (char_length(message) BETWEEN 1 AND 4000),
    CONSTRAINT feedback_email_format_check
        CHECK (email IS NULL OR email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    CONSTRAINT feedback_tags_size_check
        CHECK (array_length(tags, 1) IS NULL OR array_length(tags, 1) <= 8)
);

CREATE INDEX IF NOT EXISTS feedback_created_at_idx
    ON feedback (created_at DESC)
    WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS feedback_source_created_idx
    ON feedback (source, created_at DESC)
    WHERE deleted_at IS NULL;

-- Validation rules not enforced by SQL alone:
--   - tags entries must match ^[a-z][a-z0-9-]{0,31}$ (enforced at application layer).
--   - email is normalized to lowercase before insert (enforced at application layer).

-- Compatibility:
--   - Adding new nullable columns is additive (non-breaking).
--   - Tightening any CHECK constraint, removing columns, or renaming columns is breaking;
--     requires migration plan in docs/DECISIONS/ and dual-write window.

-- Sample read used by the API GET /v1/feedback (cursor pagination on created_at + id):
--   SELECT id, source, email, message, tags, created_at
--     FROM feedback
--    WHERE deleted_at IS NULL
--      AND (created_at, id) < ($cursor_created_at, $cursor_id)
--    ORDER BY created_at DESC, id DESC
--    LIMIT $limit;
