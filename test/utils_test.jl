module TestCopulas

using Copulas
using Base.Test

## checkSameLength
##----------------

@test Copulas.checkSameLength([0.3, 0.4], [0.8, 0.9])
@test_throws Exception Copulas.checkSameLength([0.3, 0.4], [0.8])

## params
##-------

## cop = Copulas.GaussianPC_MAT([-0.5])
## rho = Copulas.params(cop)
## @test rho == [-0.5]

cop = Copulas.GaussianPC_Cpp([-0.5])
rho = Copulas.params(cop)
@test rho == [-0.5]


## getFamAndParams
##----------------

famId, rho = Copulas.getFamAndParams(cop)
@test famId == 10.0
@test rho == [-0.5]

end
