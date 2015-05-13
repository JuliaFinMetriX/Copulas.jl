######################
## type declaration ##
######################

@doc doc"""
PITMatrix to allow reusage of probability integral transforms.
Original data is stored at the main diagonal. Values at main diagonal
must be copula data between 0 and 1.
"""->
type PITMatrix
    data::Array{Float64, 3}
    function PITMatrix(x::Array{Float64, 3})
        if !(size(x, 1) == size(x, 2))
            error("First two dimensions must be of equal size")
        end
        for ii=1:size(x, 1)
            if any(x[ii, ii, :][:] .> 1)
                error("Copula data values must not be larger than 1.")
            end
            if any(x[ii, ii, :][:] .< 0)
                error("Copula data values must not be smaller than 0.")
            end
        end
        return new(x)
    end
end

##################
## constructors ##
##################

@doc doc"""
Initialize PITMatrix with single observation per variable.
"""->
function PITMatrix(x::Array{Float64, 1})
    d = length(x)
    pitMatr = fill(NaN, d, d, 1)
    for ii=1:d
        pitMatr[ii, ii] = x[ii]
    end
    return PITMatrix(pitMatr)
end

@doc doc"""
Initialize PITMatrix with multiple observations per variable.
"""->
function PITMatrix(x::Array{Float64, 2})
    n, d = size(x)
    pitMatr = fill(NaN, d, d, n)
    for ii=1:d
        pitMatr[ii, ii, :] = x[:, ii]
    end
    return PITMatrix(pitMatr)
end

##############
## getindex ##
##############

import Base.getindex
function getindex(pitMatr::PITMatrix, ind1::Int, ind2::Int)
    return dg(pitMatr)[ind1, ind2, :][:]
end

##########################
## additional functions ##
##########################

function dg(pitMatr::PITMatrix)
    return pitMatr.data
end

import Base.isequal
function isequal(pitMatr1::PITMatrix, pitMatr2::PITMatrix)
    return isequal(dg(pitMatr1), dg(pitMatr2))
end
