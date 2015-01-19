type Clayton <: ParamPC
    θ::Float64

    function Clayton(θ::Float64)
        if θ <= 0
            error("Clayton parameter must be larger than 0")
        end
        new(θ)
    end

end

function params(cop::Clayton)
    return (cop.θ,)
end

#####################
## copula function ##
#####################


## pdf function
##-------------

function pdf(cop::Clayton, u1::FloatVec, u2::FloatVec)
    θ = params(cop)[1]

    val = (θ+1).*(u1.*u2).^(-θ-1) .*
    				(u1.^-θ + u2.^-θ - 1).^(-(2θ+1)/θ)
    return val
end
