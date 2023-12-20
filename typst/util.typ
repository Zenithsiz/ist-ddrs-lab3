#let title = "Lab report 3 - TODO"
#let degree = "Master's Programme in Communication Networks Engineering"
#let course = "Performance Evaluation and Dimensioning of Networks and Systems"

#let authors = (
  "Filipe Rodrigues - 96735",
  "Ricardo Rodrigues - 96764",
)
#let group = "Group 2"

/// Displays a figure of code
#let code_figure(body, ..rest) = {
  figure(
    body,
    kind: "code",
    supplement: "Code",
    ..rest,
  )
}

/// Indented paragraph
#let indent_par(body, indent: 1em) = {
  h(indent)
  body
}
