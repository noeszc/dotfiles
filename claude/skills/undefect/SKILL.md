---
name: undefect
description: >-
  Investigate a software defect without fixing it. Use when the user wants a
  complete bug investigation, root-cause explanation, early detection measures
  through types/tests/logging/user feedback, verification that each detection
  measure catches the defect, architectural recommendations, and a scan for
  similar defects from similar causes, while explicitly preserving the defect
  for a later fix.
---

# Undefect

Use this skill to understand a defect deeply and make it easy to detect, without fixing the defect yet.

## Prime Directive

Do not fix the defect as the outcome of this skill.

If investigation requires temporarily fixing the defect to prove causality, do it only as an experiment. Before finishing, revert the temporary fix and leave only detection, observability, documentation, or user-feedback changes that do not correct the defect itself.

Our main goal is to either eliminate the potential for this class of defect, or failing that, make detection simpler and faster.

## Workflow

1. Establish the defect precisely.
   - Reproduce it from the user-visible behavior, a failing command, a failing test, logs, or a minimal code path.
   - Record the expected behavior, actual behavior, trigger conditions, affected surface area, and any non-reproduction cases discovered.
   - Prefer local deterministic reproduction before production reproduction. Avoid production mutation unless the user explicitly allows it.

2. Explain why the bug exists.
   - Trace the code path from input/event to wrong outcome.
   - Identify the missing, incorrect, or duplicated responsibility that permits the defect.
   - Before calling it a local bug, ask whether the failing behavior is caused by two sources of truth, duplicated policy, split ownership, or drift between surfaces that should share one contract.
   - If the defect involves ordering, prioritization, authorization, validation, naming, state transitions, derived status, or other policy, explicitly identify the canonical owner that should decide that policy. If no clear owner exists, call that out as part of the root cause.
   - Distinguish facts from inferences.
   - If useful, prove causality with a temporary experiment, then revert that experiment.

3. Add the fastest local detection mechanism that can reveal the defect without fixing it.
   - Prefer compile-time/type-checking when realistic.
   - Otherwise prefer a focused unit/integration test.
   - Use end-to-end tests only when lower-level tests cannot express the failure.
   - Prefer detectors at the contract boundary or canonical policy owner over detectors in only one consumer. For drift bugs, add a detector that compares sibling surfaces or forces them through the same shared contract.
   - Keep the detector narrowly scoped to the defect.
   - Run the detector and confirm it fails or signals because the defect still exists.

4. Add the fastest production/system feedback mechanism that can reveal the defect without fixing it.
   - Prefer structured logging for invisible backend failures or missing side effects.
   - Add user feedback when the user can recover, retry, or needs to know work did not happen.
   - Avoid redundant detectors. If a type check makes a unit test unnecessary, or a test makes extra logging unnecessary, skip the redundant measure.
   - After each measure, trigger the defect and confirm the measure fires.

5. Preserve silent-failure prevention.
   - The final state should not allow the defect to remain completely silent for both developers and users.
   - Aim for one fast local signal and one fast production/user-facing signal.

6. Look for enabling architecture problems.
   - Identify refactorings that would make this class of defect harder to create.
   - Favor structural improvements: single source of truth, typed contracts, centralized side-effect helpers, parameterized APIs, exhaustive switches, shared adapters, or stronger invariants.
   - When there are multiple implementations of the same business policy, recommend combining them behind one owner instead of patching each caller independently.
   - When behavior differs by surface (UI, CLI, API, worker, integration), decide whether the difference is intentional. If it is not intentional, recommend a shared contract and list every surface that should consume it.
   - Present these as recommendations unless the user asks to implement them.

7. Look for similar defects from similar causes.
   - Search for nearby code paths, sibling features, duplicate implementations, adapter variants, route variants, and test gaps that share the same missing, incorrect, or duplicated responsibility.
   - Use the root cause as the search key, not just the symptom text.
   - For each plausible similar defect, report whether it is confirmed, ruled out, or still uncertain.
   - Add detection for confirmed similar defects only when it fits the user's requested scope and does not fix the defect.
   - Do not broaden into unrelated cleanup; keep the pass focused on defects enabled by the same cause.

## Verification Rules

After every detection or feedback measure:

- Trigger the defect again.
- Report the command, test, log line, or UI feedback that proves the detector worked.
- If the detector does not fire, improve it or explain why that detection route is not viable.

Before finishing:

- Re-run the fastest detector.
- Confirm the defect is still unfixed unless the user explicitly changed the goal.
- Confirm any temporary fix experiments were reverted.

## Final Response Shape

Lead with the root cause and the detection measures added.

Include:

- Why the defect exists.
- What detection/feedback was added.
- How each detector was verified.
- Whether the defect remains intentionally unfixed.
- Any architectural refactorings recommended for a later change.
- Similar defects from similar causes that were confirmed, ruled out, or left uncertain.
- Any tests or commands that were not run.
