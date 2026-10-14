compile-cv:
    @typst compile --font-path fonts --ignore-system-fonts cv.typ cv.pdf

watch-cv:
    @typst watch --font-path fonts --ignore-system-fonts cv.typ cv.pdf
