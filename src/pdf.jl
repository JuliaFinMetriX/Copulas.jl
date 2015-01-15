## parametric copula pdf
##----------------------

function pdf(cop::ParamPC, u::Float64, v::Float64)
    fam, params = getFamAndParams(cop)

    @mput fam u v params
    val = @matlab PairCopulaPDF(fam, u, v, params)
    return val
end

## vector inputs
function pdf(cop::ParamPC, u::Array{Float64, 1},
             v::Array{Float64, 1})
    checkSameLength(u, v)
        
    fam, params = getFamAndParams(cop)

    @mput fam u v params
    val = @matlab PairCopulaPDF(fam, u, v, params)
    return val
end

## parametric copula pdf with rotation
##------------------------------------

function pdf(cop::ModPC, u::Float64, v::Float64)
    return pdf(cop.cop, cop.mod, u, v)
end

function pdf(cop::ParamPC, rot::CWRotation, u::Float64, v::Float64)
    fam, params = getFamAndParams(cop)

    degr = rot.degrees

    @mput fam u v params degr
    val = @matlab PairCopulaPDF(fam, u, v, params, degr)
    return val
end

## vector inputs
function pdf(cop::ModPC, u::Array{Float64, 1},
             v::Array{Float64, 1})
    return pdf(cop.cop, cop.mod, u, v)
end

function pdf(cop::ParamPC, rot::CWRotation,
             u::Array{Float64, 1},
             v::Array{Float64, 1})
    checkSameLength(u, v)
    
    fam, params = getFamAndParams(cop)

    degr = rot.degrees

    @mput fam u v params degr
    val = @matlab PairCopulaPDF(fam, u, v, params, degr)
    return val
end


################################
## General pdf implementation ##
################################

function pdf(cop::PairCop, u::Float64, v::Float64)
    error("pdf function is not yet implemented for this type of copula")
end


function pdf(cop::PairCop,
             u::Array{Float64, 1}, v::Array{Float64, 1})
    error("pdf function is not yet implemented for this type of copula")
end

