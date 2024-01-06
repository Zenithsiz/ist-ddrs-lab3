#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[The following figure 1, from the guide, represents our network.]

#figure(
	image("/images/1-diagram.png", width: 50%),
	caption: [Network diagram]
)

#indent_par[In order to optimize the maximum link load, we've used the `lpSolve` package from `R`.]

#indent_par[First, we determine all possible routes through the network for all flows, represented in table 1:]

#figure(
	pad(1em, table(
		columns: (auto),
		align: left,

		[Route],
		[$1 -> 2 -> 4$],
		[$1 -> 2 -> 3 -> 4$],
		[$1 -> 3 -> 4$],
		[$2 -> 4$],
		[$2 -> 3 -> 4$],
		[$2 -> 3$],
		[$1 -> 3$],
		[$1 -> 2 -> 3$],
	)),
	kind: table,
	caption: [Routes for all flows]
)

#indent_par[Afterwards, we can define our variables, assigning a variable $x_(n_1 n_2 ... n_r)$ to represent the usage of the link as a ratio between 0.0 and 1.0, as well as a variable $r$, representing the maximum link load. This allows us to represent the problem's equations in the following table 2:]

#figure(
	pad(1em, table(
		columns: (auto, 1fr),
		align: left + horizon,

		[Description], [Equation],
		[Link $1 -> 2$], [$b_14 x_124  + b_14 x_1234 + b_13 x_123             <= c dot r$],
		[Link $1 -> 3$], [$b_14 x_134  + b_13 x_13                            <= c dot r$],
		[Link $2 -> 3$], [$b_14 x_1234 + b_23 x_234  + b_23 x_23 + b_13 x_123 <= c dot r$],
		[Link $2 -> 4$], [$b_14 x_124  + b_24 x_24                            <= c dot r$],
		[Link $3 -> 4$], [$b_14 x_1234 + b_14 x_134  + b_23 x_234             <= c dot r$],
		[Flow 1], [$x_124 + x_1234 + x_134 = 1$],
		[Flow 2], [$x_24 + x_234 = 1$],
		[Flow 3], [$x_23 = 1$],
		[Flow 4], [$x_13 + x_123 = 1$],
	)),
	kind: table,
	caption: [Problem equations]
)

#indent_par[Where $c = 10 "Mb" "s"^(-1)$ is the link capacity and $b_"xy"$ is the flow from $x$ to $y$.]

#indent_par[In addition, our overall objective is to minimize $r$.]

#indent_par[For both of the following cases, the code we have used is presented in the appendix.]

==== a. Bifurcated routing

#indent_par[In order to determine the optimal routing using bifurcated routing, we allow the $x_(n_1 n_2 ... n_r)$ variables to be real numbers, thus flows to use multiple routes simultaneously.]

#indent_par[This results in the following solution in table 3:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: center,

		[Variable], [ Value ],
		[$x_124$], [0.33],
		[$x_1234$], [0.00],
		[$x_134$], [0.67],
		[$x_24$], [1.00],
		[$x_234$], [0.00],
		[$x_23$], [1.00],
		[$x_13$], [1.00],
		[$x_123$], [0.00],
		[$r$], [0.45],
	)),
	kind: table,
	caption: [Solution with bifurcation]
)

#indent_par[We reach a minimum value of 0.45 for the maximum link load, with the flow $1 -> 4$ having a bifurcation path between $1 -> 2 -> 4$ and $1 -> 3 -> 4$. All other paths do not have any bifurcations.]

#pagebreak()

==== b. Non-bifurcated routing

#indent_par[In order to determine the optimal routing using non-bifurcated routing, we restrict the $x_(n_1 n_2 ... n_r)$ variables to be binary numbers, either 0.0 or 1.0, thus ensuring that each flow only uses a single route at each node.]

#indent_par[This results in the following solution in table 4:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: left,

		[Variable], [ Value ],
		[$x_124$], [0],
		[$x_1234$], [0],
		[$x_134$], [1],
		[$x_24$], [1],
		[$x_234$], [0],
		[$x_23$], [1],
		[$x_13$], [1],
		[$x_123$], [0],
		[$r$], [0.6],
	)),
	kind: table,
	caption: [Solution without bifurcation]
)

#indent_par[We reach a minimum value of 0.6 for the maximum link load, with all routes being either 0.0 or 1.0, thus ensuring no bifurcation occurs. The only difference to the bifurcated approach is with the flow $1 -> 4$ that now exclusively uses $1 -> 3 -> 4$.]

#pagebreak()
