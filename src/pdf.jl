## handle single observation
##--------------------------

function pdf(cop::PairCop, u1::Float64, u2::Float64)
    return pdf(cop, [u1], [u2])
end

## vector inputs
function pdf(cop::ParamPC, u1::FloatVec,
             u2::FloatVec)
    checkSameLength(u1, u2)
        
    fam, params = getFamAndParams(cop)

    @mput fam u1 u2 params
    val = @matlab PairCopulaPDF(fam, u1, u2, params)
    return val
end

## parametric copula pdf with rotation
##------------------------------------

function pdf(cop::ModPC, u1::Float64, u2::Float64)
    return pdf(cop.cop, cop.mod, u1, u2)
end

function pdf(cop::ParamPC, rot::CWRotation, u1::Float64, u2::Float64)
    fam, params = getFamAndParams(cop)

    degr = rot.degrees

    @mput fam u1 u2 params degr
    val = @matlab PairCopulaPDF(fam, u1, u2, params, degr)
    return val
end

## vector inputs
function pdf(cop::ModPC, u1::FloatVec,
             u2::FloatVec)
    return pdf(cop.cop, cop.mod, u1, u2)
end

function pdf(cop::ParamPC, rot::CWRotation,
             u1::FloatVec,
             u2::FloatVec)
    checkSameLength(u1, u2)
    
    fam, params = getFamAndParams(cop)

    degr = rot.degrees

    @mput fam u1 u2 params degr
    val = @matlab PairCopulaPDF(fam, u1, u2, params, degr)
    return val
end


################################
## General pdf implementation ##
################################

function pdf(cop::PairCop, u1::Float64, u2::Float64)
    error("pdf function is not yet implemented for this type of copula")
end


function pdf(cop::PairCop,
             u1::FloatVec, u2::FloatVec)
    error("pdf function is not yet implemented for this type of copula")
end

