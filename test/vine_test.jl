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
tPexp = Copulas.Tree(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
@test tPexp == Copulas.par2tree(dVine.trees[:, 3])

## create vine with parent notation
vn = Copulas.testvine(2)

## vine matrix to tree and back
kk_tr = Copulas.par2tree(vn.trees)
kk_out = Copulas.tree2par(kk_tr, 6)
@test kk_out == vn.trees
@test vn == Copulas.trees2vine(kk_tr, 6)

## create vine with parent notation
vn = Copulas.testvine(3)

## vine matrix to tree and back
kk_tr = Copulas.vine2trees(vn)
kk_out = Copulas.tree2par(kk_tr, 6)
@test kk_out == vn.trees
@test vn == Copulas.trees2vine(kk_tr, 6)

## unfinished vines
##-----------------

tr = Tree(3, [2 5], [6])
parNotVec = Copulas.tree2par(tr, 6)
expVec = [-1, 3, 0, -1, 2, 3]
@test parNotVec == expVec

tr2 = Copulas.par2tree(parNotVec)
@test tr == tr2

#######################
## conditioning sets ##
#######################

## getPathToRoot
##--------------

tr = Copulas.Tree(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
parNot = Copulas.tree2par(tr, 6)
path = Copulas.getPathToRoot(parNot, 6)
@test path == [5, 4]

tr = Copulas.Tree(3, Array{Int, 1}[[4, 6],[2, 1], [2, 5]])
parNot = Copulas.tree2par(tr, 6)
path = Copulas.getPathToRoot(parNot, 2)
@test path == []

tr = Copulas.Tree(3, Array{Int, 1}[[2, 1, 4],[2, 1, 5], [2, 6]])
parNot = Copulas.tree2par(tr, 6)
path = Copulas.getPathToRoot(parNot, 1)
@test path == [2]

path = Copulas.getPathToRoot(parNot, 5)
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
