type PCC <: Copula
    pairCops::PairCops
    vine::Vine
    funcs::Array{Function, 1}
end

function dim(pcc::PCC)
    return size(pcc.vine.trees, 1)
end

import Base.getindex
function getindex(pcc::PCC, ind1::Int64, ind2::Int64)
    # return pair copula for pair of variables
    n = dim(pcc)
    singleInd = []
    if ind1 < ind2
        singleInd = triangular2arr(n, ind1, ind2)
    else
        singleInd = triangular2arr(n, ind2, ind1)
    end
    return pcc.pairCops[singleInd]
end

import Base.setindex!
function setindex!(pcc::PCC, cop::PairCop,
                   ind1::Int64, ind2::Int64)
    # return pair copula for pair of variables
    n = dim(pcc)
    singleInd = []
    if ind1 < ind2
        singleInd = triangular2arr(n, ind1, ind2)
    else
        singleInd = triangular2arr(n, ind2, ind1)
    end
    pcc.pairCops[singleInd] = cop
end

