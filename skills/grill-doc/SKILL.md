---
name: grill-doc
description: Ruthlessly tighten a prose document until every word earns its place. Decomposes the doc paragraph then sentence then word to find each cut or swap, validates every change upward to the whole document, and loops to a fixed point. Use when the user wants to grill, tighten, distill, or calibrate a doc (README, design doc, ADR, email, proposal, PR description) or mentions /grill-doc.
---

You grill the **document**, not the user. You decompose it, challenge every unit, and
propose a tightened version with a rationale for each change. You never edit a file
without approval, and you never run git — the user drives that.

End state: **every remaining word carries distinct meaning** — nothing can be removed or
swapped for something more precise without degrading the doc.

## Invocation

The user points you at the material — you never go looking for files.

- a path (`@README.md`), pasted text, or "this doc" → that is your target.
- a named section → scope edits to it, but keep the whole doc as validation context.
- a source-code file → decline. You tighten prose, not logic.

## Loop

First, map the **off-limits zones** and treat them as literal — never alter: code and
inline code, quotes and citations, links/URLs, proper nouns, defined terms, numbers and
data, frontmatter.

Then run grilling passes. Each pass is a round trip:

1. **Descend** (top-down): scan paragraph → sentence → word. At the finest grain, surface
   every candidate against three tests:
   - **Removal** — cut it: does meaning or quality meaningfully drop? If no, it goes.
   - **Substitution** — is there a word that carries the load more precisely? If yes, swap.
   - **Redundancy** — does it restate a neighbor or negate its own opposite (`costs, not
     free`)? Test at every grain (word, phrase, whole sentence), not just single words.

   Tag each unit `KEEP`, `CUT`, `MERGE`, or `SWAP`.

2. **Ascend** (validate): take each candidate (batched per sentence, then per paragraph)
   and re-check it upward — sentence → paragraph → **whole doc**. Keep it only if it stays
   an improvement with meaning **and** voice preserved at every level. If it degrades any
   larger level, **revert**. Accept a change only when it improves the **whole document** —
   a local win is never enough.

3. **Present** the pass as a diff (before → after) plus a rationale log: one
   observation-based line per change (`cut "very" — adds no precision`; `"in order to" → "to"`).
   No graded praise.

4. The user approves all, cherry-picks, or tweaks. Then edit the file **in place**. The
   user can stop anytime — they are the governor.

Repeat passes on the approved draft until a full pass yields **zero** accepted changes:
the fixed point.

## Guardrails (non-negotiable)

- **Meaning is invariant.** Brevity never beats accuracy. A change that alters meaning is
  rejected by definition.
- **Preserve voice.** Tighten; don't flatten into generic prose. Cut filler; keep
  intentional rhetoric, cadence, and emphasis. Protect emphasis only when it adds a new,
  load-bearing specific; a redundant line dressed as rhetoric still goes.
- **Concise ≠ terse.** Keep connective tissue that aids comprehension.
- **Flag judgment calls.** When a cut might be deliberate emphasis or rhetoric, don't force
  it — surface it as a question (an intent fork) for the user.

## Stopping

- **Fixed point** — a full pass with zero accepted changes. Done.
- **Oscillation** — a pass proposes only changes that reverse earlier ones (`X → Y → X`):
  declare convergence and surface the pair for the user to settle.
- **Non-convergence** — if it cannot settle, **halt and explain why** (usually a genuine
  ambiguity). Never loop silently.

Close with a short convergence report: passes run, changes accepted, changes reverted, and
word-count delta — as information, not a target. Write no extra files unless asked.

## Worked example

> `grill-doc @README.md`
> Map code blocks and links as literal. Pass 1: cut 6 filler words, merge 2 sentences, swap
> "utilize" → "use" — each validated up to the whole doc; revert one cut that broke a
> paragraph's logic. Show the diff + rationale; user accepts; edit in place. Pass 2: cut 1
> more. Pass 3: 0 changes → converged.
