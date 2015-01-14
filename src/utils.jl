function checkSameLength(u::Array{Float64, 1}, v::Array{Float64, 1})
    if !(size(u, 1) == size(v, 1))
        error("u and v vector must be of same length")
    end
    return true
end

function getFamAndParams(cop::ParamPC)
    return (float(getCopId(cop)), cop.params)
end
