// Vendored and reworked fork of modern-cv 0.10.0 by Paul Tsouchlos (MIT, see LICENSE)
// https://github.com/ptsouchlos/modern-cv
//
// Changes from upstream:
// - Only the resume template is kept (no cover letter, profile picture,
//   positions, address or translations; `linguify` is no longer needed).
// - Header contacts are a plain ordered list of (text, icon, link).
// - Page margins and the footer label are parameters.
// - A restrained typographic system (see "Design tokens" below) replaces the
//   original styling: one type family, one accent colour, weight for hierarchy.
// - Awesome-CV components the CV needs (`cventry`, `cvgroup`, `cvhonors`,
//   `cvsubsection`, biblatex-style publications) live here.

#import "@preview/fontawesome:0.6.0": fa-icon
#import "@preview/citegeist:0.3.1": load-bibliography

/// ---- Design tokens ----
//
// Hierarchy is carried by weight and colour within a single family, so each
// level of information has exactly one distinguishing treatment:
//   section   -> tracked capitals in the accent colour, hairline rule
//   title     -> semibold, darkest ink
//   subtitle  -> small caps, muted
//   meta      -> (dates, places) muted, upright, tabular figures
//   body      -> regular weight, ragged right, generous leading

#let accent = rgb("#1F4E79") // muted navy: headings, links, timeline
#let ink = rgb("#1A1A1A") // titles and emphasis
#let body-ink = rgb("#333333") // running text
#let muted = rgb("#6B6B6B") // subtitles, dates, places
#let faint = rgb("#A6A6A6") // footer, bullets, rules
#let rule-color = rgb("#D0D0D0")

#let size-name = 26pt
#let size-section = 10.5pt
#let size-title = 10.5pt
#let size-body = 9.5pt
#let size-meta = 9pt
#let size-small = 8pt

// Dates and other figures line up when stacked
#let meta(body) = text(size: size-meta, fill: muted, number-width: "tabular", body)

/// ---- Helpers ----

// Title on the left, meta on the right, sharing a baseline
#let __row(primary, secondary) = grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  align: (left + bottom, right + bottom),
  primary, secondary,
)

#let __title(body) = text(size: size-title, weight: "semibold", fill: ink, body)

#let __subtitle(body) = text(
  size: size-meta,
  fill: muted,
  tracking: 0.02em,
  smallcaps(body),
)

#let __footer(name, label, date) = {
  set text(fill: faint, size: size-small, tracking: 0.03em, number-width: "tabular")
  grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    smallcaps(date), smallcaps(name + "  ·  " + label), context counter(page).display(),
  )
}

/// A header contact item: an optional Font Awesome icon followed by text,
/// optionally linked.
/// - item (dictionary): text (string, required), icon (string, optional), link (string, optional)
#let __contact_item(item) = box({
  if "icon" in item {
    box(fa-icon(item.icon, fill: accent, size: 0.95em))
    h(0.4em)
  }
  if "link" in item { link(item.link, item.text) } else { item.text }
})

/// ---- Resume Template ----

