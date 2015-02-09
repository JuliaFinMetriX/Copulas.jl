module TestPCC

using Copulas
using Base.Test

##################
## constructors ##
##################

# wrong dimensions
vn = Copulas.testvine(1)
cops = [Copulas.GaussianPC_Cpp([0.5]) for ii=1:4]
@test_throws Exception Copulas.PCC(cops, vn)

# should work
vn = Copulas.testvine(1)
nDims = size(vn.trees, 2)
nCops = sum((nDims-1):-1:1)
cops = [Copulas.GaussianPC_Cpp([0.5]) for ii=1:(nCops-1)]
cops = [cops, Copulas.ClaytonPC_Cpp([4.3])]
pcc = Copulas.PCC(cops, vn)

# implicitly using type GaussianPC_Cpp
cops = [Copulas.GaussianPC_Cpp([0.5]) for ii=1:nCops]
pcc = Copulas.PCC(cops, vn)
typeof(pcc)

# explicitly forcing type PairCop
cops = Copulas.PairCop[Copulas.GaussianPC_Cpp([0.5]) for ii=1:nCops]
pcc = Copulas.PCC(cops, vn)
typeof(pcc)

# from vine only
vn = Copulas.testvine(2)
pcc = Copulas.PCC(vn)

#############
## display ##
#############

pcc = Copulas.testpcc(2)
display(pcc)

## getCopNam
##----------

@test "1,3|2" == Copulas.getCopNam(2, pcc)
@test "1,2" == Copulas.getCopNam(1, pcc)

########################
## get- and setindex! ##
########################

pcc = Copulas.testpcc(2)

copExp = Copulas.GaussianPC_Cpp([0.2])
@test copExp == pcc[2, 3]

pcc[1, 4] = Copulas.ClaytonPC_Cpp([4.2])

## sortCondSet
##------------

tr = Copulas.Tree(1, [2, 4], [2, 3, 10], [2, 3, 11], [5], [6, 7, 8, 9])
parNot = Copulas.tree2par(tr, 11)
@test Copulas.sortCondSet(parNot, [8, 7, 6]) == [6, 7, 8]
@test Copulas.sortCondSet(parNot, [7, 6, 8]) == [6, 7, 8]
@test Copulas.sortCondSet(parNot, [3, 2]) == [2, 3]
@test_throws Exception Copulas.sortCondSet(parNot, [7, 8, 9])
@test Copulas.sortCondSet(parNot, [2]) == [2]
@test_throws Exception Copulas.sortCondSet(parNot, [7, 8, 9, 10])

## display
##--------

end
