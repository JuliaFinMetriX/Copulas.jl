####################
## type hierarchy ##
####################

## abstract PairCop
abstract AbstractParamPC <: PairCop
abstract ParamPC <: AbstractParamPC
abstract ParamPC_MAT <: AbstractParamPC

    
##################
## pdf function ##
##################

## capture general cases
##----------------------

function pdf(cop::PairCop,
             u1::FloatVec, u2::FloatVec)
    error("pdf function is not yet implemented for this type of copula")
end

## handle single observation
##--------------------------

function pdf(cop::PairCop, u1::Float64, u2::Float64)
    return pdf(cop, [u1], [u2])
end

##################
## cdf function ##
##################

## capture general cases
##----------------------

function cdf(cop::PairCop,
             u1::FloatVec, u2::FloatVec)
    error("cdf function is not yet implemented for this type of copula")
end

## handle single observation
##--------------------------

function cdf(cop::PairCop, u1::Float64, u2::Float64)
    return cdf(cop, [u1], [u2])
end

