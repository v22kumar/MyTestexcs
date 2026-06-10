# PLAN.md — Embedded Systems & Avionics Interview Mastery Book
## 520-page preparation book | 10% → 100% interview readiness
## Candidate profile: UAV flight control engineer (DFCC / AETS-DFCC SC cards, CCDL, SPIL, RS422 Embedded C, CAN, signal conditioning) with prior LCA Tejas V&V experience (ARM9/LPC3250, DPRAM, MIL-STD-1553B, Python automation)

This file is the single source of truth for the book's structure. CLAUDE.md
defines HOW chapters are written; this file defines WHAT gets written.

---

## 1. DESIGN PRINCIPLES

**Content mix across the whole book:**
- ~50% Question & Answer (interviewer question → spoken-length model answer → follow-up traps)
- ~40% Coding (problem → attempt marker → solution → interviewer variants)
- ~10% Concept primers (minimum theory needed to answer, nothing more)

**Fixed chapter template (defined in CLAUDE.md, repeated here for reference):**
1. Primer (2–4 pages)
2. Q&A Bank in 3 tiers: Tier 1 screening / Tier 2 panel / Tier 3 principal-engineer depth
3. Coding Gym (where applicable)
4. "Link to her resume" box — one ready sentence connecting the topic to her DFCC/CCDL/SPIL/BEL work
5. Self-test scorecard: 10 rapid-fire questions, pass mark 8/10

**Anti-padding rule:** every page must produce an interview answer or working
code. No history sections, no motivation text, no repeated definitions.

**Truthfulness rule (CRITICAL):** Chapters 1–14 are general technical content —
write freely. Chapters 15–16 describe HER real work and life — they must be
built ONLY from `inputs/INTAKE.md`. Never invent project details, defects,
metrics, tools, or biographical facts. See Section 5.

---

## 2. TABLE OF CONTENTS WITH PAGE BUDGETS (target ~520 pages)

### PART A — EMBEDDED C & PROCESSOR CORE (190 pages)

