# 0000. Record architecture decisions

## About this document

This record is the decision about how decisions are recorded in this repository. It is for anyone about to write, supersede or look for a decision record. It states the format, the threshold for a record and the fields each one carries. It does not record any architectural decision of its own. Update it only when the way records are kept changes.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Context and problem statement

The reasons behind Resnip lived in one table, `docs/DECISIONS.md`, next to the rules and the open questions. A reader could not tell a binding ruling from a past mistake, and a refused option left no trace for the next person to propose it again.

## Decision outcome

Decisions are recorded with MADR, one decision per file in `docs/decisions/`, named `NNNN-title-with-dashes.md` and numbered in order.

A decision earns a record only if at least one of these holds:

- it is architecturally significant
- it is expensive to reverse
- it is likely to be proposed again

Anything smaller is one line in [CONTRIBUTING.md](../CONTRIBUTING.md) or one sentence in [ARCHITECTURE.md](../ARCHITECTURE.md).

Every record carries a title, status, date, decision-makers, context and problem statement, decision outcome, consequences, and considered options where an option was explicitly refused. Each record opens with an "About this document" section. A long record adds a "Summary".

The date of the first records is the day they were written down, 2026-10-15. The decisions themselves were taken while the library was built, from 2026-10-10 on.

At the repository root, `README.md` introduces the repository and `AGENTS.md` sends anyone who works on it to `docs/CONTRIBUTING.md` first. The documents under `docs/` keep to one layout: `CONTRIBUTING.md`, `ARCHITECTURE.md`, `PENDING.md`, the records here, and `reference/`. A reference describes one external tool alone and cites no other document. Our documents may cite a reference, and a reference never cites them.

## Consequences

- A record is never rewritten to change its outcome. A new record supersedes it, and the old one's status says so.
- A record states what is true and why. Git keeps how the text changed.
- A measurement that backs a decision keeps its method and its number.
- A figure that moves with configuration is stated as it is today and re-read before it is cited.
- There is no `PRINCIPLES.md`, because this repository has no values shared with other repositories.
