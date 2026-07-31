# UAM scale, reliability, and capacity plan

**Date:** 30 July 2026  
**Planning population:** at least 6,000 Windows endpoints  
**Confidence:** architectural recommendations are high-confidence; all numerical capacity results below are illustrative until production measurements replace the highlighted assumptions.

## Executive decision

### Architectural correctness

The most defensible initial production topology is:

```text
SQLite transactional outbox
        ↓
idempotent HTTPS ingestion API
        ↓
PostgreSQL durable batch inbox / receipt ledger
        ↓
asynchronous materializers
        ↓
time-partitioned detail tables + longer-lived aggregates
```

Do **not** add an external message broker solely because there are 6,000 endpoints. Endpoint count is not a throughput measure, and the illustrative scenarios below produce modest HTTP request rates once events are batched.

The critical correctness properties are instead:

1. The agent inserts collected events and advances its collector cursor in the **same SQLite transaction**.

2. Events and batches have stable IDs and content hashes.

3. The agent deletes or archives a batch only after a durable server receipt.

4. The server accepts at least once and materializes idempotently.

5. “Accepted,” “materialized,” “quarantined,” and “portal-visible” are distinct states.

6. No layer acknowledges data and then silently drops it under pressure.

PostgreSQL can implement a modest work queue with `FOR UPDATE SKIP LOCKED`; its documentation explicitly identifies queue-like consumers as a valid use. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-select.html "https://www.postgresql.org/docs/current/sql-select.html"))

### Performance

There is not enough evidence to size servers, a broker, PostgreSQL, storage, or WAN capacity from the supplied material. The legacy application uses 500-row SQL chunks, local CSV deferral, detailed and minimum logging modes, and varying filtering/grouping behavior, but it supplies no representative production event-rate or row-size distribution. Its collector checkpoints can also move in the same deferred flow as the data being queued, which is exactly the coupling the replacement must eliminate.

The high illustrative scenario requires approximately:

- **6,667 live events/s** during its modeled morning peak.

- **13,333 events/s** if a three-day fleet backlog must also drain in six hours.

- Only about **36 HTTP requests/s** at 75%-full, 500-event batches for that combined load.

That distinction is important: the likely bottleneck is database materialization and index/WAL amplification, not incoming TCP connection or HTTP request count.

### Cost

No platform-independent monetary conclusion is possible yet.

The likely ordering of fixed operational cost is:

```text
direct-to-final PostgreSQL
    < PostgreSQL inbox + workers
    < external replicated broker + workers + PostgreSQL
```

The PostgreSQL inbox is likely the best reliability-adjusted starting point. An external broker becomes economically defensible when it prevents greater database overprovisioning, supplies a required independent failure domain, or provides genuinely required replay/multi-consumer capabilities.

---

# 1. Variable-based capacity model

## 1.1 Variables

| Variable   | Meaning                                                                                          |
| ---------- | ------------------------------------------------------------------------------------------------ |
| `N_s`      | Enrolled endpoints at site or device class `s`                                                   |
| `a_s(t)`   | Fraction of those endpoints active at time `t`                                                   |
| `r_s,c(t)` | Generated events per active endpoint per second for collector `c`                                |
| `u_c`      | Mean uncompressed serialized bytes per event after endpoint-side minimization                    |
| `ρ(b,m)`   | Compressed-size ÷ uncompressed-size for batch size `b` and event mix `m`                         |
| `B_e`      | Maximum events per batch                                                                         |
| `B_u`      | Maximum uncompressed bytes per batch                                                             |
| `B_c`      | Maximum compressed bytes per batch                                                               |
| `η`        | Mean batch occupancy, from 0 to 1                                                                |
| `H`        | Amortized HTTP, TLS, and envelope bytes per request                                              |
| `o_e`      | Local outbox metadata bytes per event                                                            |
| `f_sqlite` | SQLite page, index, free-space, and fragmentation multiplier                                     |
| `b_db,c`   | Measured PostgreSQL bytes per materialized event, including heap, TOAST, indexes, and free space |
| `b_wal,c`  | PostgreSQL WAL bytes generated per event                                                         |
| `R_d`      | Detail retention days                                                                            |
| `R_a`      | Aggregate retention days                                                                         |
| `μ_a`      | Sustainable durable-acceptance rate                                                              |
| `μ_m`      | Sustainable materialization rate                                                                 |
| `Q_l`      | Local endpoint backlog                                                                           |
| `Q_c`      | Central inbox or queue backlog                                                                   |
| `T_r`      | Required backlog recovery time                                                                   |

Every rate should be retained by collector, site, device class, policy version, agent version, and schema version. A single fleet-wide average hides the tails that determine local disk exhaustion and reconnect peaks.

## 1.2 Events

Fleet event rate:

```text
λ(t) = Σs Σc [N_s × a_s(t) × r_s,c(t)]
```

Events over interval `T`:

```text
E(T) = ∫T λ(t) dt
```

Daily averages are useful for storage, but capacity must use a measured short-window percentile such as five-minute or one-minute p99:

```text
λ_design = max(
    measured five-minute p99,
    measured morning-profile peak,
    required recovery rate
)
```

## 1.3 Batch size and request rate

Effective events per batch:

```text
B_effective =
    η × min(
        B_e,
        floor(B_u / mean_uncompressed_event_bytes),
        floor(B_c / mean_compressed_event_bytes)
    )
```

Request rate:

```text
requests/s = λ(t) / B_effective
```

Daily requests:

```text
requests/day = ceiling(events/day / B_effective)
```

Compression must be measured on whole batches. An average per-event compression ratio is not necessarily valid because repeated field names and repeated domains, paths, and metadata compress differently as batch size and event mix change.

Wire bytes:

```text
wire_bytes(T) =
    Σ compressed_batch_bytes
    + request_count × H
    + measured retransmission overhead
```

## 1.4 Endpoint SQLite disk

Endpoint backlog evolution:

```text
Q_l(t + Δt) =
    max(0,
        Q_l(t)
        + generated_events(Δt)
        - durably_accepted_events(Δt))
```

Approximate local disk:

```text
local_disk =
    Q_l × (mean_event_bytes + o_e) × f_sqlite
    + batch_metadata
    + current_WAL_bytes
    + reserved_checkpoint/free-space headroom
```

Time until the local hard limit:

```text
time_to_full =
    (hard_limit_bytes - current_bytes)
    / positive_backlog_growth_bytes_per_second
```

