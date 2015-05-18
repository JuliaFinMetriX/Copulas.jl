module TestVine

using Copulas
using Base.Test

## constructors
##-------------

Copulas.Vine([0 2; 1 0])
Copulas.Vine([0 2; 1 0], ["var1", "var2"])
Copulas.Vine([0 2; 1 0], [:var1, :var2])
@test_throws Exception Copulas.Vine([0 2; 1 0; 3 3])

## display functions
##------------------

display(Copulas.Vine([0 2; 1 0]))

##########################
## conversion functions ##
##########################

dVine = Copulas.testvine(1)
tPexp = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
@test tPexp == Copulas.convert(Copulas.CTreePaths, dVine.trees[:, 3])

## create vine with parent notation
vn = Copulas.testvine(2)

## vine matrix to tree and back
kk_tr = convert(Copulas.CTreePaths, vn)
@test vn == Copulas.convert(Copulas.Vine, kk_tr)

## create vine with parent notation
vn = Copulas.testvine(3)

## vine matrix to tree and back
kk_tr = Copulas.convert(Copulas.CTreePaths, vn)
@test vn == Copulas.convert(Copulas.Vine, kk_tr)

## unfinished vines
##-----------------

tr = Copulas.CTreePaths(3, [2 5], [6])
parNotVec = Copulas.convert(Copulas.CTreeParRef, tr, 6)
expVec = [-1, 3, 0, -1, 2, 3]
@test parNotVec.tree == expVec

tr2 = Copulas.convert(Copulas.CTreePaths, parNotVec)
@test tr == tr2

#######################
## conditioning sets ##
#######################

## getPathToRoot
##--------------

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
path = Copulas.getPathToRoot(tr, 6)
@test path == [5, 4]

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 6],[2, 1], [2, 5]])
path = Copulas.getPathToRoot(tr, 2)
@test path == []

tr = Copulas.CTreePaths(3, Array{Int, 1}[[2, 1, 4],[2, 1, 5], [2, 6]])
path = Copulas.getPathToRoot(tr, 1)
@test path == [2]

path = Copulas.getPathToRoot(tr, 5)
@test path == [1, 2]

## getCondSet
##-----------

vn = Copulas.testvine(2)
condSet = Copulas.getCondSet(vn, 3, 5)
@test condSet == [2]

condSet = Copulas.getCondSet(vn, 6, 3)
@test condSet == [4, 5, 2]

condSet = Copulas.getCondSet(vn, 1, 3)
@test condSet == []

## getAllCopCondSets
##------------------

vn = Copulas.testvine(2)
condSets = Copulas.getAllCopCondSets(vn)

@test condSets[end] == [4]

ind = Copulas.sub2triang(6, 1, 5)
@test condSets[ind] == [3, 2]

ind = Copulas.sub2triang(6, 2, 6)
@test condSets[ind] == [5, 4]

## getAllVarCondSets
##------------------

vn = Copulas.testvine(2)
condSets1, condSets2 = Copulas.getAllVarCondSets(vn)

@test condSets1[end] == [4]
@test condSets2[end] == [4]

ind = Copulas.sub2triang(6, 1, 5)
@test condSets1[ind] == [3, 2]
@test condSets2[ind] == [2, 3]

ind = Copulas.sub2triang(6, 2, 6)
@test condSets1[ind] == [5, 4]
@test condSets2[ind] == [4, 5]

ind = Copulas.sub2triang(6, 1, 6)
@test condSets1[ind] == [3, 2, 5, 4]
@test condSets2[ind] == [4, 5, 2, 3]

#############################
## vine analysis functions ##
#############################

## TODO
##-----

## - getSimSequences
## - avgSimSequPosition
## - linkLayers

end
