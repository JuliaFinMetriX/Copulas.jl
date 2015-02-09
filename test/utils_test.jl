module TestCopulas

using Copulas
using Base.Test

## checkSameLength
##----------------

@test Copulas.checkSameLength([0.3, 0.4], [0.8, 0.9])
@test_throws Exception Copulas.checkSameLength([0.3, 0.4], [0.8])

## params
##-------

cop = Copulas.GaussianPC_Cpp([-0.5])
rho = Copulas.params(cop)
@test rho == [-0.5]


## getFamAndParams
##----------------

famId, rho = Copulas.getFamAndParams(cop)
@test famId == 10.0
@test rho == [-0.5]

## triangular indexing
##--------------------

inds = Copulas.triang2sub(4, 1)
@test (1, 2) == inds

inds = Copulas.triang2sub(4, 2)
@test (1, 3) == inds

inds = Copulas.triang2sub(4, 3)
@test (1, 4) == inds

inds = Copulas.triang2sub(6, 5)
@test (1, 6) == inds

inds = Copulas.triang2sub(4, 4)
@test (2, 3) == inds

inds = Copulas.triang2sub(8, 24)
@test (5, 7) == inds

inds = Copulas.triang2sub(7, 12)
@test (3, 4) == inds

## reverse direction
ind = Copulas.sub2triang(4, 1, 3)
@test ind == 2

ind = Copulas.sub2triang(4, 3, 4)
@test ind == 6

ind = Copulas.sub2triang(6, 3, 5)
@test ind == 11

@test_throws Exception Copulas.sub2triang(5, 3, 3)
@test_throws Exception Copulas.sub2triang(5, 3, 2)
@test_throws Exception Copulas.sub2triang(5, 3, 6)


end
