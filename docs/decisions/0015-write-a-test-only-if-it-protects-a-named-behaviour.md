# 0015. Write a test only if it protects a named behaviour

## About this document

This record decides which unit tests this repository accepts and why. Read it before you add, change or delete a test, or before you propose a coverage target. It covers the gate a test passes, the techniques that choose the cases, how a test is written, and the tests that are refused. It does not cover how the harness runs the tests, which is [ARCHITECTURE.md](../ARCHITECTURE.md#tests), or the rules that follow from it, which are `T002` to `T013` in [CONTRIBUTING.md](../CONTRIBUTING.md). Update it when a refused kind of test becomes acceptable or the reverse.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A test stays only if it names the behaviour it protects, has been seen to fail, survives a refactor that changes no behaviour, and adds information that no other test gives.
- Never add a test to raise a coverage number, and never add a second example of a class that another test already covers.

## Context and problem statement

A test costs time every time it runs, is read and breaks. One that cannot catch a bug, or that fails when nothing is wrong, gives nothing back and teaches people to ignore red. A suite grows noisy when tests are written per method, per branch or per percentage point. The suite of this repository holds 171 tests, which a reader should be able to trust without reading each one.

## Decision outcome

The gate has six questions, and a test that fails any of the first four is not written or is deleted:

1. Which promised behaviour does it protect, stated from how a caller uses the code and not from how the code is written?
2. Would it fail if that behaviour broke? Someone must have seen it fail.
3. Would it keep passing after a refactor that changes no behaviour?
4. Does it add information that no other test gives?
5. Do its name and message say what broke?
6. Is it fast and deterministic?

Cases come from what the code promises, with black-box techniques that ISTQB and ISO/IEC/IEEE 29119-4 name. The input is split into equivalence classes with one representative each, the edge of each ordered class is added (boundary value analysis), several conditions that combine are listed in a decision table, and an object that moves through states gets its transitions tested. A rule that must hold for any input is stated as a property and checked over generated cases with a seed (the suite `properties`).

A test is Arrange, Act, Assert, checks one behaviour, is named as a sentence, calls the public API, checks the result and not the internal calls, and has no loop, branch or computed expected value in it. Expected values are worked out by hand (`T002`).

## Considered options

- A coverage target was refused. Fowler calls coverage "a useful tool for finding untested parts of a codebase" and "of little use as a numeric statement of how good your tests are", and quotes Marick: "If you make a certain level of coverage a target, people will try to attain it".
- One test per method was refused. Google's guidance is one test per behaviour, because a method test grows convoluted as the method does.
- Replacing every collaborator with a double was refused. Real objects are preferred when they are fast and deterministic (Google, and Fowler as a classicist), and doubles tie a test to the implementation. GML has no mocking library in any case.
- Many examples of one class, for comfort, was refused. ISTQB defines equivalence partitioning as one representative member of each partition, and the others add no information.

## Consequences

- Rules `T008` to `T013` of [CONTRIBUTING.md](../CONTRIBUTING.md) hold this record by attention alone. The one detector is `T004`: break the code once and watch the test fail. No test and no coverage tool in this repository checks the other rules.
- The existing 171 tests were written before this record and were not audited against it. Some may be redundant or too close to the implementation. That is a gap and not a decision, and it is item 8 of [PENDING.md](../PENDING.md).
- A test that stays has a reason that can be stated in one sentence, which makes a failing test easier to read.
- Drawing, sound and layout that cannot be read back have no test, and the documents say so instead of adding a test that cannot fail.

## Sources

Read on 2026-10-15: Software Engineering at Google, chapter 12 (through a page summariser, so the wording of the quotations is faithful in meaning and not checked word for word); Fowler, "UnitTest", "TestCoverage" and "Mocks Aren't Stubs"; Beck, Test Desiderata; Wake, "3A: Arrange, Act, Assert"; the Google Testing Blog post "Test Behavior, Not Implementation"; the abstract of "Practical Mutation Testing at Scale" (Google); the Hypothesis documentation; the ISTQB glossary entries for equivalence partitioning and boundary value analysis; and the Open Catalog of Test Smells.

Not read in full: ISO/IEC/IEEE 29119-4 (paid, only its list of techniques was seen), IEEE 1008-1987 (superseded, only its description), Khorikov's *Unit Testing: Principles, Practices, and Patterns* (four pillars taken from a secondary summary) and Meszaros's *xUnit Test Patterns* (its site could not be reached). That a test of an engine function is noise, and that a value computed with the same formula as the code proves nothing, are the judgment of this repository and no source states them.
