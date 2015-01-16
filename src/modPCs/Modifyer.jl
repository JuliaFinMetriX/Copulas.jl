abstract PCModification
abstract Rotation <: PCModification
abstract CWRotation <: Rotation
abstract counterCWRotation <: Rotation
abstract Reflection <: PCModification

abstract NoModification <: PCModification

#######################################################
## resolving pdf and cdf arguments for modifications ##
#######################################################

function resolve_args(mod::PCModification,
                      u1::FloatVec, u2::FloatVec)
    error("pdf modification still needs to be implemented for this
    type of copula modification")
end

function resolve_args(mod::PCModification, u1::Float64, u2::Float64)
    return resolve_args(mod, [u1], [u2])
end

function resolve_pval(mod::PCModification,
                      u1::FloatVec, u2::FloatVec)
    error("cdf modification still needs to be implemented for this
    type of copula modification")
end

function resolve_pval(mod::PCModification, u1::Float64, u2::Float64)
    return resolve_pval(mod, [u1], [u2])
end
