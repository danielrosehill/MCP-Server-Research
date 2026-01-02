// Typst template for MCP Server Research PDFs

// Define horizontalrule for pandoc compatibility
#let horizontalrule = {
  v(0.5em)
  line(length: 100%, stroke: 0.5pt + luma(180))
  v(0.5em)
}

// Brand colors
#let space-indigo = rgb("#2B304D")
#let coral-glow = rgb("#F58258")
#let rosewood = rgb("#AA697D")
#let dusty-grape = rgb("#5F4FA2")

// Get today's date
#let today = datetime.today()
#let date-str = today.display("[day]/[month]/[year repr:last_two]")

#let report(
  title: "",
  ai-models: "Multiple AI Models",
  run-id: "001",
  content
) = {
  // Document settings
  set document(title: title, author: "Daniel Rosehill")

  set page(
    paper: "a4",
    flipped: true,
    margin: (top: 1.5cm, bottom: 2.2cm, left: 1.5cm, right: 1.5cm),
    footer: context {
      set text(size: 7.5pt, fill: luma(80))
      line(length: 100%, stroke: 0.3pt + luma(200))
      v(4pt)
      grid(
        columns: (1fr, 1fr, 1fr),
        align: (left, center, right),
        [Document: Daniel Rosehill | License: MIT],
        [Page #counter(page).display("1 of 1", both: true)],
        [#date-str | Run: #run-id | AI: #ai-models]
      )
    }
  )

  // Text settings
  set text(
    font: "IBM Plex Sans",
    size: 10pt,
    fill: black,
  )

  // Heading styles
  set heading(numbering: none)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    set text(size: 18pt, weight: "bold", fill: space-indigo)
    block(above: 1.5em, below: 1em)[#it.body]
  }

  show heading.where(level: 2): it => {
    set text(size: 14pt, weight: "bold", fill: dusty-grape)
    block(above: 1.2em, below: 0.8em)[#it.body]
  }

  show heading.where(level: 3): it => {
    set text(size: 12pt, weight: "bold", fill: rosewood)
    block(above: 1em, below: 0.6em)[#it.body]
  }

  show heading.where(level: 4): it => {
    set text(size: 10pt, weight: "bold", fill: coral-glow)
    block(above: 0.8em, below: 0.5em)[#it.body]
  }

  // Link styling
  show link: it => {
    set text(fill: dusty-grape, size: 0.9em)
    underline(it)
  }

  // Code block styling
  show raw.where(block: true): it => {
    set text(size: 8pt)
    block(
      fill: luma(245),
      inset: 8pt,
      radius: 4pt,
      width: 100%,
      it
    )
  }

  // Inline code styling
  show raw.where(block: false): it => {
    box(
      fill: luma(240),
      inset: (x: 2pt, y: 0pt),
      outset: (y: 2pt),
      radius: 2pt,
      text(size: 0.9em, it)
    )
  }

  // Improved table styling for wide tables (landscape)
  show table: it => {
    set text(size: 8pt, hyphenate: true)
    set par(justify: false, leading: 0.5em)
    block(
      width: 100%,
      breakable: true,
      it
    )
  }

  set table(
    fill: (_, y) => if y == 0 { space-indigo.lighten(85%) } else if calc.odd(y) { luma(252) },
    stroke: 0.4pt + luma(200),
    inset: 5pt,
    align: left,
  )

  show table.cell.where(y: 0): it => {
    set text(weight: "bold", size: 7.5pt, fill: space-indigo)
    it
  }

  // Paragraph settings
  set par(justify: true, leading: 0.65em)

  // List styling
  set list(marker: text(fill: coral-glow)[•], spacing: 0.6em)
  set enum(numbering: n => text(fill: dusty-grape)[#n.], spacing: 0.6em)

  // Title block
  if title != "" {
    align(center)[
      #block(
        fill: space-indigo,
        inset: 16pt,
        radius: 4pt,
        width: 100%,
      )[
        #text(size: 20pt, weight: "bold", fill: white)[#title]
      ]
    ]
    v(0.5em)
    align(center)[
      #text(size: 9pt, fill: luma(100))[
        Research conducted using: #ai-models | Run ID: #run-id | Date: #date-str
      ]
    ]
    v(1.5em)

    // Table of Contents
    text(size: 14pt, weight: "bold", fill: dusty-grape)[Table of Contents]
    v(0.5em)
    outline(
      title: none,
      indent: 1.5em,
      depth: 2,
    )
    pagebreak()
  }

  content
}
