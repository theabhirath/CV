#import "../modern-cv/lib.typ": *

= Publications

// Equivalent of `\nocite{...}` + `\printbibliography[sorting=ydnt]`.
// Highlighted authors are taken from the `author+an` field in references.bib.
#publications(read("../references.bib"), (
  "KrishnakantKushwaha2024",
  "Shirsath2025",
))
