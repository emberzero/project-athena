// Project Athena / EmberZero — lecture PDF template.
//
// Renders a curriculum lecture written in Markdown as a branded PDF. One
// template for every lecture: pass the Markdown path in, nothing is generated
// per lecture.
//
//   typst compile utils/lecture-template.typ out.pdf --root . \
//     --input md="Curriculum/Module 02 - Reconnaissance/lectures/lecture_1_introduction.md"
//
// Optional inputs:
//   --input author="Marcel Schnideritsch"   byline on the cover
//   --input toc=false                       drop the table of contents
//
// Fonts are deliberately limited to two that are always present: Berkeley Mono
// comes from the athena-fonts submodule, Libertinus Serif ships inside Typst.

#import "@preview/cmarker:0.1.6"

// ---------------------------------------------------------------------------
// Brand
// ---------------------------------------------------------------------------

#let primary = rgb("#14b5fc")
#let primary-light = rgb("#72d3fd")
#let ink = rgb("#040404")
#let muted = rgb("#6b7280")
#let surface = rgb("#f6f8fa")

#let heading-font = "Berkeley Mono"
#let body-font = "Libertinus Serif"
#let mono-font = "Berkeley Mono"

// ---------------------------------------------------------------------------
// Inputs
// ---------------------------------------------------------------------------

#let md-path-raw = sys.inputs.at("md", default: none)
#if md-path-raw == none {
  panic("No markdown file given. Pass --input md=<path to lecture .md>")
}
// Paths in Typst resolve relative to this file; a leading "/" means the project
// root passed via --root, which is what callers actually mean.
#let md-path = if md-path-raw.starts-with("/") { md-path-raw } else { "/" + md-path-raw }

#let author = sys.inputs.at("author", default: "Project Athena")
#let show-toc = sys.inputs.at("toc", default: "true") != "false"

#let source = read(md-path)

// Directory holding the lecture, so images resolve next to the Markdown file
// rather than next to this template.
#let md-dir = {
  let parts = md-path.split("/")
  parts.slice(0, parts.len() - 1).join("/") + "/"
}

// "Curriculum/Module 02 - Reconnaissance/lectures/x.md" -> "Module 02 - Reconnaissance"
#let module-name = {
  let parts = md-path.split("/")
  let found = parts.filter(p => p.starts-with("Module "))
  if found.len() > 0 { found.first() } else { "Curriculum" }
}

// First `# Heading` becomes the cover title and is dropped from the body so it
// is not printed twice.
#let lines = source.split("\n")
#let title-idx = {
  let idx = none
  for (i, l) in lines.enumerate() {
    if idx == none and l.starts-with("# ") { idx = i }
  }
  idx
}
#let title = if title-idx != none {
  lines.at(title-idx).slice(2).trim()
} else {
  md-path.split("/").last().replace(".md", "").replace("_", " ")
}
#let body-source = if title-idx != none {
  lines.slice(title-idx + 1).join("\n")
} else { source }

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

#set document(title: title, author: author)

#set page(
  paper: "a4",
  margin: (top: 2.6cm, bottom: 2.4cm, x: 2.4cm),
  header: context {
    // No running header on the cover.
    if counter(page).get().first() <= 1 { return }
    set text(font: heading-font, size: 8.5pt, fill: muted)
    grid(
      columns: (1fr, auto),
      align: (left, right),
      module-name,
      title,
    )
    v(-0.45em)
    line(length: 100%, stroke: 0.5pt + primary.lighten(55%))
  },
  footer: context {
    if counter(page).get().first() <= 1 { return }
    set text(font: heading-font, size: 8.5pt, fill: muted)
    grid(
      columns: (1fr, auto),
      align: (left, right),
      "Project Athena",
      [#counter(page).display("1")],
    )
  },
)

#set text(font: body-font, size: 11pt, lang: "en", fill: ink)
#set par(justify: true, leading: 0.72em, spacing: 1.25em, first-line-indent: 0pt)

// ---------------------------------------------------------------------------
// Elements
// ---------------------------------------------------------------------------

#show heading: set text(font: heading-font, fill: ink)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  block(above: 0em, below: 0.9em)[
    #set text(size: 20pt, weight: "bold")
    #it.body
    #v(-0.5em)
    #line(length: 100%, stroke: 2pt + primary)
  ]
}
#show heading.where(level: 2): it => block(above: 1.6em, below: 0.7em)[
  #set text(size: 14pt, weight: "bold", fill: primary.darken(25%))
  #it.body
]
#show heading.where(level: 3): it => block(above: 1.4em, below: 0.55em)[
  #set text(size: 12pt, weight: "bold")
  #it.body
]
#show heading.where(level: 4): it => block(above: 1.15em, below: 0.4em)[
  #set text(size: 10.5pt, weight: "bold", fill: muted.darken(45%))
  #it.body
]

