module TestCTree

using Copulas
using Base.Test


##################
## constructors ##
##################

## CTreePaths
##------------

paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]

tP = Copulas.CTreePaths(9, paths)
tP1 = Copulas.CTreePaths(9, [1, 4], [1, 2, 3], [5, 6], [5, 7, 8])

@test tP == tP1
@test Copulas.dg(tP)[3] == [5, 6]

## sorting paths
paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
sortedPaths = Array{Int, 1}[[1, 2, 3], [1, 4], [5, 6], [5, 7, 8]]
@test sortedPaths == Copulas.sortPaths(paths)

## CTreeParRef
##------------

## test conversion
tPar = convert(Copulas.CTreeParRef, tP)
parNot = [9, 1, 2, 1, 9, 5, 5, 7, 0]
@test Copulas.dg(tPar) == parNot

tPar2 = Copulas.CTreeParRef(parNot)
@test tPar == tPar2

## additional conversion tests
##----------------------------

tPar = Copulas.CTreeParRef([9, 1, 2, 1, 9, -1, 5, 7, 0])
tPaths = Copulas.CTreePaths(9, [1, 4], [1, 2, 3], [5, 7, 8])
@test !(tPar == tPaths)
tPar2 = convert(Copulas.CTreeParRef, tPaths)
@test tPar == tPar2

@test tPar == convert(Copulas.CTreeParRef, tPar)
@test tPaths == convert(Copulas.CTreePaths, tPaths)

#########################
## dimension functions ##
#########################

## CTreePaths
##------------

paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
tr1 = Copulas.CTreePaths(9, paths)
tr2 = convert(Copulas.CTreeParRef, tr1)

## conversion to matrix
pathsArr = [1 1 5 5; 4 2 6 7; 0 3 0 8]
@test Copulas._cTreePaths2arr(paths) == pathsArr
@test Copulas._arr2CTreePaths(pathsArr) == paths

allTrees = [tr1, tr2]

for tr in allTrees
   @test Copulas.maxDepth(tr) == 3
   @test Copulas.width(tr) == 4
   @test Copulas.getDepths(tr) == [3, 2, 2, 3]
end

#############
## display ##
#############

## CTreePaths
##------------

paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
tP = Copulas.CTreePaths(9, paths)

display(tP)
display([tP, tP])

## CTreeParRef
##------------

tPar = convert(Copulas.CTreeParRef, tP)
display(tPar)
display([tPar, tPar])

##############
## getindex ##
##############

paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
tr = Copulas.CTreePaths(9, paths)

@test tr[3, 2] == 6
@test tr[3] == [5, 6]
@test tr[[3, 4], [2, 3]] == [6, 8]

################
## tree nodes ##
################

paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
tr1 = Copulas.CTreePaths(9, paths)
tr2 = convert(Copulas.CTreeParRef, tr1)

allTrees = [tr1, tr2]

for tr in allTrees
    @test Copulas.allNodes(tr) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @test Copulas.allPathNodes(tr) == [1, 2, 3, 4, 5, 6, 7, 8]
end

@test 9 == Copulas.getRoot(tr1)
@test 9 == Copulas.getRoot(tr2)

#######################
## conditioning sets ##
#######################

## condSetChk
##-----------

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
Copulas.viz(tr)

@test Copulas.condSetChk([4, 5], tr)
@test Copulas.condSetChk([1, 2], tr)
@test Copulas.condSetChk([2, 1], tr)

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
tr = convert(Copulas.CTreeParRef, tr)
@test !Copulas.condSetChk([2, 4], tr)

## findAndSortCondSet
##-------------------

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
tr = convert(Copulas.CTreeParRef, tr)

@test [2; 1] == Copulas.findAndSortCondSet(tr, [2, 1])
@test [4; 5] == Copulas.findAndSortCondSet(tr, [5, 4])
@test_throws Exception Copulas.findAndSortCondSet(tr, [4, 6])

## getPathToRoot
##--------------

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 5, 6],[2, 1]])
path = Copulas.getPathToRoot(tr, 6)
@test path == [4, 5]

tr = Copulas.CTreePaths(3, Array{Int, 1}[[4, 6],[2, 1], [2, 5]])
path = Copulas.getPathToRoot(tr, 2)
@test path == []

tr = Copulas.CTreePaths(3, Array{Int, 1}[[2, 1, 4],[2, 1, 5], [2, 6]])
path = Copulas.getPathToRoot(tr, 1)
@test path == [2]

path = Copulas.getPathToRoot(tr, 5)
@test path == [2, 1]

#############
## attach! ##
#############

## attach to end of path
tr = Copulas.CTreePaths(1, [2 3], [4])
Copulas.attach!(tr, 5, [2,3])

expOut = Copulas.CTreePaths(1, [2 3 5], [4])
@test tr == expOut

## attach with empty condset
tr = Copulas.CTreePaths(1, [2 3], [4])
Copulas.attach!(tr, 5, Array(Int, 0))

expOut = Copulas.CTreePaths(1, [2 3], [4], [5])
@test tr == expOut

## attach with non-matching condset
tr = Copulas.CTreePaths(1, [2 3], [4])
Copulas.attach!(tr, 6, [7, 8])

expOut = Copulas.CTreePaths(1, [2 3], [4])
@test tr == expOut

## attach to middle of path
tr = Copulas.CTreePaths(1, [2 3], [4])
Copulas.attach!(tr, 5, [2]) # does not sort

expOut = Copulas.CTreePaths(1, [2 3], [4], [2 5])
@test tr == expOut

end
