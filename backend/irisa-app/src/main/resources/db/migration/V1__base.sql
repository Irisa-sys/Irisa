CREATE TABLE ledger_entry (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '账本行号，只增不改（可软删）',
    player_id       BIGINT NOT NULL COMMENT '逻辑玩家 id，无 FK；身份表后建',
    game_slug       VARCHAR(32) NOT NULL COMMENT '写入方游戏 slug',
    type            VARCHAR(32) NOT NULL COMMENT 'PATHOLOGY / CASE_OPENED / VERDICT / OATH / DEBT / BANKRUPTCY',
    business_key    VARCHAR(128) NULL COMMENT '幂等键；需幂等必须非空',
    payload_json    JSON NOT NULL COMMENT '结构化摘要',
    content_sha256  CHAR(64) NULL COMMENT 'ES 原文哈希',
    create_time     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    is_deleted      TINYINT(1) NOT NULL DEFAULT 0,
    deleted_time    TIMESTAMP(3) NOT NULL DEFAULT '2100-01-01 00:00:00',
    KEY idx_ledger_player_type (player_id, type, create_time),
    UNIQUE KEY uk_ledger_idem (game_slug, type, business_key, is_deleted)
) COMMENT '不可变账本。基座表，不引用 player';

CREATE TABLE event_log (
    id             BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '事件 id',
    type           VARCHAR(64) NOT NULL COMMENT '已登记 type',
    producer       VARCHAR(32) NOT NULL COMMENT '生产模块 slug',
    player_id      BIGINT NOT NULL COMMENT '逻辑玩家 id，无 FK',
    business_key   VARCHAR(128) NOT NULL COMMENT '与 producer+type 唯一',
    payload_json   JSON NOT NULL,
    schema_version INT NOT NULL DEFAULT 1,
    apply_status   VARCHAR(16) NOT NULL DEFAULT 'PENDING' COMMENT '画像副作用：PENDING / DONE / DEAD；由 identity 消费',
    apply_error    VARCHAR(255) NULL COMMENT '最近一次失败原因，DONE 时为空',
    attempt_count  INT NOT NULL DEFAULT 0,
    applied_time   TIMESTAMP(3) NULL COMMENT '首次成功处理时间',
    create_time    TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '业务发生时间',
    update_time    TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    is_deleted     TINYINT(1) NOT NULL DEFAULT 0,
    deleted_time   TIMESTAMP(3) NOT NULL DEFAULT '2100-01-01 00:00:00',
    UNIQUE KEY uk_event_idem (producer, type, business_key, is_deleted),
    KEY idx_event_apply (apply_status, is_deleted, id),
    KEY idx_event_player_time (player_id, create_time)
) COMMENT '领域事件。基座只 append；apply_status 由 identity 改分消费';

CREATE TABLE index_job (
    id            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '共享语料作业 id',
    player_id     BIGINT NOT NULL COMMENT '逻辑玩家 id，无 FK',
    ref_id        VARCHAR(64) NOT NULL COMMENT '文档 _id，与 ES 幂等键相同',
    source        VARCHAR(32) NOT NULL COMMENT '交出方 slug',
    op            VARCHAR(16) NOT NULL COMMENT 'UPSERT / DELETE',
    sha256        CHAR(64) NULL COMMENT '正文哈希，对账用',
    body          MEDIUMTEXT NULL COMMENT 'UPSERT 时的长文；DELETE 可空',
    status        VARCHAR(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING / INDEXED / DEAD',
    attempt_count INT NOT NULL DEFAULT 0,
    last_error    VARCHAR(255) NULL,
    create_time   TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    update_time   TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    is_deleted    TINYINT(1) NOT NULL DEFAULT 0,
    deleted_time  TIMESTAMP(3) NOT NULL DEFAULT '2100-01-01 00:00:00',
    UNIQUE KEY uk_corpus_ref (source, ref_id, is_deleted),
    KEY idx_index_status (status, is_deleted, id),
    KEY idx_index_player (player_id, source)
) COMMENT '共享语料 outbox。worker embedding 后写入基座共享索引';

CREATE TABLE agent_usage (
    id            BIGINT PRIMARY KEY AUTO_INCREMENT,
    player_id     BIGINT NOT NULL COMMENT '逻辑玩家 id，无 FK',
    game_slug     VARCHAR(32) NOT NULL,
    role          VARCHAR(64) NOT NULL,
    provider      VARCHAR(32) NOT NULL COMMENT 'script / openai',
    tokens_in     INT NOT NULL DEFAULT 0,
    tokens_out    INT NOT NULL DEFAULT 0,
    duration_ms   INT NOT NULL DEFAULT 0,
    status        VARCHAR(24) NOT NULL COMMENT 'OK / FAILED / BUDGET_EXHAUSTED',
    create_time   TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    is_deleted    TINYINT(1) NOT NULL DEFAULT 0,
    deleted_time  TIMESTAMP(3) NOT NULL DEFAULT '2100-01-01 00:00:00',
    KEY idx_usage_player_game (player_id, game_slug, create_time)
) COMMENT '模型调用用量。不含 prompt 正文';
