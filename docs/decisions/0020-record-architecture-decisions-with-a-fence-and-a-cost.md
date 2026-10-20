# 0020. Record architecture decisions with a fence and a cost

## About this document

This record is the decision about how decisions are recorded in this repository, and it replaces [0000](./0000-record-architecture-decisions.md). It is for anyone about to write, supersede or look for a decision record. It states the format, the threshold for a record, the fields each one carries and the layout of `docs/`. It does not record any architectural decision of its own. Update it only when the way records are kept changes.

- Status: accepted
- Date: 2026-10-19
- Decision-makers: the maintainer
- Supersedes: [0000](./0000-record-architecture-decisions.md)

## Summary

- A record is a fence with its reason written on it. Write one only if a reasonable newcomer would be tempted to change the choice and changing it would do harm.
- Every record says what breaks if the decision is undone.
- Never write a record for a workaround, a convention nobody would break or a description of the code.

## Context and problem statement

Record 0000 let a decision in if it was architecturally significant, expensive to reverse or likely to be proposed again. The first criterion admits choices that nobody would think of undoing, and none of the three asks what the record protects. Several records state their decision and their measurements and never say what goes wrong without them, so a reader cannot tell a fence from a description.

## Decision outcome

Decisions are recorded with MADR (Markdown Architectural Decision Records), which follows Nygard's "Documenting Architecture Decisions", one decision per file in `docs/decisions/`, named `NNNN-title-with-dashes.md` and numbered in order.

A decision earns a record only if a reasonable newcomer would be tempted to change it, and changing it would do harm. It is a fence with its reason written on it, the situation Chesterton's fence describes.

Three things are not records, and each has a home.

| What it is | Where it goes |
| --- | --- |
| A temporary workaround or a known debt | [PENDING.md](../PENDING.md), or a comment beside the code |
| A convention nobody would be tempted to break | One line in [CONTRIBUTING.md](../CONTRIBUTING.md) |
| A description of how the project is built | [ARCHITECTURE.md](../ARCHITECTURE.md) |

Every record carries these fields:

- a title
- status, which is accepted, superseded by NNNN, or deprecated
- date
- decision-makers, written as "the maintainer" where the maintainer ruled
- context and problem statement
- decision outcome
- consequences, which must say what breaks if the decision is undone
- considered options, only where an option was explicitly refused and someone might propose it again

Each record opens with a short "About this document" section, like every document under `docs/`. A long record adds a "Summary" section after its metadata: a few bullets with the decision and what must never be done, before the detail.

At the repository root, `README.md` introduces the repository, and `AGENTS.md` sends anyone who works on it to `docs/CONTRIBUTING.md` first. The documents under `docs/` keep to one layout: `PRINCIPLES.md`, `CONTRIBUTING.md`, `ARCHITECTURE.md`, `PENDING.md`, the records here, and `reference/`. A reference describes one external tool alone and cites no other document. Our documents may cite a reference, and a reference never cites them.

## Considered options

- **Keep the three criteria of 0000.** Refused because the first one admits choices that nobody would undo, and none of them asks what the record protects.
- **Edit 0000 in place.** Refused because a record is never rewritten to change its outcome, which is the first consequence of 0000 and stays one.

## Consequences

- A record is never rewritten to change its outcome. A new record supersedes it, and the old one's status says so.
- A record states what is true and why. Git keeps how the text changed, so corrections are not narrated in the record.
- A measurement that backs a decision keeps its method, its number and its date.
- A figure that moves with configuration is stated as it is today and re-read before it is cited.
- Records 0001 to 0019 were written under 0000. Where one did not say what breaks without it, a line saying so was added from what the record already stated.
- Without this practice, an unusual choice is only as safe as the memory of whoever made it, and a record that does not say what it protects is read as a description and tidied away.
