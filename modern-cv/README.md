# modern-cv (vendored fork)

A trimmed fork of [modern-cv](https://github.com/ptsouchlos/modern-cv) 0.10.0 by
Paul Tsouchlos (MIT, see `LICENSE`), kept in-tree so it can be changed freely
without waiting on upstream.

## Changes from upstream

- Only the resume template is kept: the cover letter, profile picture, positions,
  address, built-in contact types and translations (`linguify`, `lang.toml`) are gone.
- Header contacts are an ordered list: `author.contacts: ((text, icon, link), ...)`.
- `margin` and `footer-label` are parameters (defaults: modern-cv margins, "Curriculum Vitae").
- A restrained typographic system replaces the original styling (tokens at the top
  of `lib.typ`): one family (Source Sans 3), one muted accent colour (#1F4E79) for
  section headings, links and the timeline, and weight rather than size for hierarchy.
  Section headings are tracked capitals with a hairline rule; entry titles are
  semibold with dates on the same line in tabular figures; subtitles are small caps;
  body text is 9.5pt regular, ragged right with 1.35× leading; spaced hyphens in
  ranges become en dashes.
- Awesome-CV components: `cventry`, `cvsubsection`, `cvhonors`/`cvhonor`,
  `cvgroup`/`cvrole` (several roles at one place, joined by a timeline),
  `resume-skills`/`resume-skill-item`, `cvlink`.
- `publications(read("refs.bib"), keys)`: biblatex-style list sorted newest first,
  bolding authors marked with `author+an = {N=highlight}`.

Remaining package dependencies: `fontawesome` (icons) and `citegeist` (BibTeX parsing).
