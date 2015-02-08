module TestVine

using Copulas
using Base.Test

## equSets
##--------

@test Copulas.equSets([1, 2, 3, 4], [2, 1, 4, 3])
@test Copulas.equSets([1, 2, 2], [2, 1])

## pairMatch
##----------

## does match exist between two trees?

tr1 = Copulas.Tree(3, [1, 2], [4, 5, 6])
tr2 = Copulas.Tree(7, [2, 1], [4], [5, 6])
@test Copulas.pairMatch(tr1, tr2, 3) == [1 1]

tr2 = Copulas.Tree(7, [1], [1, 2], [5, 6])
@test Copulas.pairMatch(tr1, tr2, 3) == [1 2]

tr1 = Copulas.Tree(3, [1, 2], [4, 5])
tr2 = Copulas.Tree(7, [1], [1, 2], [5, 4])
@test Copulas.pairMatch(tr1, tr2, 3) == [1 2; 2 3]

tr1 = Copulas.Tree(3, [1, 2])
tr2 = Copulas.Tree(7, [3, 4])
@test isempty(Copulas.pairMatch(tr1, tr2, 3))

## findPairMatch
##--------------

## for array of trees, where do matches exist?
## also: incomplTrees tests

trs = [Copulas.Tree(1, [2], [3]),
       Copulas.Tree(2, [1, 3]),
       Copulas.Tree(3, [1, 2])
       ]

@test isempty(Copulas.incomplTrees(trs))

trs = [Copulas.Tree(1, [3]);
       Copulas.Tree(2, [3], [5]);
       Copulas.Tree(3, [1], [2]);
       Copulas.Tree(4, [5], [6]);
       Copulas.Tree(5, [2], [4]);
       Copulas.Tree(6, [4])]

@test Copulas.incomplTrees(trs) == [1, 2, 3, 4, 5, 6]

expMatches = [Copulas.CondEdge(1, 2, [3], [3]),
              Copulas.CondEdge(2, 4, [5], [5]),
              Copulas.CondEdge(3, 5, [2], [2]),
              Copulas.CondEdge(5, 6, [4], [4])]

@test expMatches == Copulas.findPairMatch(trs, 2, Copulas.incomplTrees(trs))

## vertexTable
##------------

expVTable = Array{Int, 1}[[1],
                          [1, 2],
                          [3],
                          [2],
                          [3, 4],
                          [4]]
@test expVTable == Copulas.vertexTable(expMatches, 6)


## findPairMatch
##--------------

## given first dvine layer
trs = [Copulas.Tree(1, [2]),
       Copulas.Tree(2, [1], [3]),
       Copulas.Tree(3, [2], [4]),
       Copulas.Tree(4, [3])]

expMatches = [Copulas.CondEdge(1, 3, [2], [2]),
              Copulas.CondEdge(2, 4, [3], [3])]

foundPairs = Copulas.findPairMatch(trs, 2, Copulas.incomplTrees(trs))
@test expMatches == foundPairs

## reachedVertices
##----------------

@test [1, 2, 3, 4] == Copulas.reachedVertices(foundPairs)

edges = [Copulas.CondEdge(1, 3, [2], [2]),
         Copulas.CondEdge(1, 4, [3], [3])]

@test [1, 3, 4] == Copulas.reachedVertices(edges)

## mandatoryEdges
##---------------

edges = [Copulas.CondEdge(1, 3, [2], [2]),
         Copulas.CondEdge(2, 4, [3], [3])]
verticesToBeLinked = [1, 2, 3, 4]

expChosen = Bool[1, 1]
actChosen = Copulas.mandatoryEdges(edges, verticesToBeLinked, 4)[1]
@test expChosen == actChosen

expRemainLinks = []
actRemainLinks = Copulas.mandatoryEdges(edges, verticesToBeLinked, 4)[2]
@test expRemainLinks == actRemainLinks


edges = [Copulas.CondEdge(1, 3, [2], [2]),
         Copulas.CondEdge(2, 3, [4], [4]),
         Copulas.CondEdge(2, 4, [3], [3]),
         Copulas.CondEdge(3, 4, [2], [2])]
verticesToBeLinked = [1, 2, 3, 4]

expChosen = Bool[1, 0, 0, 0]
actChosen = Copulas.mandatoryEdges(edges, verticesToBeLinked, 4)[1]
@test expChosen == actChosen

expRemainLinks = [2, 4]
actRemainLinks = Copulas.mandatoryEdges(edges, verticesToBeLinked, 4)[2]
@test expRemainLinks == actRemainLinks


## selectLinks
##------------

## second layer d-Vine
trs = [Copulas.Tree(1, [2]),
       Copulas.Tree(2, [1], [3]),
       Copulas.Tree(3, [2], [4]),
       Copulas.Tree(4, [3])]

actLinks = Copulas.selectLinks(trs, 2)
expLinks = [Copulas.CondEdge(1, 3, [2], [2]),
            Copulas.CondEdge(2, 4, [3], [3])]
@test actLinks == expLinks

## third layer d-Vine
##-------------------

trs = [Copulas.Tree(1, [2, 3]),
       Copulas.Tree(2, [1], [3, 4]),
       Copulas.Tree(3, [2, 1], [4]),
       Copulas.Tree(4, [3, 2])]

actLinks = Copulas.selectLinks(trs, 3)
expLinks = [Copulas.CondEdge(1, 4, [2, 3], [3, 2])]
@test actLinks == expLinks

## test DVine construction
##------------------------

## expected result
dVn4 = Copulas.Vine([0 2 2 2;
                   1 0 3 3;
                   2 2 0 4;
                   3 3 3 0])

## given first dvine layer
trs = [Copulas.Tree(1, [2]),
       Copulas.Tree(2, [1], [3]),
       Copulas.Tree(3, [2], [4]),
       Copulas.Tree(4, [3])]
vn = Copulas.trees2vine(trs, 4)

## construct D-Vine
vnConstructed = Copulas.vineFrom2(vn)

@test vnConstructed == dVn4


end
