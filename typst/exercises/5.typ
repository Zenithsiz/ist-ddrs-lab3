#import "/typst/util.typ" as util: indent_par, code_figure


#indent_par[In order to optimize the server locations, we've used the `lpSolve` package from `R`.]

#indent_par[First, we declared the following variables:]

- Number of servers, $z_i$, in node $i$.
- Replica, $g_i^j$, has node $i$ be served by node $j$


#indent_par[Afterwards, we can construct the following equations:]

#figure(
	pad(1em, table(
		columns: (auto, 1fr),
		align: left + horizon,

		[Description], [Equation],
		[Have at most `numServers` replicas], [$sum_i z_i = "numServers"$],
		[For each node, it must be served by exactly 1 replica], [$forall_i sum_j g_i^j == 1$],
		[If a node isn't a replica, no other node can be served by it.], [$forall_(i,j) g_i^j <= z_j$],
	)),
	kind: table,
	caption: [Problem equations]
)

#indent_par[Our objective function is the following in equation 2:]

$ sum_i,j g_i^j dot C_i^j $

#indent_par[Where $C_i^j$ is the delay between nodes $i$ and $j$.]

#indent_par[The code used to implement this is present in the appendix.]

#pagebreak()

#indent_par[After running our code for several different number of servers, we obtained the following results in table 14:]

#figure(
	pad(1em, table(
		columns: (auto, auto, auto),
		align: left + horizon,

		[Servers], [Replica servers], [Cost],
		[1], [8], [3862.00],
		[2], [5, 15], [2412.00],
		[3], [5, 12, 13], [1832.00],
		[4], [3, 5, 10, 13], [1521.00],
		[5], [3, 5, 11, 12, 15], [1269.00],
	)),
	kind: table,
	caption: [Problem equations]
)

#indent_par[From this we can conclude that more replicas leads to a lower overall cost.]
