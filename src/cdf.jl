################################
## General cdf implementation ##
################################

function cdf(cop::PairCop, u1::Float64, u2::Float64)
    error("cdf function is not yet implemented for this type of copula")
end

function cdf(cop::ModPC, u1::Float64, u2::Float64)
    ## resolve transformation
    u1Hat, u2Hat = resolve_args(cop.mod, u1, u2)

    pVal = cdf(cop.cop, u1Hat, u2Hat)
    pValHat = resolve_pval(cop.mod, pVal, u1, u2)

    return pValHat
end

function cdf(cop::PairCop,
             u1::FloatVec, u2::FloatVec)
    error("cdf function is not yet implemented for this type of copula")
end

function cdf(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    ## resolve transformation
    u1Hat, u2Hat = resolve_args(cop.mod, u1, u2)

    pVal = cdf(cop.cop, u1Hat, u2Hat)
    pValHat = resolve_pval(cop.mod, pVal, u1, u2)

    return pValHat
end
