# CLAUDE.md — Interview Book Project Instructions
# Place this file at the repo root. Claude Code reads it automatically every session.

## Project
Build a 520-page embedded systems & avionics interview preparation book for an
engineer working on UAV flight control (DFCC cards, CCDL, SPIL, RS422, Embedded C,
CAN, signal conditioning) per the blueprint in `PLAN.md`.

## Repo structure
```
/PLAN.md                  <- master blueprint (table of contents, page budgets)
/CLAUDE.md                <- this file
/chapters/ch01_embedded_c.md
/chapters/ch02_memory_toolchain.md
/chapters/...             <- one file per chapter, numbered
/build/build.sh           <- pandoc compile script
/build/book.pdf           <- compiled output
/progress.md              <- checklist: chapter status + actual page counts
```

## Rules for writing chapters
1. ALWAYS read `PLAN.md` and the two most recently completed chapters before
   writing a new one — match their template, tone, and difficulty grading.
2. Every chapter follows the fixed template:
   Primer (10%) -> Q&A Bank in 3 tiers (50%) -> Coding Gym (40% where applicable)
   -> "Link to her resume" box -> 10-question self-test scorecard.
3. Content mix across the whole book: ~50% Q&A, ~40% coding, ~10% explanation.
4. NO filler. No history lessons, no motivational text. Every page must produce
   an interview answer or working code.
5. Coding problems format: Problem -> Hints -> "ATTEMPT BEFORE READING ON"
   marker -> full solution with line-by-line commentary -> 2-3 interviewer
   follow-up variants.
6. All C code must compile. Verify with `gcc -Wall -Wextra` before including it.
   Embedded-specific code that can't compile on host (register access) must be
   syntactically valid and marked `// target-only`.
7. Q&A answers must be SPOKEN-LENGTH: Tier 1 = 2-4 sentences, Tier 2 = a short
   paragraph, Tier 3 = paragraph + the trap it defends against.
8. After finishing a chapter: update `progress.md` with status and estimated
   page count (1 page ~ 450 words of this format), then run the build to check
   cumulative pages.
9. Page budget per chapter is in PLAN.md. Stay within ±15%.
10. NEVER fabricate facts about protocols or standards. If unsure about a
    MIL-STD-1553B or DO-178B detail, mark it `[VERIFY]` rather than guessing.

## Chapter prompts (one per session)
"Read PLAN.md and CLAUDE.md. Write Chapter N in full into chapters/chNN_<name>.md
following the template. Then update progress.md and report the page estimate."

For the two oversized chapters:
- Chapter 1: split as "Chapter 1 Part 1 (pointers through structs)" and
  "Part 2 (volatile/const/static through endianness)" in the same file.
- Chapter 13: split as problems 1-30, then 31-60.

## Build
`build/build.sh` should contain:
```bash
#!/bin/bash
# requires: pandoc, texlive (xelatex)
pandoc chapters/ch*.md \
  --toc --toc-depth=2 \
  -V geometry:margin=2cm \
  -V fontsize=11pt \
  -V documentclass=report \
  --pdf-engine=xelatex \
  -o build/book.pdf
echo "Pages: $(pdfinfo build/book.pdf | grep Pages)"
```
Run after every 3 chapters to track real page count against the 520 target.

## Quality gate before marking a chapter done
- [ ] Follows template exactly
- [ ] All code compiles (or marked target-only)
- [ ] Scorecard present with answer key
- [ ] Resume-link box present
- [ ] Page count within budget ±15%
- [ ] No [VERIFY] markers left unresolved without a note in progress.md
