# CV

Abhirath Anand's CV, written in [Typst](https://typst.app) on a vendored fork of the
[modern-cv](https://github.com/ptsouchlos/modern-cv) template (`modern-cv/`).

## Layout

- `cv.typ` – header, contacts, page setup and section order
- `sections/` – one file per section
- `references.bib` – publications; mark your own name with `author+an = {N=highlight}`
- `modern-cv/` – the template (see its README for changes from upstream)
- `fonts/` – Source Sans 3 and Font Awesome 7, used exclusively for reproducible builds

## Build

Requires `typst` and `just`.

```sh
just compile-cv   # writes cv.pdf
just watch-cv     # recompiles on save
```
