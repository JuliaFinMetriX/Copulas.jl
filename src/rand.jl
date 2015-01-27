## ## parametric copula without rotation
## ##-----------------------------------

## function rand(cop::ParamPC)
##     fam, params = getFamAndParams(cop)

##     @mput fam params
##     simVal = @matlab PairCopulaRand(fam, 1, params)
##     return simVal
## end

## ## multiple values
## function rand(cop::ParamPC, n::Int)
##     fam, params = getFamAndParams(cop)
##     nFloat = float(n)

##     @mput fam params nFloat
##     simVal = @matlab PairCopulaRand(fam, nFloat, params)
##     return simVal
## end

## ## parametric copula with rotation
## ##--------------------------------

## function rand(cop::ModPC)
##     return rand(cop.cop, cop.mod)
## end

## function rand(cop::ParamPC, rot::Rotation)
##     fam, params = getFamAndParams(cop)
##     degr = rot.degrees

##     @mput fam params degrees
##     simVal = @matlab PairCopulaRand(fam, 1, params, degr)
##     return simVal
## end

## ## multiple values
## function rand(cop::ModPC, n::Int)
##     return rand(cop.cop, cop.mod, n)
## end

## function rand(cop::ParamPC, rot::Rotation, n::Int)
##     fam, params = getFamAndParams(cop)
##     nFloat = float(n)
##     degr = rot.degrees

##     @mput fam params nFloat degr
##     simVal = @matlab PairCopulaRand(fam, nFloat, params, degr)
##     return simVal
## end
