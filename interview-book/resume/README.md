# Resume Source

`Sushmita_Telasang_Resume.tex` is the **single source of truth** for the resume.

## The PDF is a build artifact

The compiled `Sushmita_Telasang_Resume.pdf` is **intentionally not committed** to
this repo. It is generated from the `.tex` and should be regenerated, never
hand-edited. Edit the `.tex`, then rebuild.

## How to build

Any standard TeX Live / MiKTeX install, or Overleaf:

```bash
pdflatex Sushmita_Telasang_Resume.tex
# run twice if hyperref warns about rerunning
```

On Overleaf: upload `Sushmita_Telasang_Resume.tex`, set the compiler to
`pdfLaTeX`, and click Recompile.

## Why this file exists in the book repo

`PLAN.md` Section 5 (the Chapter 15/16 no-fabrication protocol) requires a
**claim-vs-resume consistency check**: every project claim scripted in the
interview book must be consistent with what the resume states. This `.tex` is
the reference for that check. If `inputs/INTAKE.md` ever reveals that a resume
bullet overstates reality, fix it *here* (and log it in `progress.md`) — the
resume bends to reality, never the reverse.

## Design constraints (keep these when editing)

- ATS-friendly, single column, no tables / graphics / icons / text boxes.
- Plain (non-colored) hyperlinks so parsers read the text.
- Overleaf-compatible; no exotic packages.
