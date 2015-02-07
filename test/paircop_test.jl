module TestCopulas

using Copulas
using Base.Test

## test missing functions
##-----------------------

u1 = [0.4]
u2 = [0.5]

cop = Copulas.ClaytonPC(3.0)
@test_throws Exception Copulas.pdf(cop, u1, u2)
@test_throws Exception Copulas.cdf(cop, u1, u2)
@test_throws Exception Copulas.hfun(cop, u1, u2)
@test_throws Exception Copulas.vfun(cop, u1, u2)
@test_throws Exception Copulas.hinv(cop, u1, u2)
@test_throws Exception Copulas.vinv(cop, u1, u2)


## test extensions to Float64
##---------------------------

u1 = [0.4, 0.5]
u2 = [0.5, 0.7]

cop = Copulas.ClaytonPC_Cpp([3.0])

expOut = Copulas.pdf(cop, [u1[1], u1[1]], u2)
@test Copulas.pdf(cop, u1[1], u2) == expOut
expOut = Copulas.pdf(cop, u1, [u2[1], u2[1]])
@test Copulas.pdf(cop, u1, u2[1]) == expOut
expOut = Copulas.pdf(cop, [u1[1]], [u2[1]])
@test Copulas.pdf(cop, u1[1], u2[1]) == expOut

expOut = Copulas.cdf(cop, [u1[1], u1[1]], u2)
@test Copulas.cdf(cop, u1[1], u2) == expOut
expOut = Copulas.cdf(cop, u1, [u2[1], u2[1]])
@test Copulas.cdf(cop, u1, u2[1]) == expOut
expOut = Copulas.cdf(cop, [u1[1]], [u2[1]])
@test Copulas.cdf(cop, u1[1], u2[1]) == expOut

expOut = Copulas.hfun(cop, [u1[1], u1[1]], u2)
@test Copulas.hfun(cop, u1[1], u2) == expOut
expOut = Copulas.hfun(cop, u1, [u2[1], u2[1]])
@test Copulas.hfun(cop, u1, u2[1]) == expOut
expOut = Copulas.hfun(cop, [u1[1]], [u2[1]])
@test Copulas.hfun(cop, u1[1], u2[1]) == expOut

expOut = Copulas.vfun(cop, [u1[1], u1[1]], u2)
@test Copulas.vfun(cop, u1[1], u2) == expOut
expOut = Copulas.vfun(cop, u1, [u2[1], u2[1]])
@test Copulas.vfun(cop, u1, u2[1]) == expOut
expOut = Copulas.vfun(cop, [u1[1]], [u2[1]])
@test Copulas.vfun(cop, u1[1], u2[1]) == expOut

expOut = Copulas.hinv(cop, [u1[1], u1[1]], u2)
@test Copulas.hinv(cop, u1[1], u2) == expOut
expOut = Copulas.hinv(cop, u1, [u2[1], u2[1]])
@test Copulas.hinv(cop, u1, u2[1]) == expOut
expOut = Copulas.hinv(cop, [u1[1]], [u2[1]])
@test Copulas.hinv(cop, u1[1], u2[1]) == expOut

expOut = Copulas.vinv(cop, [u1[1], u1[1]], u2)
@test Copulas.vinv(cop, u1[1], u2) == expOut
expOut = Copulas.vinv(cop, u1, [u2[1], u2[1]])
@test Copulas.vinv(cop, u1, u2[1]) == expOut
expOut = Copulas.vinv(cop, [u1[1]], [u2[1]])
@test Copulas.vinv(cop, u1[1], u2[1]) == expOut

end
