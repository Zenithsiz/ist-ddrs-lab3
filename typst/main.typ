#import "/typst/util.typ" as util

#set document(
  author: util.authors,
  title: util.title,
  date: none
)
#set page(
  header: locate(loc => if loc.page() > 1 {
    image("/images/tecnico-logo.png", height: 30pt)
  }),
  footer: locate(loc => if loc.page() > 1 {
    align(center, counter(page).display())
  }),
)
#set text(
  font: "Linux Libertine",
  lang: "en",
)
#set par(
  justify: true,
)
#set math.equation(
  numbering: "(1)",
)
#set math.mat(
  delim: "[",

)
#show figure: set block(breakable: true)
#show link: underline

#include "cover.typ"
#pagebreak()

#hide[= Table of contents]

#outline(title: "Table of contents", indent: 1em)
#pagebreak()

#hide[= Figures]

#outline(title: "Figures", target: figure)
#pagebreak()

= Exercises

== A. Optimization techniques and telecommunications problems

=== 1. Exercise 1
#include "exercises/1.typ"

=== 2. Exercise 2
#include "exercises/2.typ"

=== 3. Exercise 3
#include "exercises/3.typ"

== B. Heuristic methods

=== 4. Exercise 4
#include "exercises/4.typ"

== C. Replica placement

=== 5. Exercise 5
#include "exercises/5.typ"

=== 6. Exercise 6
#include "exercises/6.typ"

#pagebreak()

= Appendix

=== 1. Exercise 1
#include "appendixes/1.typ"

=== 2. Exercise 2
#include "appendixes/2.typ"

=== 3. Exercise 3
#include "appendixes/3.typ"

=== 4. Exercise 4
#include "appendixes/4.typ"

=== 5. Exercise 5
#include "appendixes/5.typ"

=== 6. Exercise 6
#include "appendixes/6.typ"
