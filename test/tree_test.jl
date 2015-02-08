module TestVine

using Copulas
using Base.Test

## constructors
##-------------

##############################
## Array of Array functions ##
##############################

paths = Array{Int, 1}[[1], [1, 2, 3], [2, 3, 4], [2, 1]]

## length functions
@test Copulas.maxDepth(paths) == 3
@test length(paths) == 4

## conversion to matrix
pathsArr = [1 1 2 2; 0 2 3 1; 0 3 4 0]
@test Copulas.tree2arr(paths) == pathsArr
@test Copulas.arr2tree(pathsArr) == paths

## sorting paths
paths = Array{Int, 1}[[1, 2, 3], [1], [2, 3, 4], [2, 1]]
sortedPaths = Array{Int, 1}[[1], [1, 2, 3], [2, 1], [2, 3, 4]]
@test sortedPaths == Copulas.sortPaths(paths)

#######################
## Tree functions ##
#######################

## constructors
##-------------

tP1 = Copulas.Tree(5, [1], [1 2 3], [2 3 4], [2 1])

paths = Array{Int, 1}[[1], [1, 2, 3], [2, 3, 4], [2, 1]]
tP = Copulas.Tree(5, paths)
@test tP == tP1
@test tP.paths[3] == [2, 1]

## display functions
##------------------

Copulas.display(tP1)
Copulas.display([tP1, tP1])

## length
##-------

@test Copulas.maxDepth(tP) == 3
@test length(tP) == 4
@test Copulas.getDepths(tP) == [1, 3, 2, 3]

## getindex
##---------

@test tP[1] == [1]
@test tP[3] == [2, 1]
@test_throws BoundsError tP[8]

@test tP[3, 2] == 1
@test tP[1, 1] == 1
@test_throws BoundsError tP[1, 3]

@test tP[[2, 2], [1, 2]] == [1, 2]
@test tP[[4, 4], [2, 3]] == [3, 4]
@test tP[[4, 1], [3, 1]] == [1, 4]
@test tP[[1, 2], [1, 1]] == [1]
@test_throws Exception tP[[1, 2], [3]]

## all values
##-----------

@test Copulas.allVals(tP) == [1, 2, 3, 4, 5]
@test Copulas.allPathVals(tP) == [1, 2, 3, 4]


## equality
##---------

paths2 = Array{Int, 1}[[1], [1, 2, 3], [2, 3, 4], [2, 1, 3]]
tP2 = Copulas.Tree(5, paths2)

@test tP == tP
@test !(tP == tP2)

## conditional set
##----------------

tP = Copulas.Tree(6, [1 2 3], [1 2 4], [5 3])
@test Copulas.condSetChk([2, 1], tP)
@test !(Copulas.condSetChk([2, 4], tP))


end
