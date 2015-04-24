module TestVine

using Copulas
using Base.Test

#######################
## Tree functions ##
#######################

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
