# EXPANSION PLAN v2 — Make the Book Teachable (3/10 → 9/10)

**Why this plan exists:** the current book (196 pp) is *correct and dense* but reads
like an **expert reference**, not a **teacher**. The candidate rated it **3/10**:
"content is very less [to actually learn from], got panic by seeing contents,
can't absorb the knowledge." It also **mis-attributes** BEL vs TASL work, is
**ARM-architecture-heavy** (overwhelming), and is **missing STM32 / CubeIDE /
VS Code / FreeRTOS** depth that the job market and her current TASL role demand.

This plan re-architects the book to **teach from zero → strong**, anchored to
**her real hardware** and **what employers actually hire for**.

---

## 1. RESEARCH FINDINGS (grounding)

### 1a. The "relatable" course style (the shared Udemy course's shape)
The shared link is login-gated, but it matches the best-selling FastBit /
bare-metal STM32 family. Their winning pedagogy:
- **Absolute-beginners first** ("Embedded C for absolute beginners" → "drivers
  from scratch"). Build up, never assume.
- **One board, hands-on, incremental.** STM32 + STM32CubeIDE; blink → UART →
  SPI/I2C → drivers → RTOS, each a small win.
- **Drivers from scratch** (GPIO, UART, SPI, I2C) — show every register.
- **Lots of small worked examples**, not walls of Q&A.

### 1b. Job-market skills (what roles require — 2026)
**Embedded Systems Engineer:** Embedded C (pointers + bit manipulation = #1),
ARM Cortex-M / **STM32**, peripheral programming (GPIO/ADC/UART/SPI/I2C/timers/
PWM), **custom device drivers**, CAN/SPI/I2C/UART, **RTOS (FreeRTOS/Zephyr)**,
**STM32CubeIDE / VS Code / Git**, JTAG/SWD + logic analyzer + scope debugging,
bootloaders.
**Avionics / UAV firmware:** C (+ Ada/assembly a plus), Cortex-M architecture,
**RTOS (FreeRTOS/VxWorks)**, **DO-178C**, configuration management, HW debug
tools, 5+ yrs aerospace preferred.
**Takeaway:** the book already nails protocols + avionics + V&V (her
differentiator). It is **under-weight on STM32, CubeIDE/VS Code, FreeRTOS, and
driver-from-scratch** — the exact things every generalist embedded role screens
for. Add those and she fits **both** aerospace and mainstream embedded roles.

### 1c. Hardware facts (her real kit)
- **LPC1778** (TASL): NXP **Cortex-M3**, 120 MHz, 512 KB flash / 96 KB RAM,
  Ethernet, USB, **2× CAN**, **5× UART**, 3× SPI, 3× I2C, 8-ch DMA, ADC/DAC,
  motor-control PWM — ideal autopilot MCU.
- **STM32** (TASL): ST Cortex-M family; STM32CubeIDE/CubeMX is the standard
  toolchain.
- **LPC3250** (BEL): ARM9 (application core, MMU, caches) — the *fighter* DFCC
  platform. (This is why ARM9 depth belongs in BEL context, not the daily ramp.)

---

## 2. AUDIT — why the book is 3/10 (and the fixes)

| Problem | Evidence | Fix (which phase) |
|---|---|---|
| **Reads as expert reference, not teacher** | Terse spoken-length answers; no build-up; assumes the reader already knows the term | Add "Concept Zero" plain-English ramps + worked examples (Ph 3,6,7) |
| **Overwhelming / panic on sight** | Dense Q&A walls, heavy jargon, 196 pp with no gentle on-ramp | De-panic intro, difficulty tiers, glossary, bite-size lessons (Ph 1) |
| **ARM architecture too deep too early** | Ch 3 = pipeline/MMU/bit-banding/exception internals up front | Slim Ch 3 to "MCU essentials"; move deep ARM to optional *Under the Hood* appendix (Ph 5) |
| **STM32 under-served** | No STM32-specific chapter; only abstract Cortex-M | **Add 3 STM32 chapters** anchored to STM32 + LPC1778 (Ph 4) |
| **Missing toolchain** | No STM32CubeIDE/CubeMX, no VS Code, thin Git | Add a "Your Toolbox" chapter (Ph 2) |
| **RTOS too abstract** | Ch 9 is generic RTOS theory | Re-anchor on **FreeRTOS** hands-on (Ph 7) |
| **BEL/TASL mis-attributed** | DFCC/AETS/signal-conditioning placed at TASL; they are **BEL** | Apply corrected domain map everywhere (Ph 1) |
| **No drivers-from-scratch** | Coding gym is generic C, not STM32 peripheral drivers | Add driver mini-labs (Ph 4, 8) |
| **Few visuals** | Almost no diagrams; all prose | Add timing/block/memory diagrams (Ph 10) |

**Resume audit (this round):** the previous fix put DFCC/AETS/signal-conditioning
at TASL — **wrong**. Corrected below. Also add STM32, LPC1778, STM32CubeIDE/CubeMX,
VS Code to skills; differentiate the two platforms.

---

## 3. CORRECTED BEL ↔ TASL DOMAIN MAP (authoritative)

> Single source of truth for every chapter, the resume, and Ch 15/16.
> **Never mix these two columns.**

| | **BEL — previous (Nov 2023 – Jan 2026)** | **TASL — current (Jan 2026 – present)** |
|---|---|---|
| **Program** | LCA Tejas **MK1 / MK1A / MK2** (fighter) | **UAV** R&D |
| **Project** | **DFCC AETS**, ESS / R&D activities | UAV autopilot & avionics |
| **Flight-control HW** | **DFCC cards**, **Signal Conditioning Cards (SCC)**, **HSCC**, **SBC** (Single Board Computer) | **Autopilot system**, autopilot boards, supporting boards (PDU, IRNSS, VMNSC, baseboard) |
| **Units / LRUs** | (card-level inside DFCC) | **TLM 50**, **CBLM**, **ERLM**; PSU200, AU, AIU, INSU, CAN servos, radio, pitot (Laversab) |
| **MCU / CPU** | **LPC3250 (ARM9)**, DPRAM, BSP, RTSM | **STM32 (Cortex-M)**, **LPC1778 (Cortex-M3)** |
| **Data links / protocols** | **CCDL**, **SPIL**, **RS422**, MIL-STD-1553B | CAN, RS232, RS485, UART, Ethernet |
| **Software / V&V** | Embedded C firmware V&V, **Python 1553B/RS422 automation (~60%)**, DO-178B Level A, ATP/QTP, SAP QM/AS9100 | Embedded C dev/integration, board bring-up (ST-Link/J-Link), HSI, root-cause analysis |

**Terms to define in the glossary (and confirm via INTAKE.md):** DFCC, AETS,
SCC, **HSCC** [expansion TBC], **SBC** = Single Board Computer, CCDL = Cross-
Channel Data Link, SPIL [expansion TBC], DPRAM, RTSM = Real-Time Software Module,
ESS [Environmental Stress Screening? — confirm], **TLM 50 / CBLM / ERLM**
[UAV unit expansions TBC], LPC3250, LPC1778, STM32.

---

## 4. RE-ARCHITECTED TABLE OF CONTENTS (the new shape)

Goal: a **gentle ramp** (Foundation → Core → Stretch), STM32-anchored, with deep
ARM made *optional*. ~28 numbered chapters across 8 parts (still no filler — but
now with teaching scaffolding, worked examples, and visuals).

**PART 0 — Orientation & Survival (NEW)**
- 0.1 Start Here (warm, "don't panic", how to use, the readiness ladder)
- 0.2 Your Toolbox — **STM32CubeIDE & CubeMX, VS Code (+ extensions), Keil,
  Git, ST-Link/J-Link**: install → first blink → first debug (hands-on)
- 0.3 Glossary & Hardware Dictionary (her BEL + TASL terms)

**PART 1 — Embedded C from Zero (expanded, gentle)**
- 1 Embedded C Part 1 — variables, pointers, arrays, structs (with analogies)
- 2 Embedded C Part 2 — volatile/const/static, bit manipulation, endianness
- 3 Memory & Toolchain — gentle memory map, build pipeline, stack vs heap

**PART 2 — Microcontrollers & STM32 (the 3 STM32 chapters)**
- 4 **STM32 #1 — MCU basics & first project:** what's inside a Cortex-M, CubeMX
  clock/pin config, GPIO, registers gently (anchored to STM32 + LPC1778)
- 5 **STM32 #2 — Peripherals & drivers from scratch:** GPIO, UART/USART, timers
  & PWM, ADC — CubeIDE *and* bare-metal register view
- 6 **STM32 #3 — Interrupts, DMA, SPI/I2C, low-power & bootloader:** NVIC gently,
  DMA, RTC/watchdog, debugging on the chip
- *(Appendix U — "Under the Hood: ARM Architecture" — pipeline, MMU, bit-banding,
  exception internals, ARM9/LPC3250 — moved here, tagged **Stretch/optional**)*

**PART 3 — Communication Protocols (gentler + relatable)**
- 7 UART / RS232 / RS422 / RS485  · 8 SPI & I2C · 9 CAN Bus · 10 Avionics Buses
  (1553B / ARINC 429 / CCDL / SPIL — anchored to her BEL work)

**PART 4 — Real-Time, Control & Lab**
- 11 **RTOS with FreeRTOS** (hands-on tasks/queues/semaphores) + DPRAM (BEL)
- 12 Control & PID (gentle) · 13 Hardware Debugging & Lab (CubeIDE debugger,
  scope, logic analyzer, bring-up)

**PART 5 — V&V & Safety**
- 14 V&V, DO-178B/C & Test Methodology

**PART 6 — Coding Gym (graded ramp)**
- 15 Embedded C problems (now with very-easy warm-ups first) · 16 STM32 driver
  mini-labs · 17 Python for Test Automation

**PART 7 — Interview Execution**
- 18 Her Project Deep-Dives (BEL + TASL, from INTAKE.md) · 19 Behavioural &
  Company · 20 Mock Interviews

**Appendices:** U (ARM deep dive), Cheat Sheet, Glossary, Job-Market Skills Map.

---

## 5. THE 10-PHASE PLAN (execution roadmap)

Each phase is a shippable increment: it compiles clean, is verified, and is
committed. Estimated effort is per phase, not per day.

### Phase 1 — Foundation reset + accurate facts
- Apply the **corrected BEL/TASL domain map** to the resume, Ch 8, Ch 15, Ch 17.
- Rewrite the Introduction to be gentle ("you've got this", no prerequisites,
  difficulty tiers Foundation/Core/Stretch).
- Build the **Glossary & Hardware Dictionary** from her terms.
- Add per-chapter "What you'll be able to say" + "Time: ~X min" + difficulty tag.

### Phase 2 — "Your Toolbox" chapter (IDEs)
- STM32CubeIDE + CubeMX (project, clock, pinout), **VS Code** (+ embedded
  extensions / PlatformIO), Keil, **Git** basics, ST-Link vs J-Link.
- Walkthrough: install → generate a project → blink an LED → set a breakpoint.

### Phase 3 — Embedded C from Zero (rewrite, expand)
- Add "Concept Zero" analogies to Ch 1–2; "explain like I'm new" first, then the
  crisp interview line. More worked examples; bit-manipulation made visual.

### Phase 4 — STM32 Trilogy (biggest content add)
- Write 3 STM32 chapters (basics+CubeMX+GPIO; peripherals/drivers from scratch;
  interrupts/DMA/SPI/I2C/bootloader). Anchor to **STM32 + LPC1778**.
- Each peripheral: CubeMX way **and** register-level driver from scratch (verified C).

### Phase 5 — Reduce/relocate ARM depth
- Slim Ch 3-architecture to "MCU essentials"; move pipeline/MMU/bit-banding/
  exception internals into **Appendix U (Stretch)**. Reduces overwhelm.

### Phase 6 — Protocols, gentler + visual
- Add Concept-Zero + ASCII/TikZ timing & frame diagrams to UART/SPI/I2C/CAN/
  avionics. Re-anchor 1553B/CCDL/SPIL/RS422 to **BEL**; CAN to **TASL**.

### Phase 7 — RTOS (FreeRTOS) + Control + Lab, hands-on
- Re-anchor RTOS chapter on **FreeRTOS** (create tasks, queues, semaphores,
  the tick); keep DPRAM as the BEL deep-dive. Gentle PID; lab chapter uses the
  CubeIDE debugger + her instruments.

### Phase 8 — V&V + Coding Gym expansion
- Gentle V&V/DO-178 ramp. Coding gym: add very-easy warm-ups, grade the 60
  problems, add **STM32 driver mini-labs** (Ch 16). Keep all C verified.

### Phase 9 — Projects (BEL/TASL from INTAKE) + Mocks + Job map
- Once INTAKE.md is filled, write Ch 18/19 to the corrected multi-project split
  (BEL: DFCC AETS/SCC/HSCC/SBC, CCDL, SPIL, RS422, DPRAM, 1553B; TASL: autopilot,
  STM32/LPC1778, TLM50/CBLM/ERLM, board bring-up). Update mocks. Add the
  **Job-Market Skills Map** appendix (have vs target, with a learning checklist).

### Phase 10 — Pedagogy polish, visuals, final build
- Friendly tone pass; **every acronym defined on first use**; add figures;
  spaced-repetition flashcards + a 12-week gentle schedule; compile clean
  (zero warnings); produce the book **and** a condensed **Pocket Guide**.

---

## 6. PEDAGOGY RULES (apply in every phase)
1. **Define before you use** — no naked acronym; first use gets a plain-English gloss.
2. **Concept Zero first** — analogy + why-it-matters + the one picture, *then* depth.
3. **Two-speed answers** — "explain like I'm new" paragraph, then the crisp
   interview sentence.
4. **Anchor to her kit** — STM32/LPC1778 (TASL), LPC3250 (BEL), her real units.
5. **Small wins** — short lessons, frequent worked examples, a runnable result.
6. **Stretch is optional** — deep ARM/theory is clearly tagged and skippable.
7. **Still no filler** — scaffolding yes, padding no; every page earns its place.

---

## 7. STATUS / NEXT
- This document = the agreed re-architecture. Execution starts at **Phase 1**.
- Gate unchanged: **Ch 18/19 (project/behavioural) need `inputs/INTAKE.md`** —
  and INTAKE now also needs the **TASL** facts (TLM50/CBLM/ERLM/STM32/LPC1778/
  autopilot duties) and the BEL term expansions (HSCC, SPIL, AETS, ESS).
