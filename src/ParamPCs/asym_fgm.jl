type AsymFGMPC <: ParamPC
    θ::Float64

    function AsymFGMPC(θ::Float64)
        if (θ <= 0) | (θ >= 1)
            error("θ parameter must be between 0 and 1")
        end
        new(θ)
    end

end

function params(cop::AsymFGMPC)
    return (cop.θ,)
end

######################
## copula functions ##
######################

function cdf(cop::AsymFGMPC, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]
    val = u1.*u2 + θ*u1.*u2.*(1 - u1 - u2 + u1.*u2).*u2.*(1 - u1)
    return val
end

function pdf(cop::AsymFGMPC, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]
    val = u1.*(θ*u1.*(6 - 9u2).*u2 + θ*(12u2 - 8).*u2) +
    	θ*(2 - 3u2).*u2 + 1
    return val
end

function hfun(cop::AsymFGMPC, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]
    val = -3θ*u1.^3.*u2.^2 + 2θ*u1.^3.*u2 +
         6θ*u1.^2.*u2.^2 - 4θ*u1.^2.*u2 -
         3θ*u1.*u2.^2 + 2θ*u1.*u2 + u1
    return val
end

function vfun(cop::AsymFGMPC, u2::FloatVec, u1::FloatVec)
    θ = params(cop)[1]

    val = -3θ*u1.^2.*u2.^3 + 3θ*u1.^2.*u2.^2 + 4θ*u1.*u2.^3 -
         4θ*u1.*u2.^2 - θ*u2.^3 + θ*u2.^2 + u2
    return val
end

