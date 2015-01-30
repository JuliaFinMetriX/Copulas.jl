module TestCopulas

using Copulas
using Base.Test

##############
## asym_fgm ##
##############

cop = Copulas.AsymFGM(0.4)
@test [1.0] == Copulas.cdf(cop, 1.0, 1.0)



end