/// Resume template, originally inspired by the Awesome CV LaTeX template by posquit0.
///
/// - author (dictionary): firstname, lastname and contacts (array of (text, icon, link) dictionaries, shown in order)
/// - contact-items-separator (content): Separator between contact items in the header
/// - date (string): The date shown in the footer
/// - footer-label (string): Text after the author's name in the footer
/// - margin (dictionary): Page margins
/// - title (str): The PDF title
/// - description (str | none): The PDF description
/// - keywords (array | str): The PDF keywords
/// - body (content): The body of the resume
#let resume(
  author: (:),
  contact-items-separator: h(1.4em),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  show-footer: true,
  footer-label: "Curriculum Vitae",
  language: "en",
  font: "Source Sans 3",
  paper-size: "a4",
  margin: (x: 1.8cm, top: 1.4cm, bottom: 1.8cm),
  title: "Curriculum Vitae",
  description: none,
  keywords: (),
  body,
) = {
  let name = author.firstname + " " + author.lastname

  set document(
    author: name,
    title: title,
    description: if description == none { title + " of " + name } else { description },
    keywords: keywords,
  )

  set text(
    font: font,
    lang: language,
    size: size-body,
    fill: body-ink,
    fallback: true,
  )

  set page(
    paper: paper-size,
    margin: margin,
    footer: if show-footer { __footer(name, footer-label, date) },
    footer-descent: 40%,
  )

  // Ragged right: even word spacing matters more than a hard right edge on
  // lines this long, and it removes the need for hyphenation.
  set par(justify: false, leading: 0.6em, spacing: 0.6em)
  set text(hyphenate: false)

  // Emphasis inside running text is a step up in weight and ink, not a shout
  show strong: it => text(weight: "semibold", fill: ink, it.body)

  // Spaced hyphens in ranges ("2022 - 2023") become proper en dashes
  show " - ": [#sym.space.thin#sym.dash.en#sym.space.thin]

  set list(
    marker: text(fill: faint, size: 0.8em, baseline: -0.05em, sym.bullet),
    indent: 0.15em,
    body-indent: 0.6em,
    spacing: 0.5em,
  )

  set heading(numbering: none, outlined: false)

  show heading.where(level: 1): it => block(above: 1.9em, below: 0.9em, sticky: true, grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    align: horizon,
    text(size: size-section, weight: "bold", fill: accent, tracking: 0.12em, upper(it.body)),
    line(length: 100%, stroke: 0.5pt + rule-color),
  ))

  // Name
  align(center, block(below: 0.9em, text(
    size: size-name,
    tracking: 0.01em,
  )[#text(weight: "light", fill: muted, author.firstname) #text(weight: "semibold", fill: ink, author.lastname)]))

  // Contacts
  {
    set text(size: size-meta, fill: body-ink)
    let items = author.at("contacts", default: ()).map(__contact_item)
    align(center, items.join(contact-items-separator))
  }

  body
}

/// Body text of an entry, typically a bullet list
#let resume-item(body) = block(above: 0.65em, below: 0pt, width: 100%, body)

/// The heading of an entry: title and date on the first line, subtitle and
/// location on the second.
#let resume-entry(
  title: none,
  location: "",
  date: "",
  description: "",
) = block(sticky: true, {
  __row(__title(title), meta(date))
  if description != "" or location != "" {
    block(above: 0.5em, below: 0pt, __row(__subtitle(description), meta(location)))
  }
})

/// Show a list of skills under a given category.
/// - category (string): The category of the skills
/// - items (list): The skills; emphasise any with `strong`
#let resume-skill-item(category, items) = (
  align(right, text(weight: "semibold", fill: ink, category)),
  items.join(", "),
)

// `\begin{cvskills} ... \end{cvskills}`: categories right-aligned in one column
#let resume-skills(..items) = grid(
  columns: (auto, 1fr),
  column-gutter: 1.2em,
  row-gutter: 0.7em,
  ..items.pos().flatten(),
)

/// ---- Awesome-CV components ----

// Link in the accent colour (replaces Awesome-CV's red `\href`s)
#let cvlink(url, body) = link(url, text(fill: accent, body))

// `\cventry{position}{title}{location}{date}{description}`
// The 2nd argument is the title and the 1st the subtitle, so the arguments
// keep the same order as the Awesome-CV LaTeX source.
#let cventry(position, title, location, date, body) = block(above: 1.15em, below: 0pt, breakable: false, {
  resume-entry(
    title: title,
    location: location,
    date: date,
    description: position,
  )
  if body != none {
    resume-item(body)
  }
})

// One role inside a `cvgroup`; same argument order as `cventry` minus title/location
#let cvrole(position, date, body) = (position: position, date: date, body: body)

