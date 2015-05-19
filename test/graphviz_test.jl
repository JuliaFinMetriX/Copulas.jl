module TestGraphviz

using Copulas
using Base.Test
using JFinM_Charts

############################
## graphviz general tests ##
############################

## get data
tr = Copulas.CTreeParRef([0, 1, 2, 2])

fname = tempname()
Copulas.render(tr, Copulas.CTreeChart(), "png", fname)

## default charts
##---------------

tr = Copulas.CTreeParRef([0, 1, 2, 2])
Copulas.render(tr)

tr2 = convert(Copulas.CTreePaths, tr)
Copulas.render(tr2)

vn = Copulas.testvine(2)
Copulas.render(vn)

################
## CTreeChart ##
################

## get data
tr = Copulas.CTreeParRef([0, 1, 2, 2])

## default chart
gviz = Copulas.GViz(tr, Copulas.CTreeChart())
Copulas.render(gviz)

@test_throws Exception gviz = Copulas.GViz(tr,
                                           JFinM_Charts.chart(Copulas.CTreeChart,
                                                              emph1 = [2, 4],
                                                              emph2 = [2, 5]))

## visualize directly
gviz = Copulas.render(tr, JFinM_Charts.chart(Copulas.CTreeChart))

## two emphasized sets
gviz = Copulas.GViz(tr, JFinM_Charts.chart(Copulas.CTreeChart,
                                           emph1 = [1, 3],
                                           emph2 = [2, 4],
                                           emphFillColor2 = "red"
                                           ))
Copulas.render(gviz)

## visualize CTreePaths instance
tr2 = convert(Copulas.CTreePaths, tr)
gviz = Copulas.GViz(tr2, JFinM_Charts.chart(Copulas.CTreeChart))
Copulas.viz(gviz)

## render data directly
Copulas.render(tr)

## visualize with chart options
gviz = Copulas.render(tr,
                   JFinM_Charts.chart(Copulas.CTreeChart,
                                      emph1 = [2],
                                      emphFillColor1 = "orange",
                                      emphShape1 = "ellipse"))


## visualize gviz object
##----------------------

## first create gviz object
gviz = Copulas.GViz(tr, JFinM_Charts.chart(Copulas.CTreeChart))
# Copulas.viz(gviz)
Copulas.render(gviz)

####################
## VineTreesChart ##
####################

vn = Copulas.testvine(3)

gviz = Copulas.GViz(vn, JFinM_Charts.chart(Copulas.VineTreesChart,
                                   emph1 = [1, 3]))
Copulas.render(gviz)

## default chart
Copulas.render(vn)

## with emphasized variables
gviz = Copulas.GViz(vn, JFinM_Charts.chart(Copulas.VineTreesChart,
                                           emph1 = [1, 3],
                                           emph2 = [4],
                                           emphFillColor2 = "red",
                                           rootEmph = [2],
                                           rootEmphFillColor1 = "orange"
                                           ))

Copulas.render(gviz)

####################
## VineGraphChart ##
####################

vn = Copulas.testvine(3)
gviz = Copulas.GViz(vn, JFinM_Charts.chart(Copulas.VineGraphChart))
Copulas.render(gviz)

chrt = JFinM_Charts.chart(Copulas.VineGraphChart,
                          maxLayer=3,
                          styles=["bold", "filled", "dotted"],
                          colors=["red", "black", "black"],
                          lens=["1.0", "3.0", "5.0"],
                          weights=["1", "1", "1"])


Copulas.render(Copulas.GViz(vn, chrt))


chrt = JFinM_Charts.chart(Copulas.VineGraphChart,
                          maxLayer=2,
                          styles=["bold", "dotted"],
                          colors=["black", "black"],
                          lens=["1.0", "1.8"],
                          weights=["1", "0"])
Copulas.render(vn, chrt)

vn = Copulas.testvine(2)
Copulas.render(vn, Copulas.VineGraphChart())


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
