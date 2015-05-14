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
@test tP.paths[3] == [5, 6]

## sorting paths
paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
sortedPaths = Array{Int, 1}[[1, 2, 3], [1, 4], [5, 6], [5, 7, 8]]
@test sortedPaths == Copulas.sortPaths(paths)

## CTreeParRef
##------------

## test conversion
tPar = convert(Copulas.CTreeParRef, tP)
parNot = [9, 1, 2, 1, 9, 5, 5, 7, 0]
@test tPar.tree == parNot

tPar2 = Copulas.CTreeParRef(parNot)
@test tPar == tPar2

## additional conversion tests
##----------------------------

tPar = Copulas.CTreeParRef([9, 1, 2, 1, 9, -1, 5, 7, 0])
tPaths = Copulas.CTreePaths(9, [1, 4], [1, 2, 3], [5, 7, 8])
@test !(tPar == tPaths)
tPar2 = convert(Copulas.CTreeParRef, tPaths)
@test tPar == tPar2

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

################
## tree nodes ##
################

paths = Array{Int, 1}[[1, 4], [1, 2, 3], [5, 6], [5, 7, 8]]
tr1 = Copulas.CTreePaths(9, paths)
tr2 = convert(Copulas.CTreeParRef, tr1)

allTrees = [tr1, tr2]

for tr in allTrees
    @test Copulas.allNodes(tr1) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @test Copulas.allPathNodes(tr1) == [1, 2, 3, 4, 5, 6, 7, 8]
end

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