The main database file alone is not enough. In WAL mode SQLite maintains separate `-wal` and `-shm` files; the WAL is persistent database state and must remain with the database. SQLite WAL also requires all users of the database to be on the same host. ([SQLite](https://www.sqlite.org/wal.html "https://www.sqlite.org/wal.html"))

SQLite defaults to a passive auto-checkpoint after 1,000 WAL pages, but the correct threshold for UAM must be established under its write and upload concurrency rather than accepted as an optimal default. ([SQLite](https://sqlite.org/c3ref/wal_autocheckpoint.html "https://sqlite.org/c3ref/wal_autocheckpoint.html"))

## 1.5 Central backlog and queue depth

Track central depth in four units:

```text
batches
events
compressed bytes
oldest accepted age
```

Backlog evolution:

```text
Q_c(t + Δt) =
    max(0,
        Q_c(t)
        + durably_accepted_events(Δt)
        - materialized_events(Δt))
```

Oldest age is the most operationally useful signal. A depth of one million events may represent seconds or hours depending on event rate and processing capacity.

## 1.6 Recovery rate

For live rate `λ`, backlog `B`, and target recovery time `T_r`:

```text
required materialization rate:

μ_required = λ + B / T_r
```

Actual recovery time:

```text
T_recovery = B / (μ_sustainable - λ)
```

This equation is valid only when:

```text
μ_sustainable > λ
```

If sustainable processing is less than or equal to live input, the system never recovers regardless of queue depth.

Equivalent batch acceptance rate:

```text
required requests/s = μ_required / B_effective
```

## 1.7 Database growth, indexes, and WAL

Per-event stored bytes:

```text
b_db,c =
    heap_bytes/event
    + TOAST_bytes/event
    + Σ index_bytes/event
    + free-space/visibility-map allocation
```

Daily detail growth:

```text
detail_bytes/day = Σc events_c/day × b_db,c
```

Retained detail:

```text
detail_retained =
    detail_bytes/day × R_d × storage_headroom_factor
```

Aggregate storage:

```text
aggregate_retained =
    aggregate_rows/day
    × aggregate_bytes/row
    × R_a
    × storage_headroom_factor
```

Total working storage must also include:

```text
detail
+ aggregates
+ durable inbox
+ deduplication ledgers
+ indexes
+ WAL retained for replication/archive
+ temporary load/index space
+ backup staging
```

Do not infer `b_db,c` from declared `varchar` maxima. Measure the delta in `pg_table_size`, `pg_indexes_size`, and `pg_total_relation_size` divided by inserted rows. PostgreSQL defines `pg_total_relation_size` as table data plus indexes and TOAST-related storage. ([PostgreSQL](https://www.postgresql.org/docs/current/functions-admin.html "https://www.postgresql.org/docs/current/functions-admin.html"))

WAL amplification:

```text
WAL bytes/event =
    Δ pg_stat_wal.wal_bytes
    / committed materialized events
```

PostgreSQL exposes total generated WAL bytes in `pg_stat_wal`. ([PostgreSQL](https://www.postgresql.org/docs/current/monitoring-stats.html "https://www.postgresql.org/docs/current/monitoring-stats.html"))

## 1.8 Retention purge

For time-partitioned detail:

```text
purge duration =
    aggregate finalization
    + reconciliation
    + detach/drop partition
    + catalog/replication propagation
```

Dropping or detaching a partition avoids row-by-row deletion and its vacuum burden. `DETACH PARTITION CONCURRENTLY` reduces the parent-table lock level compared with a normal detach, subject to PostgreSQL’s documented restrictions. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))

## 1.9 Backup and recovery

Approximate disaster recovery time:

```text
RTO =
    environment provisioning
    + backup transfer
    + base restore bytes / restore throughput
    + WAL bytes to replay / replay throughput
    + application validation
    + cutover
```

PITR requires an uninterrupted sequence of archived WAL beginning at or before the base backup. `pg_verifybackup` verifies a base backup against its manifest, but only an actual restore proves the complete procedure. ([PostgreSQL](https://www.postgresql.org/docs/current/app-pgverifybackup.html "https://www.postgresql.org/docs/current/app-pgverifybackup.html"))

## 1.10 Policy fan-out

For `N_online` online endpoints, policy package size `P`, rollout window `W`, and cache hit fraction `h`:

```text
policy requests/s = N_online / W

origin bytes =
    N_online × P × (1 - h)
```

Policy traffic should have an independent quota and connection pool from telemetry ingestion so a policy release cannot consume the ingestion error budget.

---

# 2. Low, base, and high illustrative scenarios

## 2.1 Replaceable inputs

All bold values in this section are **assumptions**, not production facts.

Common assumptions:

- Fleet: 6,000 enrolled endpoints.

- Batch cap: **500 events**.

- Mean occupancy: **75%**, giving 375 effective events per batch.

- Detail retention: **30 days**.

- Aggregate retention: **400 days**.

- Database storage headroom: **25%**.

- Local outbox metadata: **120 bytes/event**.

- SQLite storage multiplier: **1.6×**.

- A “morning multiplier” applies to the full-day mean for illustration.

| Assumed input                        | Low       | Base        | High        |
| ------------------------------------ | --------- | ----------- | ----------- |
| Active fleet fraction                | **60%**   | **80%**     | **100%**    |
| Events per active endpoint/day       | **250**   | **1,500**   | **8,000**   |
| Uncompressed serialized bytes/event  | **350 B** | **650 B**   | **1,200 B** |
| Compressed ÷ uncompressed bytes      | **45%**   | **35%**     | **30%**     |
| PostgreSQL stored bytes/detail event | **750 B** | **1,300 B** | **2,500 B** |
| Morning rate multiplier              | **4×**    | **8×**      | **12×**     |
| Aggregate rows/active endpoint/day   | **5**     | **25**      | **100**     |
| Aggregate stored bytes/row           | **300 B** | **350 B**   | **450 B**   |

The database-byte assumptions deliberately include indexes and storage overhead. They are not derived from the legacy column maxima. The legacy DDL contains fields such as 2,000-byte URLs and paths and does not provide a representative length distribution or a complete new index design.

## 2.2 Throughput and recovery results

| Calculated result                                       | Low         | Base        | High        |
| ------------------------------------------------------- | ----------- | ----------- | ----------- |
| Active endpoints                                        | 3,600       | 4,800       | 6,000       |
| Events/day                                              | 0.90 M      | 7.20 M      | 48.0 M      |
| Full-day mean events/s                                  | 10.4        | 83.3        | 555.6       |
| Modeled morning events/s                                | 41.7        | 666.7       | 6,666.7     |
| Modeled morning requests/s                              | 0.11        | 1.78        | 17.78       |
| Requests/day                                            | 2,400       | 19,200      | 128,000     |
| Uncompressed payload/day                                | 0.315 GB    | 4.68 GB     | 57.6 GB     |
| Compressed payload/day                                  | 0.142 GB    | 1.638 GB    | 17.28 GB    |
| Events generated in 30-minute morning-peak outage       | 75,000      | 1.20 M      | 12.0 M      |
| Corresponding compressed backlog                        | 11.8 MB     | 273 MB      | 4.32 GB     |
| Corresponding batches                                   | 200         | 3,200       | 32,000      |
| Three-day fleet backlog                                 | 2.70 M      | 21.6 M      | 144 M       |
| Extra events/s to drain three days in six hours         | 125         | 1,000       | 6,666.7     |
| Morning live rate plus six-hour drain                   | 166.7       | 1,666.7     | 13,333.3    |
| Combined requests/s for that worst overlap              | 0.44        | 4.44        | 35.56       |
| Fleet bandwidth to drain three-day backlog in six hours | 0.16 Mbit/s | 1.82 Mbit/s | 19.2 Mbit/s |

A 30-minute **complete API outage** leaves this backlog on agents. A 30-minute **worker or final-database outage while the inbox remains available** leaves it centrally in the inbox or broker.

The high worked example is:

```text
daily events
= 6,000 × 8,000
= 48,000,000

morning live rate
= 48,000,000 / 86,400 × 12
≈ 6,667 events/s

three-day backlog
= 144,000,000 events

six-hour drain increment
= 144,000,000 / 21,600
≈ 6,667 events/s

combined requirement
≈ 13,333 events/s
```

This is why a recovery capacity target cannot be expressed as “support 6,000 clients.” It must be expressed as an event and byte service rate under a defined backlog and recovery objective.

## 2.3 Storage results

| Calculated result                           | Low      | Base     | High     |
| ------------------------------------------- | -------- | -------- | -------- |
| Detail storage/day                          | 0.675 GB | 9.36 GB  | 120 GB   |
| 30-day detail plus 25% headroom             | 25.3 GB  | 351 GB   | 4.50 TB  |
| 400-day aggregate plus 25% headroom         | 2.7 GB   | 21.0 GB  | 135 GB   |
| Local outbox for three days/active endpoint | 0.54 MiB | 5.29 MiB | 48.3 MiB |
| Local outbox for 30 days/active endpoint    | 5.38 MiB | 52.9 MiB | 483 MiB  |
| Monthly compressed ingress                  | 4.25 GB  | 49.1 GB  | 518 GB   |
| Monthly batch requests                      | 72,000   | 576,000  | 3.84 M   |

### Interpretation

The HTTP rates are modest even in the high case. They do not independently justify a broker.

The high storage case is not modest. A handful of additional indexes, larger event values, or a higher event rate could make retained detail several terabytes. Retention and index design therefore need to be benchmarked before hardware selection.

A 512 MiB local soft cap happens to cover approximately 30 days in this high synthetic case. That does **not** prove it is sufficient: extension inventories, long paths, low compression, SQLite fragmentation, or different collector behavior could invalidate it.

The network result suggests that aggregate WAN bandwidth might not be the primary bottleneck under these assumptions, but a site with a small link, high packet loss, a restrictive proxy, or a disproportionate share of offline endpoints can still violate its recovery objective. Capacity must therefore be calculated per site as well as fleet-wide.

---

# 3. Proposed SLOs, SLIs, and error budgets

These are starting targets to ratify after the measurement period and first load tests.

## 3.1 State definitions

```text
collected:
    collector produced an eligible event

local_committed:
    event and collector cursor committed atomically to SQLite

accepted:
    server returned a receipt after durable central acceptance

materialized:
    all valid events in the batch committed to final tables,
    or the batch was explicitly quarantined with a terminal reason

visible:
    portal/API query path can retrieve the materialized data
```

For the PostgreSQL-inbox design, acceptance should use normal durable commit behavior. Turning `synchronous_commit` off explicitly trades away certainty that a reported commit is durable and is therefore inappropriate for the acknowledgement boundary. ([PostgreSQL](https://www.postgresql.org/docs/current/runtime-config-wal.html "https://www.postgresql.org/docs/current/runtime-config-wal.html"))

The required failure-domain durability must also be declared. A local WAL flush protects against process and many host crashes, but zero loss after an availability-zone failure requires acknowledgement after replication to the required independent failure domain.

## 3.2 Starting objectives

| Objective                      | SLI                                                                                  | Proposed target                                                         | Error budget                                                                        |
| ------------------------------ | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Agent local acceptance         | Successful eligible collector transactions ÷ eligible collector transactions         | **99.99% monthly**, with p99 commit latency ≤ **1 s**                   | 100 failed or delayed commits per million; silent loss is not allowed               |
| Durable ingestion availability | Accepted or identical-duplicate receipts ÷ eligible valid attempts                   | **99.95% monthly**                                                      | 0.05% of eligible attempts, equivalent to 21 min 36 s in a 30-day time-based budget |
| Acceptance latency             | Durable receipt time minus server request start                                      | p99 ≤ **2 s**, p99.9 ≤ **5 s** at design load                           | 0.1% may exceed 5 s                                                                 |
| Steady materialization         | `processed_at - accepted_at` for valid batches                                       | 99% ≤ **15 min**, 99.9% ≤ **60 min**                                    | 1% and 0.1% of valid events respectively                                            |
| Thirty-minute outage recovery  | Time after service restoration until backlog age is back below 15 minutes            | 99% of backlog within **60 min**                                        | One failed recovery drill triggers release blocking until understood                |
| Multi-day reconnect recovery   | Time to drain the defined three-day design backlog while meeting live SLO            | 99% within **6 h**                                                      | Scenario-based, not averaged into monthly availability                              |
| Acknowledged-data loss         | Accepted receipt ledger reconciled against retained/materialized/quarantined batches | **Zero** missing acknowledged batches in the declared failure scope     | No error budget; any mismatch pages                                                 |
| Duplicate materialization      | Final duplicate event keys ÷ final event keys                                        | **Zero** duplicate final rows                                           | Duplicate requests are expected; duplicate stored events are not                    |
| Portal query success           | Successful bounded portal queries ÷ eligible queries                                 | **99.9% monthly**                                                       | 43 min 12 s in 30 days                                                              |
| Portal latency                 | Defined query-class latency                                                          | p95 ≤ **2 s**, p99 ≤ **5 s**                                            | Queries without required time or tenant bounds are excluded and rejected            |
| Policy propagation             | Online agents reporting target policy version                                        | 99% within **30 min** of ordinary release                               | Emergency targets require a separate, tested mode                                   |
| DR—single failure domain       | Acknowledged receipt recovery                                                        | **RPO 0** for the failure domain covered by synchronous acknowledgement | No data-loss budget                                                                 |
| DR—regional disaster           | Restored state from backup/WAL                                                       | Initial hypothesis: **RPO ≤5 min, RTO ≤4 h**                            | Must be demonstrated quarterly                                                      |

### Measurement cautions

“Source event time to portal visibility” is useful but depends on endpoint clock quality. Maintain three separate latency measurements:

```text
local queue delay:        first_upload_attempt - local_enqueue
central acceptance delay: accepted_at - server_request_start
materialization delay:    processed_at - accepted_at
```

Use source-event freshness only for devices whose measured clock skew is within an approved threshold.

A server-generated 429 or 503 because the system cannot accept more data counts against durable-ingestion availability. Invalid authentication, unsupported schema, corrupt checksum, and bodies exceeding documented limits are client-invalid attempts and are tracked separately.

HTTP defines `Retry-After` for temporary unavailability and permits it with 429 rate-limiting responses; agents should honor it. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html "https://www.rfc-editor.org/rfc/rfc9110.html"))

---

# 4. Initial batch, retry, quota, and backpressure hypotheses

Every value in this section is a **test hypothesis**, not final tuning.

## 4.1 Agent and API starting values

| Control                              | Starting hypothesis                                       | Falsification criterion                                                                   |
| ------------------------------------ | --------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Batch event cap                      | 500 events                                                | Lower if p99 body/decode/transaction latency worsens; raise if request overhead dominates |
| Batch uncompressed target            | 1 MiB                                                     | Lower if proxies, memory, or validation latency suffer                                    |
| Compressed HTTP body hard limit      | 1 MiB                                                     | Change only after proxy/site testing                                                      |
| Decompressed body hard limit         | 4 MiB                                                     | Change only with memory and decompression-abuse tests                                     |
| Compression-ratio guard              | 20:1 maximum                                              | Tune from valid p99.99 compression without permitting decompression bombs                 |
| Time flush                           | 60 seconds                                                | Shorten if freshness fails; lengthen if tiny batches dominate                             |
| In-flight requests/device            | 1                                                         | Allow 2 only through a server-issued recovery lease                                       |
| Connection timeout                   | 5 seconds                                                 | Increase only for measured proxy/VPN behavior                                             |
| Overall request timeout              | 30 seconds                                                | Must remain safely above the 5-second acceptance SLO                                      |
| Retry                                | Full-jitter exponential, base 1 s, cap 15 min             | Tune from reconnect tests and server protection                                           |
| Retry lifetime                       | Continue while retained by outbox policy                  | No arbitrary fixed attempt count for network/server outages                               |
| Normal device quota                  | 4 requests/min, burst 2                                   | Raise only if legitimate normal batches are throttled                                     |
| Recovery device cap                  | 1 request/s when recovery tokens are granted              | Must also obey global and site budgets                                                    |
| Server recovery budget               | 25% of measured spare acceptance/materialization capacity | Increase only if live freshness remains protected                                         |
| Supported schemas                    | Current and immediately previous version                  | Extend only if migration data supports it                                                 |
| Deep-invalid batch                   | Durable quarantine; no hot retry loop                     | Terminal validation failures must not consume worker capacity repeatedly                  |
| Same batch ID, same hash             | Return original successful receipt                        | Any other result breaks idempotency                                                       |
| Same batch ID, different hash        | 409 conflict and security/integrity alert                 | Never overwrite original content                                                          |
| Unsupported schema before acceptance | 422 with supported-version metadata                       | Agent retains batch and reduces retry frequency                                           |
| Too large                            | 413                                                       | Agent splits the batch without changing event IDs                                         |

The legacy 500-row SQL chunks make 500 a convenient compatibility experiment, not a proven optimum.

## 4.2 Local disk hypotheses

| Control                  | Starting hypothesis                                                                                              |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| Soft cap                 | `min(512 MiB, device-class policy limit)`                                                                        |
| Hard cap                 | `min(2 GiB, 2% of system volume)`                                                                                |
| Free-space floor         | Preserve at least `max(2 GiB, 5% of volume)`                                                                     |
| Maximum ordinary age     | 30 days                                                                                                          |
| Outbox warning           | Oldest pending >6 h or bytes >50% of soft cap                                                                    |
| Backpressure at soft cap | Pause diagnostics and slow lowest-priority detailed collectors; preserve mandatory aggregates and health records |
| At hard cap              | Apply only an explicitly signed retention/drop policy and generate a durable gap record; never silently delete   |
| WAL management           | Measure main DB, WAL, and SHM; run passive diagnostics rather than deleting WAL files                            |

SQLite can retain a large reusable WAL after checkpointing; `journal_size_limit` can limit the residual WAL size, but setting it must be tested against write latency. Journaling must not be disabled because that removes atomic commit/rollback protection. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))

## 4.3 Server worker hypotheses

| Control                              | Starting hypothesis                                                 |
| ------------------------------------ | ------------------------------------------------------------------- |
| Materializer processes               | 4                                                                   |
| Simultaneous DB-writing transactions | 8 total                                                             |
| Worker connection pool               | 16 total, including operational headroom                            |
| Load transaction size                | 5,000 events or 5 MiB decoded data, whichever comes first           |
| Inbox lease                          | 120 seconds, renewed every 30 seconds                               |
| Target transaction duration          | Under 30 seconds                                                    |
| Worker prefetch with broker          | 8 batches/worker                                                    |
| Deterministic poison threshold       | 3 identical terminal failures, then quarantine                      |
| Transient infrastructure retries     | Unlimited while retained, with bounded jitter and alerting          |
| Partition creation                   | Current interval plus the next two intervals pre-created            |
| Partition probe                      | Synthetic insert and bounded query at least hourly                  |
| Policy poll                          | Every 15 minutes plus uniform 0–15-minute jitter                    |
| Emergency policy poll                | Separate tested mode, not an unbounded fleet-wide immediate request |

Benchmark binary `COPY` against parameterized multi-row inserts. PostgreSQL documents `COPY` as optimized for loading large numbers of rows with less overhead than a series of inserts. ([PostgreSQL](https://www.postgresql.org/docs/current/populate.html "https://www.postgresql.org/docs/current/populate.html"))

## 4.4 Resilience behavior by required scenario

| Scenario                             | Required behavior                                                                         | Primary pass condition                                           |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| Steady state                         | Randomize collector and upload phase; no fleet-wide minute boundary                       | Freshness and latency SLOs with ≥30% measured resource headroom  |
| Morning peak                         | Reproduce measured active-user ramp and batch-flush distribution                          | No queue-age growth after the peak ends                          |
| One-hour client outage               | Continue atomic local collection; no upload spin                                          | All retained events upload once connectivity returns             |
| Multi-day client outage              | Enforce local age/byte policy and site-fair recovery                                      | Live traffic remains healthy while backlog meets six-hour target |
| Thirty-minute API outage             | No acknowledgement; agents honor jitter and `Retry-After`                                 | No reconnect cliff and no event loss                             |
| Thirty-minute worker/final-DB outage | Inbox continues accepting until its explicit capacity threshold                           | Central backlog drains within objective                          |
| Simultaneous policy update           | ETag/conditional fetch, immutable version, randomized rollout, cached payload             | 99% online adoption without ingestion degradation                |
| Poison payload                       | Preserve immutable payload/hash in restricted quarantine and continue unrelated work      | No infinite retry or blocked partition                           |
| Schema mismatch                      | Reject before acceptance when version is unsupported; report required upgrade             | No hot retry storm                                               |
| Duplicate batch                      | Idempotent receipt for same content                                                       | One receipt and one materialization                              |
| Slow database                        | Reduce worker concurrency, protect acceptance pool, then return 429/503 before exhaustion | No acknowledged drop or connection-pool collapse                 |
| Missing partition                    | Inbox accepts; materializer pauses affected rows and pages operator                       | No writes into an accidental unbounded default partition         |
| Partition rollover                   | Pre-created partition, index and query-plan checks                                        | No ingestion errors or query-plan regression                     |
| Backup/restore                       | Base backup, continuous WAL archive, integrity verification, full restore drill           | Tested RPO/RTO and successful reconciliation                     |
| Retention purge                      | Finalize aggregates, reconcile, detach/drop partition                                     | Bounded lock time and no aggregate gap                           |
| Regional/site constraint             | Per-site token budget and weighted fairness                                               | One recovering site cannot starve another                        |

---

# 5. Queue versus PostgreSQL inbox decision

## 5.1 Decision matrix

| Criterion                             | Direct transaction to final PostgreSQL         | PostgreSQL durable inbox + workers  | External durable queue + workers                                       |
| ------------------------------------- | ---------------------------------------------- | ----------------------------------- | ---------------------------------------------------------------------- |
| Components                            | Lowest                                         | Moderate                            | Highest                                                                |
| Durable acceptance                    | After final insert transaction                 | After inbox/receipt commit          | After broker publisher confirmation                                    |
| Final-DB coupling                     | Complete                                       | Reduced, but shared if same cluster | Lowest when broker is independent                                      |
| Poison isolation                      | Must validate before commit                    | Strong quarantine/replay point      | Strong DLQ/replay point                                                |
| Schema evolution                      | Most difficult                                 | Controlled async materialization    | Controlled async materialization                                       |
| Reprocessing                          | Requires final-table or retained-source replay | Inbox payload can be replayed       | Native queue/log retention, depending broker                           |
| Backpressure                          | Immediate 429/503                              | Inbox depth and DB capacity         | Broker depth and publisher rejection                                   |
| Operational burden                    | Lowest                                         | Usually acceptable                  | Broker clustering, storage, monitoring, upgrades and client semantics  |
| Database write amplification          | Final rows only                                | Inbox WAL/storage plus final rows   | Receipt/dedup plus final rows; broker has separate replication/storage |
| Independent acceptance failure domain | No                                             | Only with a separate ingest cluster | Yes, when broker is independently operated                             |
| Multi-consumer fan-out                | Poor                                           | Possible but database-driven        | Best                                                                   |
| Recommended role                      | Benchmark control and low-complexity option    | **Initial production default**      | Add only after a measured threshold is crossed                         |

## 5.2 Recommended PostgreSQL inbox design

Use two logical structures:

### Durable receipt and deduplication ledger

```text
ingest_receipt
---------------
tenant_id
device_id
batch_id
payload_hash
event_count
compressed_bytes
uncompressed_bytes
schema_version
accepted_at
state
attempt_count
next_attempt_at
lease_owner
lease_until
processed_at
quarantined_at
terminal_reason_code
```

Primary uniqueness:

```text
UNIQUE (tenant_id, device_id, batch_id)
```

The receipt table should be unpartitioned initially, or use a separate unpartitioned deduplication table if the payload inbox is partitioned.

### Payload storage

Benchmark:

1. Compressed immutable `bytea` payload in PostgreSQL.

2. Parsed inbox rows.

3. Compressed object storage plus a PostgreSQL receipt, only if inbox payload/WAL costs become material.

The object-storage option is not initially simpler: the object put and database receipt are separate systems and require idempotent object keys plus reconciliation.

Workers claim work in a short transaction with a queue-like `SKIP LOCKED` query, then materialize in an idempotent transaction. PostgreSQL documents that `SKIP LOCKED` is suitable for avoiding contention among consumers of a queue-like table. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-select.html "https://www.postgresql.org/docs/current/sql-select.html"))

## 5.3 Partitioned-table uniqueness constraint

PostgreSQL requires a unique or primary-key constraint on a partitioned table to include every partition-key column. It cannot directly enforce an event ID that is globally unique across time partitions unless the time partition key is included. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))

Use one of these patterns:

1. An unpartitioned batch deduplication ledger plus atomic whole-batch materialization.

2. Final-table uniqueness on `(event_date, tenant_id, event_id)` and an immutable event timestamp.

3. A separate compact global event-ID ledger if cross-batch event duplication is a material observed risk.

Benchmark the storage and WAL cost of option 3 before adopting it for every event.

## 5.4 External-queue requirements

When a broker is selected, require:

- Replicated durable queues or streams.

- Publisher confirmation before the API sends its receipt.

- Manual consumer acknowledgement only after the PostgreSQL transaction commits.

- Explicit queue-length and byte limits.

- Reject-publish behavior rather than silent head dropping.

- Durable DLQ and a tested at-least-once dead-letter path.

- Idempotent database consumers.

RabbitMQ documents publisher confirms and consumer acknowledgements as separate, orthogonal mechanisms that are both needed for reliable delivery. Its quorum-queue documentation also shows that at-least-once dead lettering and reject-publish overflow must be configured explicitly; duplicates can still occur and must be handled. ([RabbitMQ](https://www.rabbitmq.com/docs/confirms "https://www.rabbitmq.com/docs/confirms"))

A broker does not increase PostgreSQL’s final materialization throughput. It changes where backlog is held and which failures can be isolated.

## 5.5 Explicit break-even gates

Define:

```text
λ_accept_required =
    max(live peak batch rate,
        live batch rate + reconnect batches / recovery target)

μ_materialize_required =
    live peak event rate
    + reconnect events / recovery target
```

Retain the PostgreSQL inbox when all of these pass:

```text
measured μ_pg_accept ≥ 1.5 × λ_accept_required
measured μ_materialize ≥ 1.5 × μ_materialize_required
p99 durable receipt ≤ 2 s
p99.9 durable receipt ≤ 5 s
central inbox storage remains inside its tested outage budget
final-table load does not starve the acceptance path
```

The **1.5× headroom** is an initial gate, not a universal constant.

Add an external broker when one or more of these conditions is demonstrated:

| Trigger                          | Starting decision threshold                                                                                                |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| PostgreSQL acceptance saturation | Inbox cannot maintain 1.5× required acceptance while meeting latency SLO                                                   |
| Shared failure-domain problem    | Final DB slowdown/failover repeatedly consumes acceptance error budget                                                     |
| Long central buffering           | Required central buffer exceeds **24 hours** or **25% of usable ingest-cluster storage**, as an initial decision threshold |
| Replay requirement               | Immutable replay must be retained independently of PostgreSQL for days or weeks                                            |
| Multiple consumers               | Two or more independent consumers need their own offsets, replay, and deployment cadence                                   |
| Regional ingestion               | Sites must durably accept during loss of the primary database region                                                       |
| Existing operations              | Organization already has a managed broker with a stronger demonstrated SLO than a new PostgreSQL queue                     |
| Cost crossover                   | Broker service and operations cost less than the database overprovisioning and outage-risk cost it eliminates              |

Cost comparison:

```text
monthly total =
    fixed service cost
    + compute
    + durable storage and replication
    + backup
    + network
    + monitoring
    + operator/on-call hours
    + expected outage impact
```

Report these unit costs:

```text
cost per million accepted batches
cost per million materialized events
cost per retained GB-month
WAL bytes per event
CPU-seconds per million events
operator hours per month
```

---

# 6. Load-test architecture for 6,000+ agents

## 6.1 Test system

```text
Scenario controller and deterministic run manifest
                    │
        ┌───────────┴────────────┐
        │                        │
Stateful agent simulator     Windows fidelity cohort
6,000–12,000 logical IDs     real agent/outbox binaries
        │                        │
        └───────────┬────────────┘
                    │
        WAN/proxy fault layer
                    │
             Load balancer/API
                    │
        PostgreSQL inbox or broker
                    │
                 Workers
                    │
          Partitioned PostgreSQL
                    │
        Control API and portal queries

Expected-event ledger and reconciliation run in parallel.
```

### Stateful simulator

The authoritative simulator should use the production implementations of:

- Batch serialization.

- Compression.

- Stable event and batch IDs.

- Retry and jitter.

- Receipt handling.

- Schema negotiation.

- Sequence and cursor behavior.

It should model 6,000 logical endpoints without requiring 6,000 operating-system processes. Each endpoint retains independent state, clock offset, site, policy version, outbox depth, and retry schedule.

A smaller Windows fidelity cohort should run real SQLite files and the actual transport library to validate locking, WAL growth, disk-full behavior, sleep/resume, and service restart behavior.

### Open-model API generator

Use an open-arrival-rate load for API saturation testing so the offered load does not fall when the service becomes slow. k6’s arrival-rate executors start work independently of response time, whereas a closed model can hide overload by reducing new work as latency rises. The k6 operator can distribute those runs across Kubernetes jobs. ([Grafana Labs](https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/constant-arrival-rate/ "https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/constant-arrival-rate/"))

The stateful simulator remains authoritative for endpoint behavior; k6 is the transport and API capacity instrument.

## 6.2 Traffic shapes

Each test run must identify the source of its shape: measured production distribution or synthetic hypothesis.

| Shape                      | Definition                                                                 |
| -------------------------- | -------------------------------------------------------------------------- |
| Stable day                 | Measured collector mix and batch intervals at ordinary load                |
| Morning ramp               | Active fraction and collector activity ramp over 15–90 minutes             |
| Synchronized worst case    | Deliberately align collector completion to demonstrate protection          |
| One-hour site outage       | Selected site cannot upload, but continues collecting                      |
| Three-day fleet outage     | Pre-generate three days of stable event IDs and timestamps, then reconnect |
| Thirty-minute API outage   | Reject all API traffic, followed by jittered recovery                      |
| Thirty-minute worker pause | Continue durable acceptance while materialization is stopped               |
| Policy fan-out             | 6,000 conditional requests plus selected downloads                         |
| Duplicate storm            | 1%, 10%, and 100% replay of already accepted batch IDs                     |
| Schema transition          | Current, N−1, unsupported, and malformed envelopes                         |
| Poison distribution        | Deterministic malformed events at 0.01%, 0.1%, and 1%                      |
| Payload distribution       | Measured p50/p95/p99/max sizes, not only a fixed body                      |
| Slow portal workload       | Defined read-query concurrency during peak ingestion                       |
| Retention rollover         | Attach/create/detach partitions while loading                              |
| Backup pressure            | Backup and WAL archive activity during peak ingestion                      |

## 6.3 Fault injection

Inject faults at controlled timestamps:

- API process termination and rolling deployment.

- Load-balancer connection reset.

- DNS failure and delayed DNS.

- Proxy authentication failure.

- Latency, jitter, bandwidth limitation, packet loss, timeout, and half-open connection.

- Broker leader/node loss.

- Worker crash before and after final DB commit.

- PostgreSQL primary failover.

- Connection pool exhaustion.

- Slow fsync and IOPS restriction.

- WAL archive failure.

- Full data disk and full local endpoint disk.

- Missing future partition.

- Lock held during partition operation.

- Clock step forward/backward and DST transitions.

- Corrupt compressed body and declared-size mismatch.

Toxiproxy supports latency jitter, probabilistic toxicity, and connection timeouts and is appropriate for repeatable TCP fault injection. ([GitHub](https://github.com/shopify/toxiproxy "https://github.com/shopify/toxiproxy"))

## 6.4 Data safety

Use only generated test values:

```text
example.invalid domains
synthetic paths
synthetic process metadata
test-only tenants and certificates
non-production policy signing keys
```

Do not copy browser histories, recent-item paths, usernames, device identities, or production URLs into performance environments.

The generator should create payload distributions with similar lengths and repetition characteristics without reproducing real values.

## 6.5 Clocks and timestamps

Every synthetic event should carry:

```text
event_time
local_enqueue_time
first_attempt_time
accepted_at
materialized_at
portal_visible_at
logical device clock offset
monotonic duration timestamps
```

Test:

- Normal skew ±5 minutes.

- Rare skew ±24 hours.

- Clock moving backward.

- Europe/Amsterdam DST changes.

- Device sleep and resume.

- Events arriving up to the maximum offline retention age.

## 6.6 Observability and reproducibility

Every run manifest records:

```text
run ID and random seed
source-control commit
container and package digests
database schema migration
agent/API/worker versions
scenario parameters
site topology
fault timeline
hardware/cloud shape
PostgreSQL settings
index and partition definitions
expected event and batch counts
```

The expected ledger should reconcile:

```text
generated events
locally committed events
accepted batches
materialized events
quarantined events
deliberately rejected events
duplicate attempts
```

Use histograms for request duration, materialization duration, event size, batch size, outbox age, and freshness. OpenTelemetry defines histograms for statistically meaningful distributions such as durations and payload sizes. ([OpenTelemetry](https://opentelemetry.io/docs/specs/otel/metrics/api/ "https://opentelemetry.io/docs/specs/otel/metrics/api/"))

Do not use device ID, user ID, URL, path, batch ID, or event ID as time-series labels.

---

# 7. Test stages and pass/fail gates

| Stage                   | Scope                             | Principal tests                                                                    | Gate                                                                                      |
| ----------------------- | --------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| 0. Model and protocol   | Unit/property tests               | Stable IDs, cursor/outbox atomicity, duplicate receipts, crash points, body limits | Zero invariant violation across at least 1 million generated operations                   |
| 1. Developer machine    | 100–500 logical agents            | End-to-end API, inbox, worker, final tables                                        | Exact reconciliation; no unexplained retry                                                |
| 2. Windows VM           | Real agent library and SQLite     | Restart, disk full, sleep, WAL/checkpoint, local quotas                            | No cursor advance without outbox row; no acknowledged row re-sent with different identity |
| 3. Component benchmarks | API, inbox, worker, DB separately | Acceptance saturation, decode, COPY/insert, index amplification                    | Reproducible service-rate and cost curves                                                 |
| 4. Integrated base      | 6,000 agents, base scenario       | Stable day and morning peak                                                        | All SLOs; ≥30% measured CPU, I/O, connection, and disk headroom                           |
| 5. Recovery             | 6,000 agents                      | 30-minute outage and three-day replay                                              | Recovery equation and target both pass                                                    |
| 6. High/stress          | 6,000 then 12,000 logical agents  | High assumptions and ramp beyond knee                                              | System rejects safely; no acknowledged loss; saturation point documented                  |
| 7. Fault campaign       | Integrated pre-production         | All fault scenarios from section 6                                                 | Expected failure behavior and alerting for every injected fault                           |
| 8. Soak                 | 72 hours minimum                  | Base plus daily peaks, rollover, policy release, backup                            | No unbounded memory, disk, WAL, retry, or bloat trend                                     |
| 9. DR exercise          | Isolated restore environment      | Base backup, WAL replay, reconciliation, portal smoke tests                        | RPO/RTO achieved and signed evidence retained                                             |

## Capacity pass gate

For the selected design scenario:

```text
measured sustainable acceptance
    ≥ 1.5 × required batch acceptance rate

measured sustainable materialization
    ≥ 1.5 × required event materialization rate
```

At that rate:

- p99.9 durable acceptance remains within five seconds.

- Oldest backlog age decreases.

- No connection pool reaches exhaustion.

- No sustained resource exceeds the agreed operating ceiling.

- Portal query SLO remains intact.

- WAL archive and replica lag remain within the DR objective.

The test must continue past the pass point until the knee is found. A capacity statement without a measured saturation point has no quantified headroom.

---

# 8. PostgreSQL partition, index, retention, and restore benchmark plan

## 8.1 Benchmark datasets

Generate data at:

```text
1× target detail retention
3× target detail retention
12× target detail retention
```

For every size, include:

- Actual measured event-type proportions.

- Measured p50/p95/p99 string and payload lengths.

- Duplicate attempts.

- Late arrivals at one hour, three days, and 30 days.

- High-cardinality and low-cardinality users/devices.

- Skewed sites and collectors.

- Old partitions plus the current hot partition.

## 8.2 Partition candidates

Benchmark, do not preselect:

| Candidate                           | Expected trade-off                                                                |
| ----------------------------------- | --------------------------------------------------------------------------------- |
| Daily range partitions              | Fast, granular retention; more catalog objects and planning work                  |
| Weekly range partitions             | Fewer objects; larger purge and index units                                       |
| Monthly range partitions            | Simple at low volumes; potentially multi-terabyte hot partitions in the high case |
| Time plus limited hash subpartition | Helps only if demonstrated write or tenant skew justifies added partitions        |

Use `event_date` for final detail when portal queries and retention are event-time based. Use `accepted_at` for the inbox.

Test late arrivals explicitly: event-time partitioning means a reconnect writes into older partitions.

PostgreSQL warns that too many partitions increase planning time and memory, so daily versus weekly versus monthly must be decided from the benchmark rather than a convention. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))

## 8.3 Ingest method matrix

Benchmark:

```text
parameterized multi-row insert:
    500, 1,000, and 5,000 rows

binary COPY:
    1,000, 5,000, and 20,000 rows

worker concurrency:
    1, 2, 4, 8, and 16 transactions
```

Collect:

```text
events/s
transaction p50/p95/p99
WAL bytes/event
heap bytes/event
index bytes/event
CPU-seconds/million events
read/write/fsync latency
lock waits
checkpoint behavior
replica and archive lag
```

## 8.4 Index candidates

### Inbox

```sql
UNIQUE (tenant_id, device_id, batch_id)
```

Candidate work index:

```sql
CREATE INDEX ON ingest_batch (next_attempt_at, accepted_at)
WHERE processed_at IS NULL
  AND quarantined_at IS NULL;
```

Partial indexes contain only selected rows and can reduce index size and update work when the interesting subset is small. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-createindex.html "https://www.postgresql.org/docs/current/sql-createindex.html"))

### Detail tables

Benchmark only indexes tied to defined portal/API query classes:

```text
(tenant_id, event_time)
(tenant_id, device_id, event_time)
(tenant_id, pseudonymous_user_id, event_time)
(tenant_id, collector, event_time)
```

Also test BRIN on `event_time` for large append-correlated partitions. BRIN summarizes physical block ranges and is designed for very large tables whose values correlate with physical row order. ([PostgreSQL](https://www.postgresql.org/docs/current/brin.html "https://www.postgresql.org/docs/current/brin.html"))

Do not automatically B-tree index raw URL, path, or process-path strings. Prefer:

- A fixed-size fingerprint for equality/deduplication.

- A normalized dimension table where justified.

- A purpose-specific text index only when a required portal query demonstrates the need.

## 8.5 Read workload

Define query classes before indexing:

| Query class                  | Required bounds                       |
| ---------------------------- | ------------------------------------- |
| Device activity              | Tenant, device, time range            |
| User activity                | Tenant, pseudonymous user, time range |
| Collector summary            | Tenant, collector, date range         |
| Domain/application aggregate | Tenant, aggregate key, date range     |
| Operational receipt lookup   | Tenant, device, batch ID              |
| Error/quarantine search      | Tenant, reason class, acceptance time |

For every plan:

- Verify partition pruning with `EXPLAIN (ANALYZE, BUFFERS, WAL)`.

- Record partitions opened.

- Record rows scanned versus returned.

- Reject portal queries that omit mandatory tenant and time bounds.

Partition pruning is driven by partition bounds rather than merely by the presence of an index. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))

## 8.6 Rollover and retention benchmark

Test under peak write and read load:

1. Pre-create the next partition.

2. Build/attach indexes.

3. Run manual `ANALYZE` where required.

4. Insert boundary timestamps.

5. Run portal query probes.

6. Finalize aggregate watermark for the oldest partition.

7. Reconcile count and checksum.

8. `DETACH PARTITION CONCURRENTLY`.

9. Drop after the required backup/grace period.

PostgreSQL does not automatically `ANALYZE` the partitioned parent because the parent stores no tuples, although it processes the individual partitions. Run parent analysis after initial population and significant distribution changes. ([PostgreSQL](https://www.postgresql.org/docs/current/routine-vacuuming.html "https://www.postgresql.org/docs/current/routine-vacuuming.html"))

Avoid routine row-by-row purge followed by `VACUUM FULL`. `VACUUM FULL` rewrites the table, requires extra disk space, and takes an exclusive lock. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-vacuum.html "https://www.postgresql.org/docs/current/sql-vacuum.html"))

## 8.7 Database benchmark pass criteria

- Required materialization rate passes with 1.5× headroom.

- WAL archive and replica lag remain within objective.

- Defined portal queries meet p95/p99 targets.

- All bounded queries prune irrelevant partitions.

- Rollover produces no ingestion failure.

- Detach/drop lock time is within the tested operational limit.

- Aggregate completeness is verified before detail removal.

- No routine operation requires `VACUUM FULL`.

- Restore throughput and WAL replay achieve the DR target.

- Parent and child statistics remain current.

- Storage growth prediction is within ±15% of measured growth over the soak.

---

# 9. Dashboard and alert specification

## 9.1 Dashboards

| Dashboard       | Required panels                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------ |
| Fleet health    | Online agents, version distribution, schema distribution, policy adoption, site/device class                 |
| Agent outbox    | Pending events/bytes p50/p95/p99, oldest age, time-to-full, SQLite/WAL bytes, local commit latency           |
| Collection      | Events generated/retained by collector, endpoint filtering ratio, collection failures and duration           |
| Upload          | Attempts, accepted, duplicate receipts, 4xx/429/5xx, retries, batch occupancy, body sizes, compression ratio |
| Ingestion       | Requests/s, events/s, bytes/s, durable-acceptance p50/p95/p99, pool saturation                               |
| Central backlog | Batches, events, compressed bytes, oldest age, accept rate, process rate, calculated recovery ETA            |
| Workers         | Active leases, transaction sizes, materialization rate, retry reasons, poison/quarantine                     |
| Integrity       | Accepted-versus-materialized counts, batch checksum mismatches, duplicate conflicts, sequence gaps           |
| Freshness       | Local queue, accepted-to-materialized, materialized-to-visible distributions                                 |
| PostgreSQL      | Connections, transactions, WAL/s, WAL bytes/event, replica/archive lag, I/O and fsync, checkpoints           |
| Storage         | Table/index/TOAST size by partition, inbox size, dedup ledger, retained days, disk forecast                  |
| Maintenance     | Partition horizon, rollover status, autovacuum/analyze, backup, verification and restore status              |
| Portal          | Query success, p50/p95/p99 by query class, timeouts, rows scanned/returned                                   |
| Site/WAN        | RTT, connect/TLS/upload duration, status, throughput, recovery allocation, proxy failures                    |
| Cost            | CPU and storage units per million events, retained GB-month, queue operations, network, operator effort      |

PostgreSQL exposes activity, replication, I/O, WAL, and checkpoint statistics through its cumulative statistics views; `pg_stat_io` should be combined with operating-system metrics for a complete I/O picture. ([PostgreSQL](https://www.postgresql.org/docs/current/monitoring-stats.html "https://www.postgresql.org/docs/current/monitoring-stats.html"))

## 9.2 Page-level alerts

| Condition                                          | Initial threshold                                                      |
| -------------------------------------------------- | ---------------------------------------------------------------------- |
| Acknowledged receipt missing in reconciliation     | Any occurrence                                                         |
| Duplicate batch ID with different hash             | Any occurrence                                                         |
| Materialization count or checksum mismatch         | Any occurrence                                                         |
| Current partition missing or boundary insert fails | Any occurrence                                                         |
| Ingestion SLO burn                                 | Fast and slow multi-window burn against 99.95%                         |
| Backlog freshness                                  | Oldest accepted age >15 min for 10 min and still increasing            |
| Recovery failure                                   | Calculated ETA exceeds the active recovery objective                   |
| Inbox/queue unable to accept                       | Any sustained reject other than deliberate quota control               |
| PostgreSQL connections                             | >85% available application pool for 10 min                             |
| Disk exhaustion                                    | <20% free or forecast to hard limit in seven days                      |
| WAL archive                                        | Failed archive or lag beyond DR RPO                                    |
| Replica lag                                        | Beyond declared acknowledgement/failover objective                     |
| Quarantine                                         | Sudden terminal-invalid rate above measured baseline                   |
| Unsupported schema                                 | >1% of online endpoints or increasing for 15 min                       |
| Local outbox                                       | Fleet p99 oldest age >6 h or any endpoint class approaching hard limit |
| Backup/restore validation                          | Verification or scheduled restore failure                              |

## 9.3 Warning/ticket alerts

- Batch occupancy falls below 50% for a day.

- Compression ratio shifts by more than 25% from collector/version baseline.

- Retry rate doubles without a matching outage.

- Policy adoption misses 95% in 30 minutes.

- Parent partition statistics become stale.

- Dead tuples or index size grows faster than event count.

- Portal rows-scanned/rows-returned ratio regresses.

- Cost per million events increases by more than 20%.

- A site repeatedly consumes its recovery quota.

- WAL bytes/event changes materially after a schema or index release.

---

# 10. Missing measurements and exact instrumentation

## 10.1 Minimum production measurement period

Collect **28 consecutive days** to capture repeated weekdays, weekends, morning patterns, upgrades, VPN use, and ordinary short outages.

Use:

- Metadata-only summaries from all endpoints.

- A rotating 5% cohort for detailed size and timing histograms.

- Server-side batch measurements for every request.

- No raw URL, domain, path, process value, username, or event payload in capacity telemetry.

## 10.2 Missing endpoint measurements

| Missing value                   | Required breakdown                                           |
| ------------------------------- | ------------------------------------------------------------ |
| Active endpoint curve           | Five-minute interval, site, device class, weekday            |
| Events produced                 | Collector, policy, detailed/minimum mode, agent version      |
| Events retained after filtering | Same breakdown as generated                                  |
| Event size                      | p50/p90/p95/p99/max by collector and schema                  |
| Batch size                      | Event count and compressed/uncompressed bytes                |
| Batch flush reason              | Event limit, byte limit, timer, shutdown, recovery           |
| Compression                     | Ratio by event mix and batch-size bucket                     |
| SQLite cost                     | DB, WAL and SHM bytes; pages; free pages; commit latency     |
| Local queue                     | Rows, bytes, oldest age, growth rate and time-to-full        |
| Upload                          | Attempt, accepted, duplicate, throttled, rejected and failed |
| Retry                           | Attempt count, previous status class, chosen delay           |
| Clocks                          | Estimated skew class and monotonic durations                 |
| Disk pressure                   | Free bytes, cap class, backpressure action                   |
| Recovery                        | Backlog before and after reconnect and achieved drain rate   |

### Proposed agent metrics

```text
uam_agent_events_generated_total{collector,result}
uam_agent_events_retained_total{collector}
uam_agent_event_serialized_bytes{collector,schema_version}
uam_agent_collection_duration_seconds{collector,result}
uam_agent_outbox_events
uam_agent_outbox_bytes
uam_agent_outbox_oldest_age_seconds
uam_agent_outbox_commit_duration_seconds
uam_agent_sqlite_db_bytes
uam_agent_sqlite_wal_bytes
uam_agent_batch_events{flush_reason}
uam_agent_batch_uncompressed_bytes{flush_reason}
uam_agent_batch_compressed_bytes{flush_reason}
uam_agent_upload_duration_seconds{outcome}
uam_agent_upload_attempts_total{outcome,status_class}
uam_agent_retry_delay_seconds{reason}
uam_agent_policy_version
```

Labels must remain bounded. Device identity belongs in a secured operational record, not in metric labels.

### Proposed SQLite metadata query

This assumes the replacement outbox records `serialized_bytes` and `enqueued_utc`:

```sql
SELECT
    collector,
    COUNT(*) AS pending_events,
    COALESCE(SUM(serialized_bytes), 0) AS serialized_bytes,
    MIN(enqueued_utc) AS oldest_enqueued_utc,
    CAST(
        (julianday('now') - julianday(MIN(enqueued_utc))) * 86400
        AS INTEGER
    ) AS oldest_age_seconds
FROM outbox_event
WHERE state IN ('pending', 'batched')
GROUP BY collector;
```

Periodic diagnostic—not every scrape:

```sql
PRAGMA journal_mode;
PRAGMA page_size;
PRAGMA page_count;
PRAGMA freelist_count;
PRAGMA wal_autocheckpoint;
PRAGMA journal_size_limit;
PRAGMA wal_checkpoint(PASSIVE);
```

Physical disk accounting must stat all three files:

```text
outbox.db
outbox.db-wal
outbox.db-shm
```

Approximate allocated main-database bytes:

```text
page_count × page_size
```

Approximate occupied main-database bytes:

```text
(page_count - freelist_count) × page_size
```

## 10.3 New PostgreSQL ingestion measurements

Assumed tables below are illustrative:

```text
uam.ingest_batch
uam.batch_materialization
uam.event_detail
```

### Intake per minute

```sql
SELECT
    date_trunc('minute', accepted_at) AS minute_utc,
    COUNT(*) AS batches,
    SUM(event_count) AS events,
    SUM(compressed_bytes) AS compressed_bytes,
    SUM(uncompressed_bytes) AS uncompressed_bytes
FROM uam.ingest_batch
WHERE accepted_at >= now() - interval '28 days'
GROUP BY 1
ORDER BY 1;
```

### Batch distributions

```sql
SELECT
    percentile_cont(ARRAY[0.50, 0.90, 0.95, 0.99])
        WITHIN GROUP (ORDER BY event_count) AS event_count_percentiles,
    percentile_cont(ARRAY[0.50, 0.90, 0.95, 0.99])
        WITHIN GROUP (ORDER BY compressed_bytes) AS compressed_byte_percentiles,
    percentile_cont(ARRAY[0.50, 0.90, 0.95, 0.99])
        WITHIN GROUP (ORDER BY uncompressed_bytes) AS uncompressed_byte_percentiles,
    AVG(compressed_bytes::numeric / NULLIF(uncompressed_bytes, 0))
        AS mean_compression_ratio
FROM uam.ingest_batch
WHERE accepted_at >= now() - interval '28 days';
```

### Central backlog

```sql
SELECT
    state,
    COUNT(*) AS batches,
    COALESCE(SUM(event_count), 0) AS events,
    COALESCE(SUM(compressed_bytes), 0) AS compressed_bytes,
    MIN(accepted_at) AS oldest_accepted_at,
    now() - MIN(accepted_at) AS oldest_age
FROM uam.ingest_batch
WHERE processed_at IS NULL
  AND quarantined_at IS NULL
GROUP BY state
ORDER BY state;
```

### Materialization throughput and delay

```sql
SELECT
    date_trunc('minute', processed_at) AS minute_utc,
    COUNT(*) AS batches,
    SUM(event_count) AS events,
    percentile_cont(ARRAY[0.50, 0.95, 0.99])
        WITHIN GROUP (
            ORDER BY EXTRACT(EPOCH FROM processed_at - accepted_at)
        ) AS materialization_seconds
FROM uam.ingest_batch
WHERE processed_at >= now() - interval '24 hours'
GROUP BY 1
ORDER BY 1;
```

### Integrity reconciliation

Maintain one audit row per materialized batch:

```sql
SELECT
    tenant_id,
    device_id,
    batch_id,
    expected_event_count,
    inserted_event_count,
    expected_event_hash,
    inserted_event_hash
FROM uam.batch_materialization
WHERE expected_event_count <> inserted_event_count
   OR expected_event_hash <> inserted_event_hash;
```

The expected result is always zero rows.

### Partition sizes

```sql
SELECT
    relid::regclass AS partition_name,
    pg_table_size(relid) AS table_bytes,
    pg_indexes_size(relid) AS index_bytes,
    pg_total_relation_size(relid) AS total_bytes
FROM pg_partition_tree('uam.event_detail'::regclass)
WHERE isleaf
ORDER BY relid::regclass::text;
```

### WAL sample

Take deltas over a known load interval:

```sql
SELECT
    now() AS sampled_at,
    wal_records,
    wal_fpi,
    wal_bytes,
    wal_buffers_full
FROM pg_stat_wal;
```

### I/O sample

```sql
SELECT
    backend_type,
    object,
    context,
    reads,
    read_time,
    writes,
    write_time,
    fsyncs,
    fsync_time
FROM pg_stat_io
ORDER BY backend_type, object, context;
```

### Expensive statements

```sql
SELECT
    queryid,
    calls,
    total_exec_time,
    mean_exec_time,
    rows,
    shared_blks_read,
    shared_blks_written,
    temp_blks_written,
    wal_bytes
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 30;
```

`pg_stat_statements` records planning and execution statistics by normalized query identity and must be enabled explicitly. ([PostgreSQL](https://www.postgresql.org/docs/current/pgstatstatements.html "https://www.postgresql.org/docs/current/pgstatstatements.html"))

## 10.4 Safe measurements from the legacy SQL Server

The supplied schema contains structure but no production row counts or value lengths. The following measurements should preferably run against a recent restored backup or read-only replica.

### Table rows and allocated bytes

```sql
SELECT
    s.name AS schema_name,
    t.name AS table_name,
    SUM(
        CASE WHEN ps.index_id IN (0, 1)
             THEN ps.row_count
             ELSE 0
        END
    ) AS row_count,
    SUM(ps.reserved_page_count) * 8192 AS reserved_bytes,
    SUM(ps.used_page_count) * 8192 AS used_bytes
FROM sys.dm_db_partition_stats AS ps
JOIN sys.tables AS t
  ON t.object_id = ps.object_id
JOIN sys.schemas AS s
  ON s.schema_id = t.schema_id
WHERE t.name IN
(
    'DeviceBrowserLogging',
    'DeviceProcessLogging',
    'DeviceRecentFileAndFolderLogging',
    'uam_log_minimal',
    'uam_log_minimal_dates'
)
GROUP BY s.name, t.name
ORDER BY reserved_bytes DESC;
```

Microsoft documents `sys.dm_db_partition_stats` as providing row-count and page information for database partitions. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-objects/sys-dm-db-partition-stats-transact-sql?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-objects/sys-dm-db-partition-stats-transact-sql?view=sql-server-ver17"))

### Event rate by hour on a restored copy

The legacy DDL does not show a suitable timestamp index on the live detail tables, so this scan should not be introduced on the production primary without DBA review.

```sql
WITH event_times AS
(
    SELECT 'browser' AS collector, datetimestamp
    FROM dbo.DeviceBrowserLogging

    UNION ALL

    SELECT 'process', datetimestamp
    FROM dbo.DeviceProcessLogging

    UNION ALL

    SELECT 'recent', datetimestamp
    FROM dbo.DeviceRecentFileAndFolderLogging
)
SELECT
    collector,
    DATEADD(hour, DATEDIFF(hour, 0, datetimestamp), 0) AS hour_bucket,
    COUNT_BIG(*) AS events
FROM event_times
WHERE datetimestamp >= DATEADD(day, -28, GETDATE())
GROUP BY
    collector,
    DATEADD(hour, DATEDIFF(hour, 0, datetimestamp), 0)
ORDER BY hour_bucket, collector;
```

### Value-length sampling without reading values into results

```sql
WITH sampled AS
(
    SELECT
        'browser' AS collector,
        COALESCE(DATALENGTH(computername), 0)
      + COALESCE(DATALENGTH(username), 0)
      + COALESCE(DATALENGTH(userdomain), 0)
      + COALESCE(DATALENGTH(browser), 0)
      + COALESCE(DATALENGTH(domain), 0)
      + COALESCE(DATALENGTH(url), 0)
      + 32 AS payload_bytes
    FROM dbo.DeviceBrowserLogging
         TABLESAMPLE SYSTEM (100000 ROWS) REPEATABLE (20260730)

    UNION ALL

    SELECT
        'process',
        COALESCE(DATALENGTH(computername), 0)
      + COALESCE(DATALENGTH(username), 0)
      + COALESCE(DATALENGTH(userdomain), 0)
      + COALESCE(DATALENGTH(processname), 0)
      + COALESCE(DATALENGTH(FullpathExecutable), 0)
      + COALESCE(DATALENGTH(product), 0)
      + COALESCE(DATALENGTH(company), 0)
      + 32
    FROM dbo.DeviceProcessLogging
         TABLESAMPLE SYSTEM (100000 ROWS) REPEATABLE (20260730)

    UNION ALL

    SELECT
        'recent',
        COALESCE(DATALENGTH(computername), 0)
      + COALESCE(DATALENGTH(username), 0)
      + COALESCE(DATALENGTH(userdomain), 0)
      + COALESCE(DATALENGTH(pathRecentfileandfolder), 0)
      + COALESCE(DATALENGTH(attributes), 0)
      + 48
    FROM dbo.DeviceRecentFileAndFolderLogging
         TABLESAMPLE SYSTEM (100000 ROWS) REPEATABLE (20260730)
)
SELECT DISTINCT
    collector,
    COUNT(*) OVER (PARTITION BY collector) AS sampled_rows,
    AVG(CAST(payload_bytes AS decimal(18,2)))
        OVER (PARTITION BY collector) AS mean_payload_bytes,
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY payload_bytes)
        OVER (PARTITION BY collector) AS p50_payload_bytes,
    PERCENTILE_CONT(0.95)
        WITHIN GROUP (ORDER BY payload_bytes)
        OVER (PARTITION BY collector) AS p95_payload_bytes,
    PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY payload_bytes)
        OVER (PARTITION BY collector) AS p99_payload_bytes
FROM sampled;
```

`DATALENGTH` returns the number of bytes used to represent an expression and is appropriate for variable-length strings. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/functions/datalength-transact-sql?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/t-sql/functions/datalength-transact-sql?view=sql-server-ver17"))

Do not casually enable SQL-text capture to measure this legacy workload. The agent builds SQL containing event values, so Query Store or Extended Events configurations that retain full statement text may capture sensitive URLs and paths. Use metadata-only agent instrumentation or a sanitized restored database instead. The legacy code’s dynamic SQL behavior is visible in the reference, while Microsoft documents that Query Store retains query and runtime history. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver17"))

## 10.5 Network and site measurements

For each bounded site/device class, collect:

```text
online endpoints per five-minute interval
DNS duration
TCP connect duration
TLS duration
time to first byte
total upload duration
request and response bytes
HTTP status class
proxy/VPN failure code
retransmission or packet-loss indicator where available
effective successful bytes/s
outage start and end
backlog before reconnect
achieved drain rate
```

Calculate:

```text
site required bandwidth =
    live compressed bytes/s
    + site backlog bytes / site recovery target

site recovery time =
    site backlog bytes
    / (allocated recovery bandwidth - live bandwidth)
```

The denominator must be positive.

## 10.6 Portal measurements

Instrument by a finite query-class identifier, not raw SQL text or user input:

```text
query count
success/failure
duration histogram
rows returned
rows scanned where available
partitions touched
cache hit
timeout
requested time span
```

Produce a frequency-weighted benchmark corpus from those classes.

## 10.7 Backup and restore measurements

Record for every backup and restore drill:

```text
base backup bytes
base backup duration
WAL generated during backup
WAL archive lag
verification result
restore transfer throughput
base restore duration
WAL replay bytes and duration
database startup duration
application validation duration
reconciliation result
final RPO and RTO
```

## 10.8 Cost measurements

Collect monthly:

```text
API CPU/memory-hours
worker CPU/memory-hours
PostgreSQL compute and IOPS
inbox bytes and WAL bytes
detail and index GB-month
backup GB-month
broker messages and replicated bytes, if used
network ingress/egress
monitoring volume
operator and on-call hours
```

Normalize by accepted batches, materialized events, and retained bytes.

---

# Final commitment gates

Do not commit to a broker, PostgreSQL machine size, partition grain, index set, or local disk cap until all of the following are complete:

1. A 28-day metadata-only production measurement establishes event, byte, active-endpoint, batch, retry, and outage distributions.

2. The direct-to-final and PostgreSQL-inbox designs are benchmarked on identical data and hardware.

3. Management selects the design scenario and explicit recovery objectives.

4. The chosen design passes the 6,000-agent morning and reconnect tests with at least 1.5× measured service-rate headroom.

5. A 72-hour soak, partition rollover, purge, backup, and full restore pass.

6. Reconciliation proves zero missing acknowledged batches and zero duplicate final event keys.

Until a break-even gate is crossed, **PostgreSQL durable inbox plus workers is the best defensible default**: it creates a clear acceptance boundary, isolates poison and schema evolution, enables controlled replay, and avoids introducing an externally operated queue whose capacity is not yet shown to be necessary.
