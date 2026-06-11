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
/main.tex                 <- book master (documentclass, title, \include list)
/style/interviewbook.sty  <- shared style: Q&A, gym, boxes, listings (LaTeX)
/chapters/ch01_embedded_c.tex
/chapters/ch02_memory_toolchain.tex
/chapters/...             <- one .tex file per chapter, numbered, \chapter each
/build/build.sh           <- pdflatex/latexmk compile script
/build/book.pdf           <- compiled output (BUILD ARTIFACT, gitignored)
/progress.md              <- checklist: chapter status + actual page counts
/resume/Sushmita_Telasang_Resume.tex <- resume source for Ch15/16 consistency
/inputs/INTAKE.md         <- sole source of facts for Chapters 15-16
```

## Chapters are written in LaTeX
Chapters are .tex files (NOT markdown) so the book gets dense professional
typography and 500+ pages of tightly packed content. Use the environments
and commands from style/interviewbook.sty — do not restyle per chapter:
- `\question{Q2.3}{...}` for Q&A items; `\trap` for the Tier-3 trap lead-in
- `\tierbanner{Tier N — ...}{one-line description}` for tier headings
- `\begin{gymproblem}{Title} ... \end{gymproblem}` (auto-numbered per chapter)
- `\attempt` for the ATTEMPT BEFORE READING ON marker; `\followups` before
  the interviewer-variant list
- `\begin{cgym} ... \end{cgym}` for C code (listings, no escaping needed)
- `\begin{resumelink}`, `\begin{scorecard}`, `\begin{answerkey}`,
  `\begin{partnote}` boxes
- `\code{...}` for inline code (escape _, &, %, # manually inside it)
After creating a chapter file, add its `\include` line in main.tex.

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
8. After finishing a chapter: run `bash build/build.sh` and record the REAL
   page count from pdfinfo in `progress.md` (the build is cheap — prefer real
   counts over word-based estimates). The compile must finish with zero
   LaTeX warnings (check build/main.log).
9. Page budget per chapter is in PLAN.md. Stay within ±15%.
10. NEVER fabricate facts about protocols or standards. If unsure about a
    MIL-STD-1553B or DO-178B detail, mark it `[VERIFY]` rather than guessing.

## Chapter prompts (one per session)
"Read PLAN.md and CLAUDE.md. Write Chapter N in full into chapters/chNN_<name>.tex
following the template. Then update progress.md and report the page count."

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
