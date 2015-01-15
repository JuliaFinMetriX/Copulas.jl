type ModPC <: PairCop
    cop::PairCop
    mod::PCModification
end

##########################
## function evaluations ##
##########################

function pdf(cop::ModPC, u1::Float64, u2::Float64)
    return pdf(cop.cop, cop.mod, u1, u2)
end

function pdf(cop::ModPC,
             u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return pdf(cop.cop, cop.mod, u1, u2)
end

function cdf(cop::ModPC, u1::Float64, u2::Float64)
    return cdf(cop.cop, cop.mod, u1, u2)
end

function cdf(cop::ModPC,
             u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return cdf(cop.cop, cop.mod, u1, u2)
end

