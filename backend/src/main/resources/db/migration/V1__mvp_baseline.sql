-- MVP data baseline from docs/mvp/design/technical-solution-mvp.md.
-- User text and domain results are encrypted by the application layer.

CREATE TABLE identity_subject (
    user_id          CHAR(26) NOT NULL,
    subject_type     VARCHAR(16) NOT NULL,
    lifecycle_status VARCHAR(24) NOT NULL,
    last_active_time DATETIME(6) NOT NULL,
    expires_time     DATETIME(6) NULL,
    deleted_time     DATETIME(6) NULL,
    created_time     DATETIME(6) NOT NULL,
    updated_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (user_id),
    KEY idx_subject_expiry (subject_type, expires_time, deleted_time)
);

CREATE TABLE local_account (
    user_id             CHAR(26) NOT NULL,
    email_blind_index   BINARY(32) NOT NULL,
    email_ciphertext    VARBINARY(1024) NOT NULL,
    password_digest     VARCHAR(255) NOT NULL,
    email_verified_time DATETIME(6) NULL,
    account_status      VARCHAR(24) NOT NULL,
    created_time        DATETIME(6) NOT NULL,
    updated_time        DATETIME(6) NOT NULL,
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_account_email (email_blind_index)
);

CREATE TABLE identity_token (
    token_id      CHAR(26) NOT NULL,
    user_id       CHAR(26) NOT NULL,
    token_type    VARCHAR(24) NOT NULL,
    token_digest  BINARY(32) NOT NULL,
    expires_time  DATETIME(6) NOT NULL,
    consumed_time DATETIME(6) NULL,
    created_time  DATETIME(6) NOT NULL,
    PRIMARY KEY (token_id),
    UNIQUE KEY uk_identity_token_digest (token_digest),
    KEY idx_identity_token_user (user_id, token_type, expires_time)
);

CREATE TABLE refresh_token (
    refresh_token_id CHAR(26) NOT NULL,
    user_id          CHAR(26) NOT NULL,
    token_digest     BINARY(32) NOT NULL,
    device_label     VARCHAR(128) NULL,
    expires_time     DATETIME(6) NOT NULL,
    revoked_time     DATETIME(6) NULL,
    created_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (refresh_token_id),
    UNIQUE KEY uk_refresh_token_digest (token_digest),
    KEY idx_refresh_user (user_id, revoked_time, expires_time)
);

CREATE TABLE notification_delivery (
    delivery_id                    CHAR(26) NOT NULL,
    user_id                        CHAR(26) NOT NULL,
    notification_type              VARCHAR(64) NOT NULL,
    recipient_hash                 BINARY(32) NOT NULL,
    recipient_ciphertext           VARBINARY(1024) NOT NULL,
    template_id                    VARCHAR(128) NOT NULL,
    template_variables_ciphertext  MEDIUMBLOB NOT NULL,
    key_version                    INT NOT NULL,
    delivery_status                VARCHAR(24) NOT NULL,
    failure_code                   VARCHAR(64) NULL,
    retry_count                    INT NOT NULL DEFAULT 0,
    next_retry_time                DATETIME(6) NULL,
    expires_time                   DATETIME(6) NOT NULL,
    delivered_time                 DATETIME(6) NULL,
    created_time                   DATETIME(6) NOT NULL,
    updated_time                   DATETIME(6) NOT NULL,
    PRIMARY KEY (delivery_id),
    KEY idx_notification_retry (delivery_status, next_retry_time),
    KEY idx_notification_expiry (expires_time)
);

CREATE TABLE user_data_key (
    user_id            CHAR(26) NOT NULL,
    key_version        INT NOT NULL,
    kms_key_id         VARCHAR(255) NOT NULL,
    encrypted_data_key VARBINARY(2048) NOT NULL,
    key_status         VARCHAR(24) NOT NULL,
    created_time       DATETIME(6) NOT NULL,
    retired_time       DATETIME(6) NULL,
    PRIMARY KEY (user_id, key_version),
    KEY idx_user_data_key_status (user_id, key_status)
);

CREATE TABLE model_processing_consent (
    consent_id      CHAR(26) NOT NULL,
    user_id         CHAR(26) NOT NULL,
    notice_version  VARCHAR(64) NOT NULL,
    provider_scope  JSON NOT NULL,
    consent_status  VARCHAR(16) NOT NULL,
    consent_time    DATETIME(6) NOT NULL,
    revoked_time    DATETIME(6) NULL,
    created_time    DATETIME(6) NOT NULL,
    PRIMARY KEY (consent_id),
    KEY idx_consent_user (user_id, notice_version, consent_status)
);

CREATE TABLE conversation_session (
    session_id       CHAR(26) NOT NULL,
    user_id           CHAR(26) NOT NULL,
    domain_code       VARCHAR(64) NOT NULL,
    lifecycle_status  VARCHAR(24) NOT NULL,
    title_ciphertext  VARBINARY(4096) NULL,
    key_version       INT NULL,
    last_active_time  DATETIME(6) NOT NULL,
    deleted_time      DATETIME(6) NULL,
    created_time      DATETIME(6) NOT NULL,
    updated_time      DATETIME(6) NOT NULL,
    PRIMARY KEY (session_id),
    KEY idx_session_owner_time (user_id, domain_code, deleted_time, last_active_time)
);

