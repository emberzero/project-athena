# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Project Athena is a comprehensive IT-Security curriculum designed for secondary colleges in engineering. The repository contains:

- **Curriculum modules** (22+ modules) covering topics from Ethics to Cloud Security
- **Typst-based slide generation** system for presentations
- **Markdown lectures** and assignments organized by module
- **Automated build pipeline** that compiles Typst slides to PDFs

## Repository Structure

```text
Curriculum/
├── Module 00 - Mindset/
├── Module 01 - Ethics and Legal/
├── Module 04 - Web Security/
│   ├── introduction.md          # Module overview
│   ├── lectures/                # Markdown lecture files
│   │   ├── lecture_1_*.md
│   │   └── lecture_2_*.md
│   ├── assignments/             # Student assignments
│   ├── slides/                  # Typst slide presentations
│   │   └── Module_04_*.typ
│   └── figures/                 # Images and diagrams
├── ...
└── SUMMARY.md                   # Auto-generated table of contents

typst-theme-emberzero/          # Git submodule: EmberZero Typst theme
athena-fonts/                    # Git submodule: custom fonts
utils/                           # Helper scripts
```

## Common Commands

### Building Slides

The project uses Nix flakes for reproducible builds. Typst slides are automatically compiled via CI/CD, but can be built locally:

```bash
# Build all slides (requires Nix with flakes enabled)
nix build .?submodules=1#

# Output PDFs are in result/
ls result/*.pdf
```

For local development without Nix:

```bash
# Compile a single slide file
typst compile "Curriculum/Module 04 - Web Security/slides/Module_04_Slides_Intro_Burp.typ" output.pdf --root .

# Watch mode for live reloading
typst watch "Curriculum/Module 04 - Web Security/slides/Module_04_Slides_Intro_Burp.typ" output.pdf --root .
```

### Building Lecture PDFs

Lectures are Markdown. `utils/lecture-template.typ` renders any of them as a
branded PDF; there is one template for the whole curriculum, so lectures never
need a `.typ` file of their own.

```bash
# All lectures -> out/lectures/
cd utils && ./build_lectures.sh

# Only one module
cd utils && ./build_lectures.sh "Module 02"

# A single lecture, by hand
typst compile utils/lecture-template.typ out.pdf --root . \
  --input md="Curriculum/Module 02 - Reconnaissance/lectures/lecture_1_introduction.md"
```

Optional inputs: `--input author="Name"` for the cover byline, `--input toc=false`
to drop the table of contents. CI builds these alongside the slides and attaches
them to the same release.

**Images in lectures** are resolved relative to the Markdown file. Typst reads
png, jpg, gif, svg and webp from disk. It never fetches over the network, so a
hotlinked URL renders as a visible placeholder rather than failing the build.

### Building Lecture Diagrams

Diagrams are written in Typst and compiled to self-contained SVG. Typst embeds
every glyph as a path, so a built diagram keeps Berkeley Mono and the brand
colours without the reader having either font, and renders identically in
GitHub, GitBook and the PDF.

```text
Curriculum/<Module>/lectures/diagrams/<name>.typ   source, committed
Curriculum/<Module>/lectures/images/<name>.svg     built, committed
```

```bash
cd utils && ./build_diagrams.sh               # all diagrams
cd utils && ./build_diagrams.sh "Module 06"   # one module
```

A diagram source starts with the shared preamble and wraps its body:

```typst
#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    dbox((0, 0), [Client]), edge("-|>", [TLS]), dbox((1, 0), [Server]),
  )
]
```

The leading `/` resolves against the repo root, which the script passes via
`--root`. `utils/athena-diagram.typ` provides fletcher and cetz, the brand
palette, and the node helpers `dbox` (normal), `dbad` (attacker-controlled),
`dgood` (a control) and `dnote` (caption).

Lectures reference the built file with ordinary Markdown, so the diagram works
in every output format:

```markdown
![What the diagram shows](images/<name>.svg)
```

