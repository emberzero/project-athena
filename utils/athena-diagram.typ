// Project Athena / EmberZero — shared preamble for lecture diagrams.
//
// Diagrams are written in Typst and compiled to self-contained SVG. Typst embeds
// every glyph as a path, so the result keeps Berkeley Mono and the brand colours
// without the reader needing either, and renders identically in GitHub, GitBook
// and the lecture PDF.
//
// A diagram source lives next to the lecture that uses it:
//
//   Curriculum/Module 06 - Assembly/lectures/diagrams/stack-frame.typ   <- source
//   Curriculum/Module 06 - Assembly/lectures/images/stack-frame.svg     <- built
//
// and the lecture references the built file with ordinary Markdown:
//
//   ![Layout of a stack frame](images/stack-frame.svg)
//
// Build everything with utils/build_diagrams.sh. Start a diagram source with:
//
//   #import "/utils/athena-diagram.typ": *
//   #diagram-page[ ... ]
//
// The leading "/" resolves against the repo root, which the build script passes
// via --root, so the import works from any module.
//
// WIDTH BUDGET: a lecture page gives a diagram 459pt. Anything wider is scaled
// down to fit, which shrinks the 9pt labels until they cannot be read. Aim for
// 300-440pt. build_diagrams.sh prints WIDE for anything over the limit. When a
// diagram does not fit, stack it into rows or shorten the labels; do not reduce
// the font size, which defeats the point.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.4.2"

// --- Brand -----------------------------------------------------------------

#let primary = rgb("#14b5fc")
#let primary-light = rgb("#72d3fd")
#let ink = rgb("#040404")
#let muted = rgb("#6b7280")
#let surface = rgb("#f6f8fa")
#let danger = rgb("#d93025")
#let warn = rgb("#d97706")
#let ok = rgb("#1a7f37")

// Fills for the usual roles in a security diagram.
#let fill-normal = primary.lighten(88%)
#let fill-accent = primary.lighten(70%)
#let fill-danger = danger.lighten(88%)
#let fill-warn = warn.lighten(85%)
#let fill-ok = ok.lighten(88%)
#let fill-neutral = surface

/// Wraps a diagram so the page is exactly the size of its content, with a white
/// background and the curriculum's typeface. Every diagram source should use it.
///
/// - body (content): the diagram itself
/// -> content
#let diagram-page(body) = {
  set page(width: auto, height: auto, margin: 8pt, fill: white)
  set text(font: "Berkeley Mono", size: 9pt, fill: ink)
  body
}

/// A labelled box, the default node shape.
#let dbox(pos, label, fill: fill-normal, ..args) = node(
  pos, label, fill: fill, stroke: 0.8pt + ink.lighten(20%), corner-radius: 2pt,
  inset: 6pt, ..args,
)

/// A box marked as attacker-controlled or dangerous.
#let dbad(pos, label, ..args) = dbox(pos, label, fill: fill-danger, ..args)

/// A box marked as a control or a safe state.
#let dgood(pos, label, ..args) = dbox(pos, label, fill: fill-ok, ..args)

/// A plain caption line under a diagram, for a legend or a note.
///
/// The width is fixed because `diagram-page` sets `width: auto`: an unwrapped
/// caption would set the page width on its own and push the whole diagram past
/// the 459pt the lecture page gives it, shrinking the labels to nothing.
/// ponytail: one shared width, not a per-diagram knob -- add a parameter only
/// when some diagram genuinely needs a different measure.
#let dnote-width = 380pt
#let dnote(body) = block(
  width: dnote-width,
  align(left, text(size: 7.5pt, fill: muted, body)),
)
