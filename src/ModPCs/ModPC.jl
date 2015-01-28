type ModPC <: PairCop
    cop::PairCop
    mod::PCModification
end

##########################
## function evaluations ##
##########################

function pdf(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    return pdf(cop.cop, cop.mod, u1, u2)
end

function cdf(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    return cdf(cop.cop, cop.mod, u1, u2)
end

function hfun(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    return hfun(cop.cop, cop.mod, u1, u2)
end

function vfun(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    return vfun(cop.cop, cop.mod, u1, u2)
end

function hinv(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    return hinv(cop.cop, cop.mod, u1, u2)
end

function vinv(cop::ModPC,
             u1::FloatVec, u2::FloatVec)
    return vinv(cop.cop, cop.mod, u1, u2)
end
