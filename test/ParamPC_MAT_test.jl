module TestCopulas

using Copulas
using Base.Test

using MATLAB

## VineCPP ID to name / type
##--------------------------

@test Copulas.getCopNam(7) == :Clayton
@test Copulas.getCopNam(15) == :Plackett
@test Copulas.getCopType(8) == :FGMPC_MAT
@test Copulas.getCopType(4) == :BB6PC_MAT

## type construction
##------------------

cop = Copulas.GaussianPC_MAT([-0.5])
@test Copulas.getVineCPPId(cop) == 10

cop = Copulas.GumbelPC_MAT([-0.5])
@test Copulas.getVineCPPId(cop) == 11

@test Copulas.getVineCPPId(:Gumbel) == 11
@test Copulas.getVineCPPId(:Gaussian) == 10

###############
## pdf tests ##
###############

cop = Copulas.GaussianPC_MAT([-0.5])
u1, u2 = (0.4, 0.8)
val = Copulas.pdf(cop, u1, u2)

@test val == mxcall(:PairCopulaPDF, 1, 10.0, 0.4, 0.8, -0.5)

cop = Copulas.TawnPC_MAT([8.2, 0.5, 0.4])
u1, u2 = (0.4, 0.8)
val = Copulas.pdf(cop, u1, u2)

@test val == mxcall(:PairCopulaPDF, 1, 18.0, 0.4, 0.8, [8.2 0.5 0.4])

## vector input
cop = Copulas.GumbelPC_MAT([5])
u1, u2 = ([0.4, 0.5], [0.8, 0.2])
val = Copulas.pdf(cop, u1, u2)

valMAT = mxcall(:PairCopulaPDF, 1, 11.0, [0.4, 0.5], [0.8, 0.2], [5.])
@test val == valMAT

## wrong parameters and input
cop = Copulas.GaussianPC_MAT([5.5])
@test_throws Exception Copulas.pdf(cop, 0.3, 0.5)

cop = Copulas.GaussianPC_MAT([0.5])
@test_throws Exception Copulas.pdf(cop, 1.3, 0.5)

###############
## cdf tests ##
###############

cop = Copulas.GaussianPC_MAT([-0.5])
u1, u2 = (0.4, 0.8)
val = Copulas.cdf(cop, u1, u2)

@test val == mxcall(:PairCopulaCDF, 1, 10.0, 0.4, 0.8, -0.5)

cop = Copulas.TawnPC_MAT([8.2, 0.5, 0.4])
u1, u2 = (0.4, 0.8)
val = Copulas.cdf(cop, u1, u2)

@test val == mxcall(:PairCopulaCDF, 1, 18.0, 0.4, 0.8, [8.2 0.5 0.4])

## vector input
cop = Copulas.GumbelPC_MAT([5])
u1, u2 = ([0.4, 0.5], [0.8, 0.2])
val = Copulas.cdf(cop, u1, u2)

valMAT = mxcall(:PairCopulaCDF, 1, 11.0, [0.4, 0.5], [0.8, 0.2], [5.])
@test val == valMAT

## wrong parameters and input
cop = Copulas.GaussianPC_MAT([5.5])
@test_throws Exception Copulas.cdf(cop, 0.3, 0.5)

cop = Copulas.GaussianPC_MAT([0.5])
@test_throws Exception Copulas.cdf(cop, 1.3, 0.5)


end
