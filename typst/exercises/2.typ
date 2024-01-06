#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[In order to optimize the maximum link load, we've used the `lpSolve` package from `R`.]

#indent_par[Since we're using the same network and flows as in exercise 1, the routes specified in table 1 stay the same as well]

#indent_par[We define additional variables to determine the number of circuits for each link, named $y_"ab"$. We also remove the variable $r$, since our objective is now to minimize the overall cost, which only depends on the $y_"ab"$ variables and other constants.]

#indent_par[The following are our updated equations.]

#figure(
	pad(1em, table(
		columns: (auto, 1fr),
		align: left + horizon,

		[Description], [Equation],
		[Link 1 -> 2], [$b_14 x_124  + b_14 x_1234 + b_13 x_123            - c_"mul" * y_12 <= 0$],
		[Link 1 -> 3], [$b_14 x_134  + b_13 x_13                           - c_"mul" * y_13 <= 0$],
		[Link 2 -> 3], [$b_14 x_1234 + b_23 x_234 + b_23 x_23 + b_13 x_123 - c_"mul" * y_23 <= 0$],
		[Link 2 -> 4], [$b_14 x_124  + b_24 x_24                           - c_"mul" * y_24 <= 0$],
		[Link 3 -> 4], [$b_14 x_1234 + b_14 x_134 + b_23 x_234             - c_"mul" * y_34 <= 0$],
		[Link 1 -> 2], [$c_"mul" dot y_12 <= c_"total"$],
		[Link 1 -> 3], [$c_"mul" dot y_13 <= c_"total"$],
		[Link 2 -> 3], [$c_"mul" dot y_23 <= c_"total"$],
		[Link 2 -> 4], [$c_"mul" dot y_24 <= c_"total"$],
		[Link 3 -> 4], [$c_"mul" dot y_34 <= c_"total"$],
		[Flow 1], [$x_124 + x_1234 + x_134 = 1$],
		[Flow 2], [$x_24 + x_234 = 1$],
		[Flow 3], [$x_23 = 1$],
		[Flow 4], [$x_13 + x_123 = 1$]
	)),
	kind: table,
	caption: [Problem equations]
)

#indent_par[Where $c_"max" = 10 "Mb" "s"^(-1)$ is the link capacity, $c_"mul" = 2 "Mb" "s"^(-1)$ is the cost of each module, and $b_"xy"$ is the flow from $x$ to $y$.]

#indent_par[And finally, our overall objective is to minimize $"price" dot (y_12 + y_13 + y_23 + y_24 + y_34)$, where $"price"$ is the price for each module.]

#indent_par[For both of the following cases, the code we have used is presented in the appendix.]

#pagebreak()

==== a. Bifurcated routing

#indent_par[Similarly to the previous exercise, for bifurcated flow, we allow $x_(n_1 n_2 ... n_r)$ to be real numbers, but we must restrict $y_"ab"$ to a positive integer, because we can only have an integer amount of modules.]

#indent_par[This results in the following solution in table 5:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: left,

		[Variable], [ Value ],
		[$x_124$], [0.44],
		[$x_1234$], [0.00],
		[$x_134$], [0.56],
		[$x_24$], [0.40],
		[$x_234$], [0.60],
		[$x_23$], [1.00],
		[$x_13$], [1.00],
		[$x_123$], [0.00],
		[$y_12$], [1],
		[$y_13$], [2],
		[$y_23$], [3],
		[$y_24$], [2],
		[$y_34$], [2],
	)),
	kind: table,
	caption: [Solution with bifurcation]
)

#indent_par[We reach a network cost of 10000€.]

#pagebreak()

==== b. Non-bifurcated routing

#indent_par[Similar to the previous exercise, for non-bifurcated flow, we restrict $x_(n_1 n_2 ... n_r)$ to be binary variables. However, the restrictions on $y_"ab"$ stay the same (they must be positive integers)]

#indent_par[This results in the following solution in table 7:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: left,

		[Variable], [ Value ],
		[$x_124$], [1],
		[$x_1234$], [0],
		[$x_134$], [0],
		[$x_24$], [1],
		[$x_234$], [0],
		[$x_23$], [1],
		[$x_13$], [0],
		[$x_123$], [1],
		[$y_12$], [3],
		[$y_13$], [0],
		[$y_23$], [3],
		[$y_24$], [4],
		[$y_34$], [0],
	)),
	kind: table,
	caption: [Solution without bifurcation]
)

#indent_par[We also reach a network cost of 10000€.]
