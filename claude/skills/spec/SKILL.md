---
name: spec
description: Write a ready-to-paste implementation spec for another coding agent (Codex or Claude Code) in Noé's multi-part format. Use when the user asks for a spec, a prompt for the agent, or to hand off implementing a component or feature.
---

# Spec

Write a spec that another agent will execute without this conversation's context. Write it in the user's language. Deliver it in the chat, one copyable block per part. Never as a file. Always complete, never a patch over a previous spec.

## Structure

Split into parts (PARTE 1/N … PARTE N/N) when the work needs more than one review point. Each part ends at a checkpoint.

### Header (first part)
- Repo, base branch, new branch name. Work on a new branch in the main repo. Never git worktrees.
- Goal in 1–3 sentences.
- The global rules that apply to the target repo (below).

### Fase 0 — diagnosis (first part)
Point checks only: `grep -n`, `sed -n 'A,Bp'`, `ls`, `git status`. Never ask to print whole files. Each check states the expected result and says "DETENTE y reporta" if it does not match. Double-check the expected counts before writing them.

### Steps
- Files to create or change, with EXACT content. For edits, give the exact anchor text and the exact replacement.
- No "similar to" or "etc.". If the agent must decide something, give the criteria.

### Checkpoint (end of each part)
- Quick checks only: typecheck and lint of touched packages, focused tests.
- The agent copies a compact status to the system clipboard (pbcopy) with only what will be reviewed: files touched, check results, deviations. No file. Then it stops and waits.

### Last part
- Unit tests go here and cover our own code only, not behavior the library already tests (React Aria, Sonner, Tiptap…).
- Browser checks only for our code and the integration. Never re-test library behavior or invented cases. Never against staging or production (PHI).
- Heavy harness checks (quality, e2e, impact, test-matrix) run once here, before the final commit.
- Commits happen only here.

## Global rules (include the ones that apply)
- Code, tests and test strings in English, except locale tests.
- No AI trailers or footers in commits or PRs: no Co-authored-by for assistants, no "Generated with…".
- Minimal comments: at most one per function or block, 5–10 words.
- Discriminated unions use `tag`, not `kind`.
- Eden product code: early-return `if` instead of ternaries; no ADTs; data-first functions, no pipe/flow.
- genesis: no magic strings; where the architecture forces classes, keep methods FP-ish.
- Design system packages: relative imports with .ts/.tsx extensions.
- Design system stories: changing state in a <pre> with JSON.stringify(value, null, 2) beside the component, not below; submitted form values go to console.log.

## Austerity
The executing agent's usage costs money. Keep Fase 0 and checkpoints compact, and don't ask it to echo content the spec already gives.
