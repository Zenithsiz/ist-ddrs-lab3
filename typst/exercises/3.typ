#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[We've resorted to the node-link routing formulation to determine the shortest path.]

#indent_par[Since we're using the same network and flows as in exercise 1, the routes specified in table 1 stay the same as well.]

#indent_par[Similarly to the previous 2 exercise, we define the variables $x_"ab"$, where $a -> b$ is a link, as the ratio of traffic passing through that link.]

#indent_par[The following are our equations in table 8.]

#figure(
	pad(1em, table(
		columns: (auto, 1fr),
		align: left + horizon,

		[Description], [Equation],
		[Node 1], [$x_12 + x_13 = 1$],
		[Node 2], [$x_12 - x_24 - x_23 = 0$],
		[Node 3], [$x_13 + x_23 - x_34 = 0$],
		[Node 4], [$-x_24 - x_34 = -1$],
	)),
	kind: table,
	caption: [Problem equations]
)

#indent_par[Our objective function is the following in equation 1:]

$ sum_i c_"ab" dot x_"ab" $

#indent_par[Where $c_"ab"$ is the cost of the $a -> b$ link.]

#indent_par[The code we have used to calculate this is presented in the appendix in code 3.]

#indent_par[We achieve the following results in table 9:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: left,

		[Variable], [ Value ],
		[$x_12$], [1],
		[$x_13$], [0],
		[$x_23$], [1],
		[$x_24$], [0],
		[$x_34$], [1],
	)),
	kind: table,
	caption: [Solution]
)

#indent_par[The total cost ends up at 3. We conclude that the best solution is the route $1 -> 2 -> 3 -> 4$, with a cost of 3.]

#pagebreak()
