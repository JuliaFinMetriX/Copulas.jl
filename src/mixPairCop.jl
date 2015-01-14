type MixPairCop <: PairCop
    BasePairCops::Array{PairCop, 1}
    wgts::Array{Float64, 1}
end
