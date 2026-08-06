# MOCK synthesis — heading-anchor conventions

## Human summary

**What this is:** a format-proof package whose subject is the repository's own link rule. The study verified how GitHub, VS Code, and the zaaack Markdown Editor derive heading anchors, and concluded the repository validator's ASCII slug algorithm matches GitHub for the practical case.

**The recommendation in one paragraph:** keep the validator's current slugify (lowercase, strip non-word characters, spaces to hyphens) for ASCII headings; rename headings that need non-ASCII characters to ASCII equivalents instead of relying on renderer agreement, because the extension's non-ASCII behavior is UNVERIFIED.

**In one line:** links that pass validation resolve in the user's editor and on GitHub.

## Verified slug rules

**FACT.** GitHub, VS Code, and CommonMark-based editors share the core anchor algorithm: lowercase, remove punctuation, collapse space runs to hyphens, disambiguate duplicates with numeric suffixes. The repository validator implements this for ASCII headings.

## Renderer behavior notes

Non-ASCII headings are kept by GitHub but the extension behavior is **UNVERIFIED**; the safe rule is ASCII-only headings.

## Consequence for this repository

The anchor rule in `research/WORKFLOW.md` and the validator's `slugify` are confirmed as-is. New templates keep mandating stable ASCII heading anchors.