// Inline code
#show raw.where(block: false): it => box(
  fill: surface,
  inset: (x: 3.5pt, y: 1pt),
  outset: (y: 2.5pt),
  radius: 2pt,
  text(font: mono-font, size: 0.88em, fill: primary.darken(35%), it),
)

// Code blocks: accent bar on the left, matching the slide theme's quote block.
#show raw.where(block: true): it => block(
  width: 100%,
  fill: surface,
  stroke: (left: 2.5pt + primary),
  inset: (x: 10pt, y: 9pt),
  radius: (right: 2pt),
  breakable: true,
  text(font: mono-font, size: 8.8pt, it),
)

#show link: it => text(fill: primary.darken(20%), it)

// The header fill has to come from the table's own `fill` parameter. Setting it
// from a `show table.cell` rule silently does nothing, which leaves white header
// text on a white background.
#set table(
  stroke: (x, y) => (bottom: 0.5pt + luma(85%)),
  inset: (x: 7pt, y: 5.5pt),
  fill: (x, y) => if y == 0 { primary },
)
#show table.cell.where(y: 0): set text(font: heading-font, weight: "bold", size: 9.5pt, fill: white)
#show table: set text(size: 9.5pt)

#set list(indent: 0.6em, spacing: 0.72em)
#set enum(indent: 0.6em, spacing: 0.72em)

#show quote.where(block: true): it => block(
  width: 100%,
  fill: primary.lighten(93%),
  stroke: (left: 2.5pt + primary-light),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 2pt),
  it.body,
)

// ---------------------------------------------------------------------------
// Cover
// ---------------------------------------------------------------------------

#block[
  #set text(font: heading-font)
  #v(1.2cm)
  #text(size: 10pt, fill: primary, weight: "bold", upper(module-name))
  #v(0.35em)
  #line(length: 100%, stroke: 2.5pt + primary)
  #v(0.9em)
  #text(size: 26pt, weight: "bold")[#title]
  #v(1.4em)
  #text(size: 10pt, fill: muted)[#author]
]

#v(1.2em)

#if show-toc {
  block[
    #set text(font: heading-font)
    #text(size: 11pt, weight: "bold", fill: primary.darken(25%))[Contents]
    #v(0.5em)
    #set text(size: 9.5pt, fill: ink)
    #show outline.entry: it => link(it.element.location(), it.indented(it.prefix(), it.body()))
    #outline(title: none, depth: 2, indent: 1.2em)
  ]
}

#pagebreak()

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

#cmarker.render(
  body-source,
  h1-level: 1,
  smart-punctuation: true,
  blockquote: it => quote(block: true, it),
  // Images in the Markdown are relative to the lecture file, not to this template.
  scope: (
    image: (path, alt: none) => {
      let remote = path.starts-with("http://") or path.starts-with("https://")
      let p = if path.starts-with("/") or remote { path } else { md-dir + path }
      // Typst builds are hermetic: it reads png/jpg/gif/svg/webp from disk and
      // never fetches over the network. Anything else would abort the whole
      // build, so flag it in place and keep going.
      let ext = lower(p.split(".").last())
      if not remote and ext in ("png", "jpg", "jpeg", "gif", "svg", "webp") {
        if ext == "svg" {
          // Diagrams are authored at their intended size, with 9pt labels.
          // Forcing them to a percentage of the text width scales that text
          // down until it is unreadable, so render at natural size and shrink
          // only when the diagram would otherwise run off the page.
          layout(size => {
            let natural = measure(image(p)).width
            align(center, image(
              p,
              alt: alt,
              width: calc.min(natural, size.width),
            ))
          })
        } else {
          // Photos and screenshots have no meaningful natural size on paper.
          align(center, block(
            width: 85%,
            image(p, alt: alt, width: 100%),
          ))
        }
      } else {
        align(center, block(
          width: 85%,
          fill: surface,
          stroke: (left: 2.5pt + rgb("#d97706")),
          inset: (x: 10pt, y: 9pt),
          radius: (right: 2pt),
          align(left, text(font: mono-font, size: 8.5pt, fill: muted.darken(30%))[
            #if remote [
              Image omitted: it is hotlinked from the internet, and the build
              never fetches remote files. Download it next to the lecture
              (e.g. into `images/`) and link it relatively. \
              Source: `#p`
            ] else [
              Image omitted: Typst cannot read `.#ext` files. \
              Convert `#p` to PNG and update the Markdown link.
            ]
          ]),
        ))
      }
    },
  ),
)
