-- Contract: Feedback Inbox storage schema
-- Owner: feedback-team
-- Consumers: api service, analytics export, feedback CLI (read-only)
-- Update this file in the same migration that changes any schema element.
-- Engine: Postgres 15+.

CREATE TABLE IF NOT EXISTS feedback (
    id           uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
    source       text          NOT NULL,
    email        text          NULL,
    message      text          NOT NULL,
    theme_id     uuid          NULL,
    created_at   timestamptz   NOT NULL DEFAULT now(),
    deleted_at   timestamptz   NULL,

    CONSTRAINT feedback_source_check
        CHECK (source IN ('web', 'mobile', 'zapier', 'api')),
    CONSTRAINT feedback_message_length_check
        CHECK (char_length(message) BETWEEN 1 AND 4000)
);

CREATE TABLE IF NOT EXISTS tags (
    feedback_id  uuid          NOT NULL REFERENCES feedback(id) ON DELETE CASCADE,
    tag          text          NOT NULL,
    PRIMARY KEY (feedback_id, tag),
    CONSTRAINT tag_format_check
        CHECK (tag ~ '^[a-z][a-z0-9-]{0,31}$')
);

CREATE TABLE IF NOT EXISTS themes (
    id           uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
    name         text          NOT NULL,
    created_at   timestamptz   NOT NULL DEFAULT now(),

    CONSTRAINT theme_name_length_check
        CHECK (char_length(name) BETWEEN 1 AND 120)
);

ALTER TABLE feedback
    ADD CONSTRAINT feedback_theme_fk
        FOREIGN KEY (theme_id) REFERENCES themes(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS feedback_events (
    id           bigserial     PRIMARY KEY,
    event_type   text          NOT NULL,
    payload      jsonb         NOT NULL,
    emitted_at   timestamptz   NULL,
    created_at   timestamptz   NOT NULL DEFAULT now(),

    CONSTRAINT feedback_event_type_check
        CHECK (event_type IN ('feedback.submitted', 'feedback.theme.created'))
);

CREATE INDEX IF NOT EXISTS feedback_created_at_idx
    ON feedback (created_at DESC)
    WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS feedback_source_created_idx
    ON feedback (source, created_at DESC)
    WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS feedback_events_pending_idx
    ON feedback_events (created_at)
    WHERE emitted_at IS NULL;

-- Application-layer rules (not enforced by SQL):
--   * email is normalized to lowercase before insert.
--   * email is hashed (SHA-256) before being written to any log line.
--   * tags list capped at 8 entries; validated in api/feedback.
--   * feedback_events rows older than 7 days with emitted_at NOT NULL are purged daily.

-- Compatibility:
--   * Adding new nullable columns -> additive.
--   * Tightening any CHECK constraint, removing columns, or renaming columns -> breaking;
--     requires migration plan in docs/DECISIONS/ and dual-write window.
