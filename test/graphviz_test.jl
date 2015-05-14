module TestGraphviz

using Copulas
using Base.Test

tr = Copulas.CTreeParRef([0, 1, 2, 2])
Copulas.viz(tr)

expGraphvizString = """
digraph {
node [shape=circle];
edge [arrowhead=none];
1 -> 2 ;
2 -> 3 ;
2 -> 4 ;
}"""

@test expGraphvizString == Copulas.toConsole(tr)

tr = Copulas.CTreePaths(6, [4,2], [5,3,1], [5,7], [5,8], [5,9],
                        [5,10], [11], [12], [13], [14])
   
Copulas.viz(tr)

Copulas.render(tr)
## Copulas.render(tr, "png", "/home/chris/treePic")


end
