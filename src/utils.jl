function checkSameLength(u1::FloatVec, u2::FloatVec)
    if !(size(u1, 1) == size(u2, 1))
        error("u1 and u2 vector must be of same length")
    end
    return true
end

@doc doc"""
get family and parameter of copula instance
"""->
function getFamAndParams(cop::ParamPC_Cpp)
    return (float(getVineCppId(cop)), params(cop))
end

## this functions exists so that copula types at some point can be
## changed to follow the interface of Distributions.jl more closely.
## This means that each copula type will have multiple fields, one for
## each parameter, and function params(cop::ParamCop) will generally
## return a tuple. This allows additional flexibility, since a single
## parameter then can be more than just a single Float value, but it
## could also be a covariance matrix or a PCModification.
function params(cop::ParamPC_Cpp)
    return cop.params
end

## triangular indexing
##--------------------

@doc doc"""
transform single index of array to double index of upper triangular
matrix
""" ->
function triang2sub(nVars::Int64, ind::Int64)
    # indices are running column-wise
    elemsInRow = [(nVars-1):-1:1]
    lastInColumn = cumsum(elemsInRow)
    rowInd = findfirst(ind .<= lastInColumn)
    if rowInd == 1
        colInd = ind + 1
    else
        nInRow = ind - lastInColumn[rowInd-1]
        colInd = rowInd + nInRow
    end
    return (rowInd, colInd)
end

function triang2sub(nVars::Int64, inds::Array{Int, 1})
    nInds = length(inds)
    rowInds = zeros(Int, nInds)
    colInds = zeros(Int, nInds)
    for ii=1:nInds
        rowInd, colInd = triang2sub(nVars, inds[ii])
        rowInds[ii] = rowInd
        colInds[ii] = colInd
    end
    return rowInds, colInds
end

function sub2triang(nVars::Int64, rowInd::Int64, colInd::Int64)
    if !(rowInd < colInd <= nVars)
        error("column index must be larger than row index")
    end
    elemsInRow = [(nVars-1):-1:1]
    fullRows = sum(elemsInRow[1:(rowInd - 1)])
    return fullRows + (colInd - rowInd)
end
