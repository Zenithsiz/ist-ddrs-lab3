#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[The following figure 2, from the guide, represents our network.]

#figure(
	image("/images/4-diagram.png", width: 70%),
	caption: [Network diagram]
)

==== a.

#indent_par[Using the provided script `lsrouteA.R`, we obtained the following results for a kilometric solution in table 10:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: center,

		[Maximum link load], [Average packet delay ($"ms"$)],
		[0.999000], [2.055],
	)),
	kind: table,
	caption: [Solution]
)

==== b.

#indent_par[To develop the `GreedyRandomized` function, we used the following approach:]

- Find all possible flows and shuffle them
- For each flow, find the shortest path, taking into account the previously installed flows.

#indent_par[In detail, we store a matrix `λ` with the installed traffic through each node, so we may compute the link delays using it. We update this matrix using delays calculated from `Tr` matrix and the speed of light.]

#indent_par[This function is present in the appendix.]

#indent_par[After running the provided script `lsrouteB.R`, we obtained the following results for a kilometric solution in table 11:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: center,

		[Maximum link load], [Average packet delay ($"ms"$)],
		[0.864000], [1.207],
	)),
	kind: table,
	caption: [Solution]
)

#indent_par[The solution found via this method is substantially better than in the previous exercise, by both the maximum link load, which is lower, and the average packet delay.]

#pagebreak()

==== c.

#indent_par[Using the solution from the previous exercise, we computed the rates matrix and used it to determine where we needed to add more capacity.]

#indent_par[In detail, we normalize the matrix to the $[0.0, 1.0]$ interval and added it to the `Mu` matrix using `Mu = (1 + extra_capacity) * 1e9 / 8e3`. This makes it so that, as specified, we don't remove any capacity and only add it where necessary. However, this lead to a maximum link load of higher than 70%. To fix this, we multiplied the original by the lowest factor that would yield a < 70% maximum link load.]

#indent_par[The code used for this, which includes the extra capacity, is present in the appendix.]

#indent_par[After running our solution, we obtained the following solution in table 12:]

#figure(
	pad(1em, table(
		columns: (auto, auto),
		align: center,

		[Maximum link load], [Average packet delay ($"ms"$)],
		[0.699999], [1.163],
	)),
	kind: table,
	caption: [Solution]
)