A lecture page gives a diagram **459pt** of width, and `build_diagrams.sh` prints
`WIDE` for anything over it. A wider diagram is scaled down to fit, shrinking its
9pt labels until they cannot be read, so aim for 300-440pt and stack rows rather
than spreading nodes horizontally. SVG diagrams render at natural size in the
PDF; only raster images are fitted to a percentage of the text width.

For a quick inline sketch a ```text fence with box-drawing characters is still
fine, capped at 76 columns (the PDF overflows past 83).

Rebuild the SVG after editing a source; both the source and the SVG are
committed, so CI never needs the diagram toolchain.

### Pre-commit Hooks

The repository uses pre-commit hooks for code quality:

```bash
# Install hooks
pre-commit install

# Run manually on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run
```

**Pre-commit hooks include:**

- Markdown linting (markdownlint with custom config in `.markdownlint.yaml`)
- Python formatting (black, ruff)
- Line ending fixes (CRLF → LF, remove tabs)
- Trailing whitespace removal
- Smart quotes and ligature fixes

### Module Management

```bash
# Create a new module (interactive prompt)
cd utils
./add_module.sh
# Creates: lectures/, assignments/, resources/images/, introduction.md

# Regenerate table of contents
cd utils
./generate_summary.sh
# Updates: Curriculum/SUMMARY.md
```

### Converting Markdown to Typst

```bash
# Convert Marp-style markdown to Typst slides (experimental)
cd utils
python convert.py path/to/markdown.md
# Outputs: slides.typ
```

**Note:** This conversion is semi-automated and requires manual cleanup, especially for images.

## Architecture and Design

### Module Structure

Each module follows a consistent pattern:

- `introduction.md` - Required module overview
- `lectures/` - Numbered markdown files with lecture content
- `assignments/` - Student exercises and projects
- `slides/` - Typst presentation files (optional)
- `figures/` or `resources/images/` - Visual assets

### Typst Slide System

Slides use the EmberZero theme from the `typst-theme-emberzero` submodule:

```typst
#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module Title],
    subtitle: [Subtitle],
    authors: [*Author Name*],
    footer: [Footer Text],
  ),
)

#title-slide()
#slide(title: "Title")[Content]
#section-slide(title: "Section")
```

All slide files **must** import the theme by relative path (three directories up from any module's slides folder). Besides the slide functions above, the theme provides `#split`, `#cblock` and `#icon`.

### Git Submodules

The repository uses submodules for fonts and the Typst template:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/emberzero/project-athena.git

# Update submodules
git submodule update --init --recursive

# Pull submodule updates
git submodule update --remote
```

**Important:** Both submodules use SSH URLs (`git@github.com:`). Ensure SSH keys are configured.

### CI/CD Pipeline

GitHub Actions automatically compiles slides on push to `main`:

- **Trigger paths:** `Curriculum/**/slides/**`, workflow file, submodules
- **Runner:** macOS (for font support)
- **Output:** All PDFs published to GitHub Release tagged `latest-slides`
- **Build tool:** Nix flake with Typst compiler

## Development Guidelines

### Markdown Conventions

- **Line length:** Body text max 9999 chars, headings/code max 119 chars
- **List indentation:** 2 spaces (configured in `.markdownlint.yaml`)
- **Allowed HTML:** Only `<br>` and `<img>` tags
- **Headings:** Duplicates allowed under different parents only

### File Naming

- Modules: `Module XX - Topic Name/` (zero-padded numbers)
- Lectures: `lecture_N_descriptive_name.md`
- Slides: `Module_XX_Slides_Topic.typ`

### Content Organization

- Each module's `introduction.md` is the entry point
- Lectures are numbered sequentially within each module
- `SUMMARY.md` is auto-generated - **do not edit manually**
- All slides must compile with `--root .` flag pointing to repo root

## Nix Development Environment

Enter a development shell with Typst and dependencies:

```bash
nix develop

# Environment includes:
# - typst (compiler)
# - tinymist (LSP server)
# - typst-live (live preview)
# - Custom fonts (Fira + Athena fonts)
```

The `TYPST_FONT_PATHS` environment variable is automatically configured.

## License

- Curriculum content: CC-BY-4.0 (see LICENSE)
- Hands-on examples: Licensed by respective authors (see individual folders)
