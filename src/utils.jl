function checkSameLength(u1::FloatVec, u2::FloatVec)
    if !(size(u1, 1) == size(u2, 1))
        error("u1 and u2 vector must be of same length")
    end
    return true
end

function getFamAndParams(cop::ParamPC_MAT)
    return (float(getVineCPPId(cop)), params(cop)')
end

## this functions exists so that copula types at some point can be
## changed to follow the interface of Distributions.jl more closely.
## This means that each copula type will have multiple fields, one for
## each parameter, and function params(cop::ParamCop) will generally
## return a tuple. This allows additional flexibility, since a single
## parameter then can be more than just a single Float value, but it
## could also be a covariance matrix or a PCModification.
function params(cop::ParamPC_MAT)
    return cop.params
end