| Ch | File | Title & scope | Pages | Q&A/Code/Concept |
|----|------|---------------|-------|------------------|
| 1 | ch01_embedded_c.md | **Embedded C Mastery** — pointers (arithmetic, function pointers, pointer-to-pointer, const placement), arrays vs pointers, strings, structs/unions/bitfields, padding & alignment, `volatile` (the #1 embedded interview question), `static`, storage classes & scope, typecasting, endianness, preprocessor & macros vs inline | 70 | 30/35/5 |
| 2 | ch02_memory_toolchain.md | **Memory & Toolchain** — memory map of an embedded program, stack vs heap, .text/.data/.bss, linker scripts, startup code (what runs before main), compilation stages, Makefiles, stack overflow & memory corruption diagnosis | 30 | 15/12/3 |
| 3 | ch03_arm_architecture.md | **ARM & MCU Architecture** — Cortex-M register set, exception model, NVIC, pipeline basics, clock tree & PLL, GPIO internals (push-pull vs open-drain), ARM9/LPC3250 specifics (her real BEL platform), Harvard vs von Neumann, ARM vs RISC-V awareness | 50 | 30/14/6 |
| 4 | ch04_interrupts_timers_dma.md | **Interrupts, Timers & DMA** — ISR rules (what's forbidden inside, why short), latency & jitter, nesting & priority, shared data problem & solutions, race conditions, timer/PWM frequency-duty math (with worked numericals), watchdog design, DMA vs polling vs interrupt tradeoffs | 40 | 22/14/4 |

### PART B — COMMUNICATION PROTOCOLS (150 pages)

| Ch | File | Title & scope | Pages | Q&A/Code/Concept |
|----|------|---------------|-------|------------------|
| 5 | ch05_uart_rs_serial.md | **UART / RS232 / RS422 / RS485** — frame anatomy, baud math & error %, parity/framing/overrun errors, flow control, single-ended vs differential, RS422 vs RS485 vs RS232 comparison table, why flight computers use RS422 (her daily interface), termination & noise | 35 | 22/10/3 |
| 6 | ch06_spi_i2c.md | **SPI & I2C** — timing diagrams, 4 SPI modes (CPOL/CPHA), chip select handling, I2C start/stop/ACK, addressing, clock stretching, arbitration, pull-up sizing, multi-slave topologies, SPI vs I2C vs UART selection question | 30 | 18/9/3 |
| 7 | ch07_can_bus.md | **CAN Bus Deep Dive** — frame fields, identifiers & arbitration (worked example), bit stuffing, error frames & error states (active/passive/bus-off), ACK mechanism, bit timing & sample point, CAN FD awareness, higher layers (CANopen/J1939 awareness), drone servo control over CAN (her lab) | 45 | 28/13/4 |
| 8 | ch08_avionics_buses.md | **Avionics Data Buses** — MIL-STD-1553B (BC/RT/BM, word types, command/response), ARINC 429 (label, SSM, SDI, word format), Ethernet TCP vs UDP for telemetry, redundancy & cross-channel data link (CCDL) concepts: why redundant channels exchange data, voting, failover, generic serial processing links (SPIL-type), telemetry packet structure & parsing | 40 | 28/8/4 |

### PART C — SYSTEMS & DOMAIN (130 pages)

| Ch | File | Title & scope | Pages | Q&A/Code/Concept |
|----|------|---------------|-------|------------------|
| 9 | ch09_rtos_realtime.md | **RTOS & Real-Time** — task states & scheduling (preemptive/round-robin/rate-monotonic), context switch, mutex vs semaphore vs queue, priority inversion & inheritance (the classic question), deadlock conditions, hard vs soft real-time, determinism, bare-metal superloop vs RTOS, shared-memory/DPRAM handshake patterns (her BEL work) | 40 | 24/12/4 |
| 10 | ch10_control_pid.md | **Control Systems & PID** — open vs closed loop, P/I/D term intuition (what each fixes, what each breaks), tuning incl. Ziegler-Nichols, overshoot/rise/settling/steady-state error definitions with sketch descriptions, sensor feedback & noise filtering, discrete PID in C, servo position loop walkthrough | 30 | 20/6/4 |
| 11 | ch11_debugging_lab.md | **Hardware Debugging & Lab Skills** — oscilloscope: triggering, probing UART/SPI/CAN and reading the waveform, logic analyzer vs scope, JTAG/SWD internals, ST-Link vs J-Link, breakpoints vs watchpoints, board bring-up sequence (power rails → clocks → reset → JTAG → peripherals), reading schematics basics, ESD & lab safety | 30 | 22/4/4 |
| 12 | ch12_vnv_do178.md | **V&V, DO-178B & Test Methodology** — white/black/grey box, statement vs branch vs MC/DC coverage, DO-178B levels A–E and what changes per level, requirements traceability, ATP vs QTP, HIL testing architecture, fault injection, defect lifecycle & root cause analysis (5-why), AS9100 awareness | 30 | 24/2/4 |

### PART D — CODING GYM (85 pages)

| Ch | File | Title & scope | Pages |
|----|------|---------------|-------|
| 13 | ch13_coding_gym.md | **60 Embedded C Problems**, graded: (1–15) bit manipulation: set/clear/toggle/test, count set bits, swap nibbles, reverse bits, power-of-2 check, endian swap & detection; (16–30) memory & strings from scratch: memcpy (with overlap question → memmove), strlen/strcpy/strrev/strcmp, atoi/itoa, aligned malloc concept; (31–45) data structures on embedded: ring buffer (the #1 embedded coding question), queue for UART RX ISR, stack, linked list ops, state machine (traffic light / protocol parser); (46–60) applied: software debounce, CRC-8 implementation, fixed-point math, packing/unpacking a telemetry frame, simple scheduler, GPIO driver skeleton, moving-average filter | 60 |
| 14 | ch14_python_automation.md | **Python for Test Automation** — struct.pack/unpack for binary telemetry, pyserial port scripting, log file parsing & regex, CSV/report generation, the questions asked when "Python automation framework" is on a resume, 15 graded problems | 25 |

### PART E — INTERVIEW EXECUTION (65 pages) — SPECIAL RULES, SEE SECTION 5

| Ch | File | Title & scope | Pages |
|----|------|---------------|-------|
| 15 | ch15_project_deepdives.md | **Her Project Deep-Dives** — for each real project (DFCC/SC card testing, CCDL verification, SPIL testing, RS422 Embedded C routines, BEL DPRAM + 1553B Python automation): 2-minute story script, 5-minute deep version, block-diagram description she can draw, 15 likely follow-up questions WITH her answers, and "honest boundary" lines for what she didn't do | 25 |
| 16 | ch16_behavioral_company.md | **Behavioral & Company Rounds** — STAR answers built from her real experiences (conflict, failure, deadline, learning, why-leaving), contract-to-permanent questions (third-party payroll context), salary discussion scripts, company one-pagers: TASL, BEL, HAL, Honeywell, Collins, Safran, Boeing India, Airbus, Bosch, Continental, Qualcomm — what each builds and what they ask | 20 |
| 17 | ch17_mock_interviews.md | **5 Full Mock Interviews** — screening call, technical round 1 (C + protocols), technical round 2 (domain + projects), coding round, managerial round. Each: 45-min question script, scoring rubric, full answer key, common-mistake notes | 20 |

**TOTAL: ~520 pages**

---

## 3. WRITING ORDER & SESSIONS

| Session | Output |
|---------|--------|
| 1 | Ch 1 Part 1 (pointers → structs/unions/padding) |
| 2 | Ch 1 Part 2 (volatile → endianness → macros) |
| 3 | Ch 2 |
| 4 | Ch 3 |
| 5 | Ch 4 |
| 6 | Ch 5 |
| 7 | Ch 6 |
| 8 | Ch 7 |
| 9 | Ch 8 |
| 10 | Ch 9 |
| 11 | Ch 10 + Ch 11 |
| 12 | Ch 12 |
| 13 | Ch 13 problems 1–30 |
| 14 | Ch 13 problems 31–60 |
| 15 | Ch 14 |
| — | GATE: verify inputs/INTAKE.md is complete (Section 5) |
| 16 | Ch 15 (from INTAKE.md only) |
| 17 | Ch 16 + Ch 17 |
| 18 | Full compile, page-count check, fix gaps, generate index |

Run `build/build.sh` after sessions 5, 9, 12, 15, 18 and record actual page
count in progress.md. If tracking under 490 pages by session 12, expand the
Q&A tiers of Part B chapters (highest interview value per page).

---

## 4. STUDY PLAN (for the reader, printed as the book's introduction)

~22 hrs/week. Rules: (1) attempt every coding problem on paper ≥10 min before
reading the solution; (2) 8/10 on a chapter scorecard before advancing;
(3) speak Tier-2 answers aloud once per chapter; (4) from week 9, re-test one
old scorecard daily.

| Weeks | Chapters | Readiness |
|-------|----------|-----------|
| 1–3 | 1, 2, 3 | 10% → 35% |
| 4–5 | 4, 5, 6 | → 50% |
| 6–7 | 7, 8, 9 | → 65% |
| 8 | 10, 11, 12 | → 75% |
| 9–10 | 13 (5 problems/day), 14 | → 88% |
| 11 | 15, 16 — memorize cold | → 95% |
| 12 | 17: all five mocks + redo failed scorecards | → 100% |

---

## 5. CHAPTER 15 & 16 PROTOCOL — NO FABRICATION (CRITICAL)

These chapters script HER claims about HER work. A fabricated detail here gets
repeated confidently in an interview and then dismantled by one follow-up
question. Therefore:

1. **Sole source:** `inputs/INTAKE.md` (template provided in the repo). Chapters
   15–16 may use general technical knowledge to FRAME her answers, but every
   project fact (what she tested, tools used, defects found, metrics, team
   size, her exact role) must come from INTAKE.md.
2. **Hard gate:** Do not start Chapter 15 until INTAKE.md has no empty
   `[FILL]` fields in its REQUIRED section. If asked to proceed anyway, write
   the chapter skeleton with `[NEEDS INTAKE: <question>]` placeholders and list
   the missing items in progress.md — do NOT invent plausible-sounding answers.
3. **Honest boundary lines:** every project script must include 2–3 prepared
   sentences for questions beyond her experience, e.g. "I performed the
   card-level validation; the control law design was done by the systems team —
   but I can explain how I verified its outputs." Knowing where her knowledge
   ends, and saying so smoothly, scores HIGHER with senior interviewers than
   bluffing.
4. **Claim–resume consistency:** every claim in Ch 15 must be consistent with
   the resume (Sushmita_Telasang_Resume.tex). If INTAKE.md reveals a resume
   bullet that overstates reality, flag it in progress.md so the resume gets
   corrected — the resume bends to reality, never the reverse.
5. **Follow-up question realism:** the 15 follow-ups per project must include
   the uncomfortable ones (Why this approach? What failed? What would you do
   differently? What's the latency/baud/voltage — exact numbers?). If INTAKE.md
   lacks the number, the scripted answer teaches her to say how she'd measure
   it, not a made-up figure.
6. **Chapter 16 biographical facts** (notice period, reason for leaving, salary
   expectations, education gaps) likewise come only from INTAKE.md.

---

## 6. SOURCES & ACCURACY (Chapters 1–14)

- Protocol facts (1553B word formats, ARINC 429 labels, CAN bit timing,
  DO-178B objectives) must be standard, verifiable knowledge. Mark anything
  uncertain `[VERIFY]` and resolve before the chapter is marked done.
- All numerical examples (baud error %, PWM math, CRC) must be computed, not
  estimated — show the arithmetic in the solution.
- C code compiles under `gcc -Wall -Wextra` or is marked `// target-only`.
