function checkSameLength(u::Array{Float64, 1}, v::Array{Float64, 1})
    if !(size(u, 1) == size(v, 1))
        error("u and v vector must be of same length")
    end
    return true
end

function getFamAndParams(cop::ParamPC)
    return (float(getCopId(cop)), paramsMatlab(cop))
end

## this functions exists so that copula types at some point can be
## changed to follow the interface of Distributions.jl more closely.
## This means that each copula type will have multiple fields, one for
## each parameter, and function params(cop::ParamCop) will generally
## return a tuple. This allows additional flexibility, since a single
## parameter then can be more than just a single Float value, but it
## could also be a covariance matrix or a PCModification.
function paramsMatlab(cop::PairCop)
    return cop.params
end
