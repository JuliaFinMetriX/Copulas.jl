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

################
## h-function ##
################

cop = Copulas.AMHPC_MAT([0.5])
u1, u2 = (0.4, 0.8)
val = Copulas.hfun(cop, u1, u2)

@test val == mxcall(:PairCopulaHfun, 1, 1.0, 0.4, 0.8, 0.5)

cop = Copulas.BB1PC_MAT([0.5, 5.])
u1, u2 = (0.4, 0.8)
val = Copulas.hfun(cop, u1, u2)

@test val == mxcall(:PairCopulaHfun, 1, 3.0, 0.4, 0.8, [0.5, 5.0])

## vector input
cop = Copulas.BB6PC_MAT([2., 5.2])
u1, u2 = ([0.4, 0.5], [0.8, 0.2])
val = Copulas.hfun(cop, u1, u2)

valMAT = mxcall(:PairCopulaHfun, 1, 4.0, [0.4, 0.5], [0.8, 0.2], [2., 5.2])
@test val == valMAT

## wrong parameters and input
cop = Copulas.BB6PC_MAT([0.5, 5.2])
@test_throws Exception Copulas.hfun(cop, 0.3, 0.5)

cop = Copulas.GaussianPC_MAT([0.5])
@test_throws Exception Copulas.hfun(cop, 1.3, 0.5)

################
## v-function ##
################

cop = Copulas.BB7PC_MAT([1.4, 4.2])
u1, u2 = (0.8, 0.2)
val = Copulas.vfun(cop, u1, u2)

@test val == mxcall(:PairCopulaVfun, 1, 5.0, 0.8, 0.2, [1.4, 4.2])

cop = Copulas.BB8PC_MAT([1.4, 0.2])
u1, u2 = (0.3, 0.1)
val = Copulas.vfun(cop, u1, u2)

@test val == mxcall(:PairCopulaVfun, 1, 6.0, 0.3, 0.1, [1.4, 0.2])

## vector input
cop = Copulas.FGMPC_MAT([-0.4])
u1, u2 = ([0.4, 0.5], [0.8, 0.2])
val = Copulas.vfun(cop, u1, u2)

valMAT = mxcall(:PairCopulaVfun, 1, 8.0, [0.4, 0.5], [0.8, 0.2], [-0.4])
@test val == valMAT

## wrong parameters and input
cop = Copulas.FrankPC_MAT([43.])
@test_throws Exception Copulas.vfun(cop, 0.3, 0.5)

cop = Copulas.GaussianPC_MAT([0.5])
@test_throws Exception Copulas.vfun(cop, 1.3, 0.5)

########################
## inverse h-function ##
########################

cop = Copulas.IteratedFGMPC_MAT([0.4, 0.2])
u1, u2 = (0.8, 0.2)
val = Copulas.hinv(cop, u1, u2)

@test val == mxcall(:PairCopulaInvHfun, 1, 12.0, 0.8, 0.2, [0.4, 0.2])

cop = Copulas.JoePC_MAT([4.])
u1, u2 = (0.3, 0.1)
val = Copulas.hinv(cop, u1, u2)

@test val == mxcall(:PairCopulaInvHfun, 1, 13.0, 0.3, 0.1, [4.])

## vector input
cop = Copulas.PartialFrankPC_MAT([8.])
u1, u2 = ([0.8, 0.2], [0.4, 0.5])
val = Copulas.hinv(cop, u1, u2)

valMAT = mxcall(:PairCopulaInvHfun, 1, 14.0, [0.8, 0.2], [0.4, 0.5], [8.])
@test val == valMAT

## wrong parameters and input
cop = Copulas.FrankPC_MAT([43.])
@test_throws Exception Copulas.hinv(cop, 0.3, 0.5)

cop = Copulas.GaussianPC_MAT([0.5])
@test_throws Exception Copulas.hinv(cop, 1.3, 0.5)

########################
## inverse v-function ##
########################

cop = Copulas.Tawn1PC_MAT([10.4, 0.2])
u1, u2 = (0.8, 0.2)
val = Copulas.vinv(cop, u1, u2)

@test val == mxcall(:PairCopulaInvVfun, 1, 16.0, 0.8, 0.2, [10.4, 0.2])

cop = Copulas.Tawn2PC_MAT([4.4, 0.4])
u1, u2 = (0.3, 0.1)
val = Copulas.vinv(cop, u1, u2)

@test val == mxcall(:PairCopulaInvVfun, 1, 17.0, 0.3, 0.1, [4.4, 0.4])

## vector input
cop = Copulas.tPC_MAT([0.4, 4.3])
u1, u2 = ([0.8, 0.2], [0.4, 0.5])
val = Copulas.vinv(cop, u1, u2)

valMAT = mxcall(:PairCopulaInvVfun, 1, 19.0, [0.8, 0.2], [0.4, 0.5],
                [0.4, 4.3])
                
mxcall(:PairCopulaInvVfun, 1, 19.0, [0.8], [0.4], [0.4, 4.3])

@test val == valMAT

## wrong parameters and input
cop = Copulas.FrankPC_MAT([43.])
@test_throws Exception Copulas.vinv(cop, 0.3, 0.5)

cop = Copulas.GaussianPC_MAT([0.5])
@test_throws Exception Copulas.vinv(cop, 1.3, 0.5)


end