CREATE TABLE conversation_turn (
    turn_id                     CHAR(26) NOT NULL,
    session_id                  CHAR(26) NOT NULL,
    user_id                     CHAR(26) NOT NULL,
    sequence_no                 BIGINT NOT NULL,
    user_input_ciphertext       MEDIUMBLOB NOT NULL,
    assistant_output_ciphertext MEDIUMBLOB NULL,
    key_version                 INT NOT NULL,
    status                      VARCHAR(24) NOT NULL,
    interrupt_mode              VARCHAR(16) NULL,
    result_references           JSON NULL,
    failure_code                VARCHAR(64) NULL,
    deleted_time                DATETIME(6) NULL,
    created_time                DATETIME(6) NOT NULL,
    completed_time              DATETIME(6) NULL,
    updated_time                DATETIME(6) NOT NULL,
    PRIMARY KEY (turn_id),
    UNIQUE KEY uk_turn_session_sequence (session_id, sequence_no),
    KEY idx_turn_owner_session (user_id, session_id, deleted_time, sequence_no)
);

CREATE TABLE workflow_execution (
    execution_id       CHAR(26) NOT NULL,
    turn_id             CHAR(26) NOT NULL,
    session_id         CHAR(26) NOT NULL,
    user_id            CHAR(26) NOT NULL,
    domain_code        VARCHAR(64) NOT NULL,
    workflow_id        VARCHAR(128) NOT NULL,
    workflow_version   INT NOT NULL,
    current_node_id    VARCHAR(128) NULL,
    execution_status   VARCHAR(24) NOT NULL,
    workflow_context   JSON NOT NULL,
    failure_code       VARCHAR(64) NULL,
    retry_count        INT NOT NULL DEFAULT 0,
    started_time       DATETIME(6) NULL,
    finished_time      DATETIME(6) NULL,
    created_time       DATETIME(6) NOT NULL,
    updated_time       DATETIME(6) NOT NULL,
    PRIMARY KEY (execution_id),
    UNIQUE KEY uk_execution_turn (turn_id),
    KEY idx_execution_session_status (session_id, execution_status, created_time),
    KEY idx_execution_user_session (user_id, session_id, created_time)
);

CREATE TABLE workflow_definition (
    workflow_id      VARCHAR(128) NOT NULL,
    domain_code      VARCHAR(64) NOT NULL,
    lifecycle_status VARCHAR(24) NOT NULL,
    created_time     DATETIME(6) NOT NULL,
    updated_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (workflow_id),
    UNIQUE KEY uk_workflow_domain (domain_code, workflow_id)
);

CREATE TABLE workflow_definition_version (
    workflow_id      VARCHAR(128) NOT NULL,
    workflow_version INT NOT NULL,
    definition_json  JSON NOT NULL,
    publish_status   VARCHAR(24) NOT NULL,
    published_time   DATETIME(6) NULL,
    created_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (workflow_id, workflow_version),
    KEY idx_workflow_publish (workflow_id, publish_status, published_time)
);

CREATE TABLE prompt_definition_version (
    prompt_id       VARCHAR(128) NOT NULL,
    domain_code     VARCHAR(64) NOT NULL,
    prompt_version  INT NOT NULL,
    prompt_content  MEDIUMTEXT NOT NULL,
    variable_schema JSON NOT NULL,
    output_schema   JSON NULL,
    publish_status  VARCHAR(24) NOT NULL,
    published_time  DATETIME(6) NULL,
    created_time    DATETIME(6) NOT NULL,
    PRIMARY KEY (prompt_id, prompt_version),
    KEY idx_prompt_publish (domain_code, prompt_id, publish_status)
);

CREATE TABLE skill_definition_version (
    skill_id          VARCHAR(128) NOT NULL,
    domain_code       VARCHAR(64) NOT NULL,
    skill_version     INT NOT NULL,
    description       VARCHAR(1000) NOT NULL,
    skill_content     MEDIUMTEXT NOT NULL,
    resource_manifest JSON NULL,
    context_category  JSON NOT NULL,
    publish_status    VARCHAR(24) NOT NULL,
    published_time    DATETIME(6) NULL,
    created_time      DATETIME(6) NOT NULL,
    PRIMARY KEY (skill_id, skill_version),
    KEY idx_skill_publish (domain_code, skill_id, publish_status)
);

CREATE TABLE workflow_artifact_binding (
    binding_id       CHAR(26) NOT NULL,
    workflow_id      VARCHAR(128) NOT NULL,
    workflow_version INT NOT NULL,
    node_id          VARCHAR(128) NOT NULL,
    binding_type     VARCHAR(16) NOT NULL,
    prompt_id        VARCHAR(128) NULL,
    prompt_version   INT NULL,
    skill_id         VARCHAR(128) NULL,
    skill_version    INT NULL,
    created_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (binding_id),
    KEY idx_artifact_binding_node (workflow_id, workflow_version, node_id, binding_type),
    KEY idx_artifact_binding_prompt (prompt_id, prompt_version),
    KEY idx_artifact_binding_skill (skill_id, skill_version)
);

