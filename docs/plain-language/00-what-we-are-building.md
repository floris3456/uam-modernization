# What we are building

## The short version

We are replacing an old Windows activity-monitoring system with a safer and easier-to-operate system.

The Windows client will collect a deliberately limited set of application and browser activity, transform it according to approved privacy rules, keep it safely when the network is unavailable, and send it to a server. The server will accept each item once, retain only allowed data, and later support authorized administration and reporting.

We are **not building that whole system at once**. We first build evidence that its most important rules can be tested reliably.

## Why the first milestone is fictional data

Before reading a real browser profile or sending real activity, we need a small fictional world with known answers. That world lets us prove rules such as:

- the same source item is not counted twice;
- a saved cursor never skips an unseen item;
- private URL parts are removed as required;
- offline items survive interruption and retry;
- one realm cannot read another realm's data;
- failures have explicit, recoverable states.

The expected answers are produced independently from the implementation. Otherwise the test could repeat the same mistake as the product.

## Main parts planned later

1. A Windows coordinator and per-user host.
2. Safe browser-history acquisition and transformation.
3. A local SQLite outbox for disconnected operation.
4. An authenticated ingestion service with a durable server inbox.
5. Retention, deletion, audit, diagnostics, and operational controls.
6. A portal, real authorization, and migration tooling when their later milestones are approved.

## What this repository is today

It is a planning and evidence repository. It contains the legacy handover, completed technical research, proposed architecture decisions, and the pre-implementation structure for G0. Production code and production approval do not exist yet.
