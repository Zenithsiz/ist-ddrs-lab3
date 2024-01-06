#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[We've developed a script to plot the net revenue against the number of circuits, displaying it in the following figure 3:]

#figure(
	image("/output/6.svg", width: 80%),
	caption: [Network diagram]
)

#indent_par[From this, we can see that 12 is the optimal number of circuits to maximize the net revenue.]

#indent_par[However, the blocking percentage for 12 circuits is `blocking_prob(ρ, 12) = 0.1197392 = 11.97%`. From a business perspective, this is not good, since a user having 12% of their traffic blocked would lead to them seeking the competition instead. We could increase the number of circuits to, for example, 20, which is still positive on net revenue, but has a blocking percentage of `0.186905%`, which is much more acceptable, although not quite up-to-par with today's standards of 5 9s (0.001%) and upwards.]
