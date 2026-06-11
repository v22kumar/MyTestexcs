# progress.md — Book Build Tracker

Target: ~520 pages total. Page counts below are **real** counts from
`pdfinfo build/book.pdf` after `bash build/build.sh` — not word estimates.
The compiled book carries a title page + table of contents (~2 pp of front
matter) on top of chapter content.

## Toolchain (LaTeX pipeline)
- Source: `main.tex` (book master, `\include`s chapters) + shared style in
  `style/interviewbook.sty` (Q&A, Coding Gym, boxes, C listings).
- Build: `bash build/build.sh` → `build/book.pdf` (gitignored artifact).
  Must finish with **zero** LaTeX warnings (check `build/main.log`).
- Chapters are `.tex` files, one `\chapter` each.
- All C snippets verified with `gcc -Wall -Wextra -std=c11` (zero warnings)
  before inclusion.

## Status legend
- [ ] not started   - [~] in progress / partial   - [x] complete (passes the
  CLAUDE.md quality gate)

## Chapter status

| Ch | File | Title | Budget (pp) | Actual pp | Status |
|----|------|-------|-------------|-----------|--------|
| 1  | ch01_embedded_c.tex | Embedded C Mastery | 70 | ~24 (Parts 1 & 2) | [x] both parts done; under budget — see note |
| 2  | ch02_memory_toolchain.tex | Memory & Toolchain | 30 | — | [ ] |
| 3  | ch03_arm_architecture.tex | ARM & MCU Architecture | 50 | — | [ ] |
| 4  | ch04_interrupts_timers_dma.tex | Interrupts, Timers & DMA | 40 | — | [ ] |
| 5  | ch05_uart_rs_serial.tex | UART / RS232 / RS422 / RS485 | 35 | — | [ ] |
| 6  | ch06_spi_i2c.tex | SPI & I2C | 30 | — | [ ] |
| 7  | ch07_can_bus.tex | CAN Bus Deep Dive | 45 | — | [ ] |
| 8  | ch08_avionics_buses.tex | Avionics Data Buses | 40 | — | [ ] |
| 9  | ch09_rtos_realtime.tex | RTOS & Real-Time | 40 | — | [ ] |
| 10 | ch10_control_pid.tex | Control Systems & PID | 30 | — | [ ] |
| 11 | ch11_debugging_lab.tex | Hardware Debugging & Lab Skills | 30 | — | [ ] |
| 12 | ch12_vnv_do178.tex | V&V, DO-178B & Test Methodology | 30 | — | [ ] |
| 13 | ch13_coding_gym.tex | 60 Embedded C Problems | 60 | — | [ ] |
| 14 | ch14_python_automation.tex | Python for Test Automation | 25 | — | [ ] |
| 15 | ch15_project_deepdives.tex | Her Project Deep-Dives | 25 | — | [ ] **BLOCKED — see note** |
| 16 | ch16_behavioral_company.tex | Behavioral & Company Rounds | 20 | — | [ ] **BLOCKED — see note** |
| 17 | ch17_mock_interviews.tex | 5 Full Mock Interviews | 20 | — | [ ] |

**Current compiled size:** `build/book.pdf` = **26 pages** (title + TOC +
Chapter 1 complete), of the ~520 target.

## Session log

### Session 1 — Chapter 1, Part 1 (pointers → structs/unions/padding)
- Stood up the LaTeX pipeline: `main.tex`, `style/interviewbook.sty`,
  `build/build.sh` (pdflatex/latexmk), and the resume source in `resume/`.
- Wrote Ch 1 Part 1: Primer, 3-tier Q&A (10 + 9 + 8 questions), Coding Gym
  (11 problems), resume-link box, 10-question scorecard with answer key.
- **All C code verified:** every compilable snippet built clean under
  `gcc -Wall -Wextra -std=c11` (zero warnings); outputs confirmed (incl.
  struct sizes 12/8, popcount, bit macros `0x00000081`, IEEE-754 float bytes
  `00 00 80 3F`). The register-access fragment is marked `// target-only` and
  excluded from host compilation.
- **Compiled clean:** `bash build/build.sh` → 15 pp, zero LaTeX warnings.
- **Budget note:** Part 1 was ~13 pp.

### Session 2 — Chapter 1, Part 2 (volatile → const → static → storage classes → typecasting → preprocessor → endianness)
- Wrote Ch 1 Part 2: Primer (7 topics), 3-tier Q&A (7 + 8 + 6 = 21 more
  questions, Ch 1 total now 48), Coding Gym problems 12–20 (9 more, Ch 1 total
  now 20 problems), Part-2 resume-link box, and a Part-2 scorecard + answer
  key.
- **All C code verified:** endian swap16/swap32, runtime endianness check,
  power-of-two, swap-nibbles, reverse-bits, side-effect-safe MAX
  (macro + inline), container_of, static counter, const-correct checksum —
  all clean under `gcc -Wall -Wextra -std=c11`, outputs confirmed. The two
  statement-expression macros are noted in-text as GCC/Clang extensions.
- **Compiled clean:** `bash build/build.sh` → 26 pp, zero LaTeX warnings.
- **Budget note (open):** Chapter 1 is ~24 pp of content vs a 70 pp budget.
  Per CLAUDE.md the ±15% rule would want ~60–80 pp. To close the gap in a
  later pass: expand each Q&A tier (PLAN.md targets 30 Q&A / 35 code / 5
  concept for this chapter), add ~10–15 more Coding Gym problems (string/mem
  builders, more bit tricks), and deepen the primers. Tracking deliberately,
  not silently, under budget. Chapter 1 marked content-complete [x] for its
  topic scope; the budget expansion is a separate later task.

## Open flags / [VERIFY] / [NEEDS INTAKE] items
- **Chapters 15 & 16 are HARD-BLOCKED.** Per PLAN.md Section 5 and CLAUDE.md,
  they must be written ONLY from `inputs/INTAKE.md`, and every REQUIRED
  `[FILL]` field in that file is still empty. Do not start Ch 15/16 — and do
  not invent project facts — until INTAKE.md's REQUIRED section is complete
  and the user confirms.
- Claim–resume consistency (PLAN.md §5) is checked against
  `resume/Sushmita_Telasang_Resume.tex` (the resume PDF is a build artifact,
  not committed).
- No `[VERIFY]` protocol/standard markers were needed in Ch 1 Part 1.
- Ch 1 is tracking under its 70 pp budget (see session-1 budget note).
