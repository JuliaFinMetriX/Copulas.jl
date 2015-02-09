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
    
#############################
## vine analysis functions ##
#############################

## TODO
##-----

## - getSimSequences
## - avgSimSequPosition
## - linkLayers

end