// Several roles at one institution/company: the title and location are shown
// once, and the roles (newest first) hang off a timeline of dots and a line.
// Usage: #cvgroup([Title], [Location], cvrole(...), cvrole(...))
#let cvgroup(
  title,
  location,
  ..roles,
  dot-radius: 2.1pt,
  dot-y: 4.6pt, // vertical centre of the role line
  indent: 1.1em,
) = block(above: 1.15em, below: 0pt, breakable: false, {
  let roles = roles.pos()
  let n = roles.len()
  let rail = 0.6pt + faint
  let x = dot-radius // centre of the rail

  block(below: 0.5em, sticky: true, __row(__title(title), meta(location)))

  for (i, role) in roles.enumerate() {
    let last = i == n - 1
    let body = block(
      above: 0pt,
      below: 0pt,
      inset: (left: indent, bottom: if last { 0pt } else { 0.75em }),
      {
        __row(__subtitle(role.position), meta(role.date))
        if role.body != none {
          resume-item(role.body)
        }
      },
    )
    block(above: 0pt, below: 0pt, layout(size => {
      let h = measure(block(width: size.width, body)).height
      // rail from the previous dot down to this one
      if i > 0 {
        place(top + left, dx: x, line(start: (0pt, 0pt), end: (0pt, dot-y), stroke: rail))
      }
      // rail from this dot down to the next one
      if not last {
        place(top + left, dx: x, line(start: (0pt, dot-y), end: (0pt, h), stroke: rail))
      }
      place(top + left, dy: dot-y - dot-radius, circle(
        radius: dot-radius,
        fill: if i == 0 { accent } else { white },
        stroke: 0.7pt + accent,
      ))
      body
    }))
  }
})

// `\cvhonor{award}{event}{location}{date}`, rendered inside `cvhonors`
#let cvhonor(award, event, location, date) = (
  meta(date),
  [#text(weight: "semibold", fill: ink, award), #event],
  meta(location),
)

// `\begin{cvhonors} ... \end{cvhonors}`
#let cvhonors(..honors) = grid(
  columns: (auto, 1fr, auto),
  column-gutter: 1.2em,
  row-gutter: 0.7em,
  align: (left + bottom, left + bottom, right + bottom),
  ..honors.pos().flatten(),
)

// `\cvsubsection{...}`
#let cvsubsection(body) = block(above: 1.5em, below: 0.75em, sticky: true, text(
  size: size-meta,
  weight: "semibold",
  fill: muted,
  tracking: 0.06em,
  smallcaps(body),
))

/// ---- Publications (port of the biblatex setup in awesome-cv.cls) ----

// Convert the few LaTeX commands used in bib fields into Typst content
#let latex-to-content(s) = {
  let pattern = regex("\\\\(emph|textit|textbf)\{([^}]*)\}")
  let out = []
  let last = 0
  for m in s.matches(pattern) {
    out += s.slice(last, m.start)
    let (cmd, arg) = m.captures
    out += if cmd == "textbf" { strong(arg) } else { emph(arg) }
    last = m.end
  }
  out + s.slice(last)
}

// Indices (1-based) of names annotated with `highlight` in `author+an`,
// e.g. `author+an = {4=highlight}` or `{1=highlight;3=highlight}`
#let highlighted-indices(fields) = {
  let an = fields.at("author+an", default: "")
  an
    .split(";")
    .map(str.trim)
    .filter(a => a.ends-with("=highlight"))
    .map(a => int(a.split("=").first()))
}

// `\DeclareNameAlias{sortname}{given-family}` with highlighted names in bold
#let format-authors(entry) = {
  let hl = highlighted-indices(entry.fields)
  let names = entry.parsed_names.at("author", default: ()).enumerate().map(((i, n)) => {
    let name = (n.given, n.prefix, n.family, n.suffix).filter(p => p != "").join(" ")
    if (i + 1) in hl { strong(name) } else { name }
  })
  if names.len() <= 2 {
    names.join(" and ")
  } else {
    names.join(", ", last: ", and ")
  }
}

// Bibliography driver for `article` entries: title, authors, venue
#let publication(entry) = {
  let f = entry.fields
  block(above: 1.15em, below: 0pt, breakable: false, {
    __title(latex-to-content(f.title))
    block(above: 0.45em, below: 0pt, text(size: size-meta, fill: muted, format-authors(entry)))
    block(above: 0.45em, below: 0pt, text(size: size-meta, fill: muted)[
      #emph(f.at("journal", default: f.at("journaltitle", default: ""))), #f.year
      #if "doi" in f [
        #h(0.3em)·#h(0.3em) #cvlink("https://doi.org/" + f.doi)[doi:#f.doi]
      ]
    ])
  })
}

// `\nocite{...}` + `\printbibliography` sorted by year, descending (ydnt).
// `bib` is the contents of a .bib file, e.g. `read("references.bib")`.
#let publications(bib, keys) = {
  let bib = load-bibliography(bib, sentence-case-titles: false)
  let entries = keys.map(k => bib.at(k))
  for entry in entries.sorted(key: e => -int(e.fields.year)) {
    publication(entry)
  }
}
