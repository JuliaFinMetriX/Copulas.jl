## handle single observation
##--------------------------

function pdf(cop::PairCop, u1::Float64, u2::Float64)
    return pdf(cop, [u1], [u2])
end

## vector inputs
function pdf(cop::ParamPC, u::FloatVec,
             v::FloatVec)
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
function pdf(cop::ModPC, u::FloatVec,
             v::FloatVec)
    return pdf(cop.cop, cop.mod, u, v)
end

function pdf(cop::ParamPC, rot::CWRotation,
             u::FloatVec,
             v::FloatVec)
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
             u::FloatVec, v::FloatVec)
    error("pdf function is not yet implemented for this type of copula")
end

