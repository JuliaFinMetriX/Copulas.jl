type AsymFGM <: ParamPC
    a::Float64

    function AsymFGM(a::Float64)
        if (a <= 0) | (a >= 1)
            error("a parameter must be between 0 and 1")
        end
        new(a)
    end

end

function params(cop::AsymFGM)
    return (cop.a,)
end

#####################
## copula function ##
#####################

## cdf
##----

function cdf(cop::AsymFGM, u1::FloatVec, u2::FloatVec)
    a = params(cop)[1]
    val = u1.*u2 + a*u1.*u2.*(1 - u1 - u2 - u1.*u2).*u2.*(1 - u1)
    return val
end

function vfun(cop::AsymFGM, )
    v (1 + a v (1 - 4 u - v + 3 u^2 (1 + v)))

u*v + a*u*v*(1 - u - v - u*v)*v*(1 - u )
