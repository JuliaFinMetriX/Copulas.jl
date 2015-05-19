module TestVine

using Copulas
using Base.Test

## constructors
##-------------

Copulas.Vine([0 2; 1 0])
@test_throws Exception Copulas.Vine([0 2; 1 0; 3 3])

## display functions
##------------------

display(Copulas.Vine([0 2; 1 0]))

##########################
## conversion functions ##
##########################

## single CTreePaths
dVine = Copulas.testvine(1)
tPexp = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
@test tPexp == Copulas.convert(Copulas.CTreePaths, dVine.trees[:, 3])

## single CTreeParRef
ctr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
tPexp = convert(Copulas.CTreeParRef, ctr)
@test tPexp == Copulas.convert(Copulas.CTreeParRef, dVine.trees[:, 3])

## create vine with parent notation
vn = Copulas.testvine(2)

## vine matrix to tree and back
kk_tr = convert(Copulas.CTreePaths, vn)
@test vn == Copulas.convert(Copulas.Vine, kk_tr)

@test vn == Copulas.Vine(kk_tr)

## create vine with parent notation
vn = Copulas.testvine(3)

## vine matrix to tree and back
kk_tr = Copulas.convert(Copulas.CTreeParRef, vn)
@test vn == Copulas.convert(Copulas.Vine, kk_tr)

@test vn == Copulas.Vine(kk_tr)

## unfinished vines
##-----------------

tr = Copulas.CTreePaths(3, [2 5], [6])
parNotVec = Copulas.convert(Copulas.CTreeParRef, tr, 6)
expVec = [-1, 3, 0, -1, 2, 3]
@test parNotVec.tree == expVec

tr2 = Copulas.convert(Copulas.CTreePaths, parNotVec)
@test tr == tr2

##########################
## simulation sequences ##
##########################

## test getting simulation sequences
vn = Copulas.testvine(2)
kk = Copulas.getSimSequences(vn, [2, 3, 4, 5])
@test kk == Array{Int, 1}[[2, 3, 4, 5, 1, 6], [2, 3, 4, 5, 6, 1]]

vn = Copulas.Vine([0 2 3;
                   1 0 1;
                   1 1 0])

expSeqs = Array{Int, 1}[[1, 2, 3];
                        [1, 3, 2];
                        [2, 1, 3];
                        [3, 1, 2]]

kk = Copulas.getSimSequences(vn)
@test kk == expSeqs

expAvg = [1.5;
          9/4;
          9/4]

## test average simulation sequence position
@test expAvg == Copulas.avgSimSequPosition(kk)

## test linkLayers
expOut = [0 1 1;
          1 0 2;
          1 2 0]
          
@test expOut == Copulas.linkLayers(vn)

#######################
## conditioning sets ##
#######################

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
