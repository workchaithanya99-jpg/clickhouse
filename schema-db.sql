CREATE TABLE IF NOT EXISTS observability.db_inventory
(
    ts DateTime, source LowCardinality(String), region LowCardinality(String), identifier String, cluster String,
    role LowCardinality(String), engine LowCardinality(String), engine_version String, instance_class LowCardinality(String),
    status LowCardinality(String), endpoint String, port UInt16, cluster_endpoint String, reader_endpoint String,
    az LowCardinality(String), multi_az UInt8, storage_gb UInt32, storage_type LowCardinality(String),
    db_name String, master_user String, publicly_accessible UInt8, vpc_id String, security_groups Array(String),
    parameter_group String, backup_retention UInt16, deletion_protection UInt8, perf_insights UInt8, encrypted UInt8, created DateTime
)
ENGINE = MergeTree PARTITION BY toDate(ts) ORDER BY (ts, region, identifier)
TTL ts + INTERVAL 14 DAY SETTINGS ttl_only_drop_parts = 1;

CREATE TABLE IF NOT EXISTS observability.service_inventory
(
    ts DateTime, namespace LowCardinality(String), name String, type LowCardinality(String), cluster_ip String,
    dns String, ports Array(String), port_numbers Array(UInt16), external_host String
)
ENGINE = MergeTree PARTITION BY toDate(ts) ORDER BY (ts, namespace, name)
TTL ts + INTERVAL 14 DAY SETTINGS ttl_only_drop_parts = 1;

CREATE VIEW IF NOT EXISTS observability.db_latest AS
SELECT * FROM observability.db_inventory WHERE ts = (SELECT max(ts) FROM observability.db_inventory);

CREATE VIEW IF NOT EXISTS observability.service_latest AS
SELECT * FROM observability.service_inventory WHERE ts = (SELECT max(ts) FROM observability.service_inventory);