CREATE TABLE memory_point (
    memory_point_id  CHAR(26) NOT NULL,
    user_id          CHAR(26) NOT NULL,
    domain_code      VARCHAR(64) NOT NULL,
    current_version  INT NOT NULL,
    memory_status    VARCHAR(24) NOT NULL,
    source_available TINYINT(1) NOT NULL,
    deleted_time     DATETIME(6) NULL,
    created_time     DATETIME(6) NOT NULL,
    updated_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (memory_point_id),
    KEY idx_memory_user_status (user_id, domain_code, memory_status, deleted_time)
);

CREATE TABLE memory_point_version (
    memory_point_id  CHAR(26) NOT NULL,
    memory_version   INT NOT NULL,
    content_ciphertext MEDIUMBLOB NOT NULL,
    key_version      INT NOT NULL,
    applicability_json JSON NULL,
    uncertainty_json JSON NULL,
    created_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (memory_point_id, memory_version)
);

CREATE TABLE memory_source_reference (
    memory_point_id  CHAR(26) NOT NULL,
    memory_version   INT NOT NULL,
    source_type      VARCHAR(32) NOT NULL,
    source_id        CHAR(26) NOT NULL,
    source_available TINYINT(1) NOT NULL,
    created_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (memory_point_id, memory_version, source_type, source_id)
);

CREATE TABLE psychology_result (
    result_id       CHAR(26) NOT NULL,
    user_id         CHAR(26) NOT NULL,
    session_id      CHAR(26) NOT NULL,
    turn_id         CHAR(26) NOT NULL,
    result_type     VARCHAR(32) NOT NULL,
    current_version INT NOT NULL,
    lifecycle_status VARCHAR(24) NOT NULL,
    deleted_time    DATETIME(6) NULL,
    created_time    DATETIME(6) NOT NULL,
    updated_time    DATETIME(6) NOT NULL,
    PRIMARY KEY (result_id),
    KEY idx_result_user_session (user_id, session_id, result_type, lifecycle_status, deleted_time)
);

CREATE TABLE psychology_result_version (
    result_id          CHAR(26) NOT NULL,
    result_version     INT NOT NULL,
    content_ciphertext MEDIUMBLOB NOT NULL,
    key_version        INT NOT NULL,
    validation_version VARCHAR(64) NOT NULL,
    created_time       DATETIME(6) NOT NULL,
    PRIMARY KEY (result_id, result_version)
);

CREATE TABLE psychology_evidence_reference (
    result_id       CHAR(26) NOT NULL,
    result_version  INT NOT NULL,
    evidence_id     CHAR(26) NOT NULL,
    source_type     VARCHAR(32) NOT NULL,
    source_id       CHAR(26) NOT NULL,
    evidence_type   VARCHAR(32) NOT NULL,
    source_available TINYINT(1) NOT NULL,
    created_time    DATETIME(6) NOT NULL,
    PRIMARY KEY (result_id, result_version, evidence_id)
);

CREATE TABLE domain_event_publication (
    event_id           CHAR(26) NOT NULL,
    event_type         VARCHAR(64) NOT NULL,
    source_type        VARCHAR(64) NOT NULL,
    source_id          CHAR(26) NOT NULL,
    session_id         CHAR(26) NULL,
    turn_id            CHAR(26) NULL,
    event_sequence     BIGINT NULL,
    payload_json       JSON NOT NULL,
    publication_status  VARCHAR(24) NOT NULL,
    published_time     DATETIME(6) NULL,
    retry_count        INT NOT NULL DEFAULT 0,
    created_time       DATETIME(6) NOT NULL,
    PRIMARY KEY (event_id),
    UNIQUE KEY uk_event_session_sequence (session_id, event_sequence),
    KEY idx_event_publication_status (publication_status, created_time),
    KEY idx_event_session_publish (session_id, publication_status, event_sequence)
);

CREATE TABLE domain_event_stream (
    session_id          CHAR(26) NOT NULL,
    next_event_sequence BIGINT NOT NULL,
    updated_time        DATETIME(6) NOT NULL,
    PRIMARY KEY (session_id)
);

CREATE TABLE gateway_event_consumption (
    consumer_group   VARCHAR(128) NOT NULL,
    event_id         CHAR(26) NOT NULL,
    session_id       CHAR(26) NULL,
    event_sequence   BIGINT NULL,
    topic_name       VARCHAR(255) NOT NULL,
    broker_message_id VARCHAR(255) NOT NULL,
    queue_id         INT NULL,
    broker_offset    BIGINT NULL,
    delivery_status  VARCHAR(24) NOT NULL,
    delivered_time   DATETIME(6) NULL,
    created_time     DATETIME(6) NOT NULL,
    PRIMARY KEY (consumer_group, event_id),
    KEY idx_gateway_consumption_session (consumer_group, session_id, created_time)
);
