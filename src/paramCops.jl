abstract ParamPairCop <: PairCop

type NormalCop <: ParamPairCop
    params::Array{Float64, 1}
end

type ClaytonCop <: ParamPairCop
    params::Array{Float64, 1}
end

