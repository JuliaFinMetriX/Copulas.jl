module TestGraphviz

using Copulas
using Base.Test

tr = Copulas.CTreeParRef([0, 1, 2, 2])

expGraphvizString = """
digraph {
1 -> 2;
2 -> 3;
2 -> 4;
}"""

@test expGraphvizString == Copulas.toGviz(tr)

Copulas.viz(tr)

Copulas.render(tr)
## Copulas.render(tr, "png", "/home/chris/treePic")


end
