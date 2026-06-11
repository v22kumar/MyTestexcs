# INTAKE.md — Real-Work Questionnaire (sole source for Chapters 15 & 16)
# Place at inputs/INTAKE.md. Fill every [FILL] in the REQUIRED section before
# Chapter 15 is written. Answers can be rough notes / broken English — the book
# will polish the language, but the FACTS come from here. Do not exaggerate:
# anything written here will be scripted as her spoken interview answers.

## ═══ REQUIRED — PROJECT FACTS ═══

### A. DFCC / AETS-DFCC SC card testing (TASL)
1. What exactly does she check when testing a DFCC card? (signals, voltages, comm links, pass/fail criteria): [FILL]
2. What test setup is used? (which power supply, which boards connect to what, which software on the PC side): [FILL]
3. What does the AETS-DFCC SC (signal conditioning) card condition? Which sensor signals come in, what goes out: [FILL]
4. One REAL problem/defect she found, how it was noticed, and how it got resolved: [FILL]
5. What documents does she write or follow? (test procedures, reports, checklists): [FILL]

### B. CCDL (Cross Channel Data Link)
6. Between which channels/cards does the CCDL run, and over what physical link: [FILL]
7. What does she verify about it? (data integrity? timing? failover? how is pass/fail decided): [FILL]
8. What tool shows her the CCDL data? (software, scope, custom GUI): [FILL]

### C. SPIL serial data link
9. What is SPIL connecting, and what does she test on it: [FILL]
10. Any numbers she knows cold: baud rate, packet size, update rate, latency: [FILL]

### D. Embedded C / RS422 work
11. What does the Embedded C code she writes/modifies actually DO? (test routine? driver? parser?): [FILL]
12. Which IDE/compiler/debugger does she use for it, and on which microcontroller/board: [FILL]
13. Has she flashed/debugged with ST-Link or J-Link herself? On which boards: [FILL]

### E. Daily lab reality
14. Which instruments does she personally operate weekly? (scope model if known, DMM, electronic load, Laversab, supplies): [FILL]
15. Which autopilot board versions / LRUs has she actually handled vs only seen in the lab: [FILL]
16. Team structure: how many people, who assigns her work, who does she report results to: [FILL]

### F. BEL work (verify the old resume claims)
17. The Python automation suite: what did it parse, how was the 60% reduction measured (or estimated)?: [FILL]
18. The DPRAM polling validation: what was her exact part in it: [FILL]
19. Which BEL claims on the resume is she LEAST comfortable defending? (be honest — we'll soften or prepare them): [FILL]

## ═══ REQUIRED — CHAPTER 16 (BEHAVIORAL) FACTS ═══
20. Why did she move from BEL to the Valentra/TASL contract role? (real reason, we'll phrase it well): [FILL]
21. Notice period and current/expected CTC range she wants to state: [FILL]
22. One real conflict or disagreement at work and how it ended: [FILL]
23. One real failure/mistake and what changed after it: [FILL]
24. One real tight-deadline story: [FILL]
25. Career gap or anything in the history an interviewer might probe: [FILL]

## ═══ OPTIONAL — STRENGTHENS THE SCRIPTS ═══
26. Anything she did beyond her assigned role (initiative, tool she made, process she improved): [FILL]
27. Topics she fears most in interviews (be specific — these get extra prep): [FILL]
28. Companies/roles she is actually targeting first: [FILL]
29. Languages she's comfortable interviewing in: [FILL]
30. Any personal embedded project in progress (board, what it does, status): [FILL]

# RULE FOR CLAUDE CODE: If any REQUIRED [FILL] remains, do not write Chapter 15
# content for that item — insert [NEEDS INTAKE: Q<n>] and list it in progress.md.
