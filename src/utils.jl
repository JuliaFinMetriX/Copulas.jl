function checkSameLength(u1::FloatVec, u2::FloatVec)
    if !(size(u1, 1) == size(u2, 1))
        error("u1 and u2 vector must be of same length")
    end
    return true
end

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

function arr2triangular(nVars::Int64, ind::Int64)
    # indices are running column-wise
    elemsInRow = [(nVars-1):-1:1]
    lastInColumn = cumsum(elemsInRow)
    rowInd = findfirst(ind .< lastInColumn)
    nInRow = ind - lastInColumn[rowInd-1]
    colInd = rowInd + nInRow
    return (rowInd, colInd)
end

function triangular2arr(nVars::Int64, rowInd::Int64, colInd::Int64)
    if !(rowInd < colInd <= nVars)
        error("column index must be larger than row index")
    end
    elemsInRow = [(nVars-1):-1:1]
    fullRows = sum(elemsInRow[1:(rowInd - 1)])
    return fullRows + (colInd - rowInd)
end
