module TestGraphviz

using Copulas
using Base.Test
using JFinM_Charts

################
## CTreeChart ##
################

## get data
tr = Copulas.CTreeParRef([0, 1, 2, 2])

## visualize directly
gviz = Copulas.viz(tr, JFinM_Charts.chart(Copulas.CTreeChart))

## visualize with chart options
gviz = Copulas.viz(tr,
                   JFinM_Charts.chart(Copulas.CTreeChart,
                                      emph1 = [2],
                                      emphFillColor1 = "orange",
                                      emphShape1 = "ellipse"))

## render to default tmp file
Copulas.render(gviz)

## visualize gviz object
##----------------------

## first create gviz object
gviz = Copulas.GViz(tr, JFinM_Charts.chart(Copulas.CTreeChart))
Copulas.viz(gviz)
Copulas.render(gviz)

####################
## VineTreesChart ##
####################

vn = Copulas.testvine(3)

Copulas.viz(vn, JFinM_Charts.chart(Copulas.VineTreesChart,
                                   emph1 = [1, 3]))

## Copulas.viz(tr)

## expGraphvizString = """
## digraph {
## node [shape=circle];
## edge [arrowhead=none];
## 1 -> 2 ;
## 2 -> 3 ;
## 2 -> 4 ;
## }"""

## @test expGraphvizString == Copulas.toConsole(tr)

## tr = Copulas.CTreePaths(6, [4,2], [5,3,1], [5,7], [5,8], [5,9],
##                         [5,10], [11], [12], [13], [14])
   
## Copulas.viz(tr)

## Copulas.render(tr)
## ## Copulas.render(tr, "png", "/home/chris/treePic")


end
