#let template(
  title: "",
  authors: (),
  resumo: [],
  palchaves: [],
  topicos-pt: none,
  abstract-en: [],
  keywords-en: [],
  topicos-en: none,
  doc,
) = {
  // layout
  set page(
    paper: "a4",
    margin: (left: 29mm, right: 29mm, top: 40.4mm, bottom: 25mm),
    header: {
      align(center, image("images/sbpo2026-header-logo.png", width: 41.3mm))
      line(length: 100%, stroke: 0.4pt)
    },
    header-ascent: 5.08mm,
    numbering: none,
  )

  // tipografia
  set text(font: "Times New Roman", size: 11pt, lang: "pt")
  set par(
    first-line-indent: 1.5cm,
    leading: 0.55em,
    spacing: 0.55em,
    justify: true,
  )

  // seções#set text(font: "Libertinus Serif")

  set heading(numbering: "1.")
  show heading: it => {
    set par(first-line-indent: 0pt)
    v(1em, weak: true)
    context text(weight: "bold", size: 11pt)[#if it.numbering != none {
        numbering(it.numbering, ..counter(heading).at(it.location()))
        h(0.5em)
      }#it.body]
    v(0.65em, weak: true)
  }

  // bibliografia
  show bibliography: it => {
    pagebreak()
    {
      set par(spacing: 1em)
      it
    }
  }

  // legendas
  show figure.caption: set text(size: 9pt)
  set figure.caption(position: bottom)

  // título
  align(center, text(size: 13pt, weight: "bold")[#upper(title)])

  // autores
  for author in authors {
    v(11pt)
    align(center)[
      *#author.name*\
      #author.institute\
      #author.address\
      #raw(author.email)
    ]
  }

  v(8mm)

  // resumo
  align(center, text(size: 11pt, weight: "bold")[RESUMO])
  resumo

  v(0.5em)
  {
    set par(first-line-indent: 0pt)
    [*PALAVRAS CHAVE.* *#palchaves*]
    if topicos-pt != none {
      v(0.5em)
      strong[#topicos-pt]
    }
  }

  v(8mm)

  // abstract
  align(center, text(size: 11pt, weight: "bold")[ABSTRACT])
  abstract-en

  v(0.5em)
  {
    set par(first-line-indent: 0pt)
    [*KEYWORDS.* *#keywords-en*]
    if topicos-en != none {
      v(0.5em)
      strong[#topicos-en]
    }
  }

  pagebreak()

  // texto
  doc
}
