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

inds = Copulas.arr2triangular(4, 4)
@test (2, 3) == inds

inds = Copulas.arr2triangular(8, 24)
@test (5, 7) == inds

inds = Copulas.arr2triangular(7, 12)
@test (3, 4) == inds

## reverse direction
ind = Copulas.triangular2arr(4, 1, 3)
@test ind == 2

ind = Copulas.triangular2arr(4, 3, 4)
@test ind == 6

ind = Copulas.triangular2arr(6, 3, 5)
@test ind == 11

@test_throws Exception Copulas.triangular2arr(5, 3, 3)
@test_throws Exception Copulas.triangular2arr(5, 3, 2)
@test_throws Exception Copulas.triangular2arr(5, 3, 6)


end
