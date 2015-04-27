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

tr = Copulas.CTreePaths(1, [2, 4], [2, 3, 10], [2, 3, 11], [5], [6, 7, 8, 9])
trPar = convert(Copulas.CTreeParRef, tr)
@test Copulas.findAndSortCondSet(trPar, [8, 7, 6]) == [6, 7, 8]
@test Copulas.findAndSortCondSet(trPar, [7, 6, 8]) == [6, 7, 8]
@test Copulas.findAndSortCondSet(trPar, [3, 2]) == [2, 3]
@test_throws Exception Copulas.findAndSortCondSet(trPar, [7, 8, 9])
@test Copulas.findAndSortCondSet(trPar, [2]) == [2]
@test_throws Exception Copulas.findAndSortCondSet(trPar, [7, 8, 9, 10])

############
## getPit ##
############

pcc = Copulas.testpcc(2)
u = [0.3, 0.4, 0.2, 0.7]

actPit = Copulas.getPit(pcc, 1, [2, 3], u)

cop23 = pcc[2, 3]
cop12 = pcc[1, 2]
cop13 = pcc[1, 3]
pit3_giv_2 = Copulas.vfun(cop23, u[3], u[2])
pit1_giv_2 = Copulas.hfun(cop12, u[1], u[2])
pit = Copulas.vfun(cop13, pit1_giv_2, pit3_giv_2)
@test pit == actPit

actPit = Copulas.getPit(pcc, 2, [3], u)
cop23 = pcc[2, 3]
pit = Copulas.hfun(cop23, u[2], u[3])
@test pit == actPit

pcc = Copulas.testpcc(1)
actPit = Copulas.getPit(pcc, 2, [4, 3], u)

pit2_giv_3 = Copulas.hfun(pcc[2, 3], u[2], u[3])
pit4_giv_3 = Copulas.vfun(pcc[3, 4], u[4], u[3])
pit = Copulas.hfun(pcc[2, 4], pit2_giv_3, pit4_giv_3)
@test actPit == pit


end
