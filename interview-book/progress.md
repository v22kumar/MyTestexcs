# progress.md — Book Build Tracker

Target: ~520 pages total. Page estimate convention (from CLAUDE.md): 1 page ≈ 450
words of this format. Run `bash build/build.sh` after sessions 5, 9, 12, 15, 18
to record the *real* compiled page count against this estimate.

## Status legend
- [ ] not started
- [~] in progress / partial
- [x] complete (passes the CLAUDE.md quality gate)

## Chapter status

| Ch | File | Title | Budget (pp) | Est. pp | Status |
|----|------|-------|-------------|---------|--------|
| 1  | ch01_embedded_c.md | Embedded C Mastery | 70 | ~11.6 (Part 1 only) | [~] Part 1 done; Part 2 pending |
| 2  | ch02_memory_toolchain.md | Memory & Toolchain | 30 | — | [ ] |
| 3  | ch03_arm_architecture.md | ARM & MCU Architecture | 50 | — | [ ] |
| 4  | ch04_interrupts_timers_dma.md | Interrupts, Timers & DMA | 40 | — | [ ] |
| 5  | ch05_uart_rs_serial.md | UART / RS232 / RS422 / RS485 | 35 | — | [ ] |
| 6  | ch06_spi_i2c.md | SPI & I2C | 30 | — | [ ] |
| 7  | ch07_can_bus.md | CAN Bus Deep Dive | 45 | — | [ ] |
| 8  | ch08_avionics_buses.md | Avionics Data Buses | 40 | — | [ ] |
| 9  | ch09_rtos_realtime.md | RTOS & Real-Time | 40 | — | [ ] |
| 10 | ch10_control_pid.md | Control Systems & PID | 30 | — | [ ] |
| 11 | ch11_debugging_lab.md | Hardware Debugging & Lab Skills | 30 | — | [ ] |
| 12 | ch12_vnv_do178.md | V&V, DO-178B & Test Methodology | 30 | — | [ ] |
| 13 | ch13_coding_gym.md | 60 Embedded C Problems | 60 | — | [ ] |
| 14 | ch14_python_automation.md | Python for Test Automation | 25 | — | [ ] |
| 15 | ch15_project_deepdives.md | Her Project Deep-Dives | 25 | — | [ ] **BLOCKED — see note** |
| 16 | ch16_behavioral_company.md | Behavioral & Company Rounds | 20 | — | [ ] **BLOCKED — see note** |
| 17 | ch17_mock_interviews.md | 5 Full Mock Interviews | 20 | — | [ ] |

**Cumulative estimate:** ~11.6 pp of ~520.

## Session log

### Session 1 — Chapter 1, Part 1 (pointers → structs/unions/padding)
- Wrote Part 1: Primer, 3-tier Q&A (8 + 7 + 7 questions), Coding Gym (8 problems),
  resume-link box, 10-question scorecard with answer key.
- **All C code verified:** 8 compilable snippets built clean under
  `gcc -Wall -Wextra -std=c11` with zero warnings; outputs confirmed (incl. struct
  sizes 12/8 and IEEE-754 float bytes `00 00 80 3F`). One register-access fragment
  is correctly marked `// target-only` and excluded from host compilation.
- Page estimate ~11.6 pp. Part 1 is roughly half of Ch 1's 70 pp budget, so Part 2
  is expected to bring the chapter to ~23 pp of content — under the 70 pp budget.
  **Budget note:** the 70 pp figure in PLAN.md assumes a denser per-topic expansion
  (30 Q&A / 35 code / 5 concept). If we want to hit budget, Part 2 + a later pass
  should expand the Q&A tiers and add ~10 more Coding Gym problems. Flagged so it is
  not silently under budget. No build run yet (first build scheduled after session 5).

## Open flags / [VERIFY] / [NEEDS INTAKE] items
- **Chapters 15 & 16 are HARD-BLOCKED.** Per PLAN.md Section 5 and CLAUDE.md, they
  must be written ONLY from `inputs/INTAKE.md`, and every REQUIRED `[FILL]` field in
  that file is still empty. Do not start Ch 15/16 — and do not invent project facts —
  until INTAKE.md's REQUIRED section is complete and the user confirms.
- No `[VERIFY]` protocol/standard markers were needed in Ch 1 Part 1.
- Ch 1 is tracking under its 70 pp budget (see session-1 budget note above).
