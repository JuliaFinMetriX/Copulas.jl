type AsymFGM <: ParamPC
    θ::Float64

    function AsymFGM(θ::Float64)
        if (θ <= 0) | (θ >= 1)
            error("θ parameter must be between 0 and 1")
        end
        new(θ)
    end

end

function params(cop::AsymFGM)
    return (cop.θ,)
end

######################
## copula functions ##
######################

function cdf(cop::AsymFGM, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]
    val = u1.*u2 + θ*u1.*u2.*(1 - u1 - u2 - u1.*u2).*u2.*(1 - u1)
    return val
end

function pdf(cop::AsymFGM, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]
    val = θ*(u1.^2.*(9*u2.^2 + 6*u2) + (2 - 8*u1).*u2 - 3*u2.^2) + 1
    return val
end

function hfun(cop::AsymFGM, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]
    val = 3*θ*u1.^3.*u2.^2 + 2*θ*u1.^3.*u2 - 4*θ*u1.^2.*u2 -
    3*θ*u1.*u2.^2 + 2*θ*u1.*u2 + u1
    return val
end

function vfun(cop::AsymFGM, u2::FloatVec, u1::FloatVec)
    θ = params(cop)[1]
    val = 3*θ*u1.^2.*u2.^3 + 3*θ*u1.^2.*u2.^2 - 4*θ*u1.*u2.^2 - θ*u2.^3 +
    θ*u2.^2 + u2
    return val
end

