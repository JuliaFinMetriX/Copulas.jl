@doc doc"""
Representation of a pair copula contruction. A `PCC` stores an `Array`
of copulas together with a `Vine` instance representing the actual
density decomposition. Within the `Vine` instance, the density
decomposition is stored in parent notation for reasons of memory
efficiency.

## Copulas

Involved copulas are stored as `Array` for memory efficiency. However,
upper level access functions treat the array of copulas is if they
were stored in a upper triangular matrix, with copula C_{ij|klm}
accessible through indices i and j. Thereby, i always is smaller than
j! In order to switch between triangular notation and array
implementation, function `triang2sub` converts linear triangular
matrix indexing into row and column indices, and function `sub2triang`
working the other direction.

### Simplifying assumption

In order to allow for conditional copulas, the array of copulas is of
abstract type, enabling static `PairCop` copulas as well as
`VarPairCop` as varying conditional copulas.

As a means of characterizing a pair copula construction, it suffices
to store varying conditional copulas as type `VarPairCop`, with one
field capturing the copula family, and a second field capturing an
anonymous function.

When it comes to evaluating functions on the conditional copula,
however, the conditional functional needs to be resolved. For example,
`hfun(varCop, u1, u2)` does not work, as there would be no way to
calculate the actual parameters of `varCop` inside of the function:
`varCop` might depend on u3, u4,... 
"""->
type PCC{T} <: Copula
    pccCops::Array{T, 1}
    vine::Vine{Int}

    function PCC(cops::Array{T, 1}, vn::Vine{Int})
        ## test sizes
        nVars = size(vn.trees, 2)
        nCops = sum((nVars-1):-1:1)
        if !(size(cops, 1) == nCops)
            error("Vine size must coincide with number of copulas. ")
        end
        return new(cops, vn)
    end
end

function PCC{T}(cops::Array{T, 1}, vn::Vine{Int})
    return PCC{T}(cops, vn)
end

function PCC(vn::Vine{Int})
    # fill with independence copulas
    nVars = size(vn.trees, 2)
    nCops = sum((nVars-1):-1:1)
    cops = ParamPC_Cpp[IndepPC_Cpp([0.0]) for ii=1:nCops]
    return PCC(cops, vn)
end


## get information
##----------------

function dim(pcc::PCC)
    return size(pcc.vine.trees, 1)
end

#############
## display ##
#############

import Base.Multimedia.display
@doc doc"""
For each pair copula, get its name in terms of conditioning sets
(1,2|3,6 for example) and the respective copula family that is used.
Display pair copulas sorted with increasing conditioning set.
"""->
function display(pcc::PCC)
    # get all conditioning sets
    condSets = Copulas.getCondSets(pcc.vine)
    nVars = dim(pcc)
    typ = eltype(pcc.pccCops)
    println("$nVars dimensional pair copula construction of type $typ:")

    # get maximum copula name length
    maxNameLen = []
    if nVars < 10
        maxNameLen = nVars + (nVars-1)
    else
        maxNameLen = 9 + (nVars-9)*2 + (nVars-1)
    end
    
    maxCondSetLen = nVars - 2
    for setLen=0:maxCondSetLen # for each layer
        # get conditioning sets of this layer
        inds = find([length(cs) == setLen for cs in condSets])
        # print name of each copula
        for ii=1:length(inds)
            copName = getCopNam(inds[ii], nVars, condSets)
            copName = rpad(copName, maxNameLen, " ")
            cop = pcc.pccCops[inds[ii]]
            copFam = displayShortString(cop)
            println("$copName : $copFam")
        end
    end
end

@doc doc"""
For a PCC-copula given by linear triangular indexing return its
respective name as string (for example: 1,3|4,5).
"""->
function getCopNam(ind::Int, nVars::Int, condSets::IntArrays)
    # get involved variables
    ind1, ind2 = triang2sub(nVars, ind)
    indFirst = min(ind1, ind2)
    indLast = max(ind1, ind2)

    # get conditioning set
    condSet = condSets[ind]
    
    if isempty(condSet)
        copName = "$indFirst,$indLast"
    else
        nCondVars = length(condSet)
        condSetSorted = sort(condSet)
        condSetString = "$(condSetSorted[1])"
        for ii=2:nCondVars
            condSetString = join([condSetString, ",", condSetSorted[ii]])
        end
        copName = "$indFirst,$indLast|$condSetString"
    end
    return copName
end

function getCopNam(ind::Int, pcc::PCC)
    condSets = Copulas.getCondSets(pcc.vine)
    nVars = dim(pcc)
    
    # get involved variables
    ind1, ind2 = triang2sub(nVars, ind)
    indFirst = min(ind1, ind2)
    indLast = max(ind1, ind2)

    # get conditioning set
    condSet = condSets[ind]
    
    if isempty(condSet)
        copName = "$indFirst,$indLast"
    else
        nCondVars = length(condSet)
        condSetSorted = sort(condSet)
        condSetString = "$(condSetSorted[1])"
        for ii=2:nCondVars
            condSetString = join([condSetString, ",", condSetSorted[ii]])
        end
        copName = "$indFirst,$indLast|$condSetString"
    end
    return copName
end

##############
## getindex ##
##############

import Base.getindex
@doc doc"""
Getindex functions called with i,j generally return the copula of i
and j. Therefore, subscript indices i and j need to be converted to
linear indexing of upper triangular matrices.
"""->

function getindex(pcc::PCC, ind1::Int64, ind2::Int64)
    # return pair copula for pair of variables
    n = dim(pcc)
    singleInd = []
    if ind1 < ind2
        singleInd = sub2triang(n, ind1, ind2)
    else
        singleInd = sub2triang(n, ind2, ind1)
    end
    return pcc.pccCops[singleInd]
end

import Base.setindex!
function setindex!(pcc::PCC, cop::PairCop,
                   ind1::Int64, ind2::Int64)
    # return pair copula for pair of variables
    n = dim(pcc)
    singleInd = []
    if ind1 < ind2
        singleInd = sub2triang(n, ind1, ind2)
    else
        singleInd = sub2triang(n, ind2, ind1)
    end
    pcc.pccCops[singleInd] = cop
end

function getParNot(pcc::PCC)
    return pcc.vine.trees
end

## conditional probability transforms
##-----------------------------------

function getPit(pcc::PCC, condVar::Int, condSet::Array{Int, 1})
    # get correct sequence of condSet
    vnStruct = getParNot(pcc)
    
    # get last variable in conditioning set
    sortedSet = sortCondSet(vnStruct[:, condVar], condSet)
    lastVar = sortedSet[end]

    ## create string for output
    condSetString = "$(sortedSet[1])"
    for ii=2:length(sortedSet)
        condSetString = join([condSetString, ",", sortedSet[ii]])
    end

    println("$condVar|$condSetString")
    if length(sortedSet) > 1
        # get conditional PITs of lower layer
        condVar_pit = getPit(pcc, condVar, sortedSet[1:end-1])
        lastVar_pit = getPit(pcc, lastVar, sortedSet[1:end-1])
    else
        condVar_pit = condVar
        lastVar_pit = lastVar
    end

    ## create string for output
    condSetString = []
    if length(sortedSet) == 1
        condSetString = ""
    else
        condSetString = "$(sortedSet[1])"
        for ii=2:(length(sortedSet)-1)
            condSetString = join([condSetString, ",", sortedSet[ii]])
        end
    end
    
    println("h($condVar,$lastVar|$condSetString)")
    # get copula
    ## vals = []
    ## if condVar < lastVar
    ##     cop = pcc.pairCops[condVar, lastVar]
    ##     vals = hfun(cop, condVar_pit, lastVar_pit)
    ## else
    ##     cop = pcc.pairCops[lastVar, condVar]
    ##     vals = vfun(cop, condVar_pit, lastVar_pit)
    ## end
    return condVar_pit
end

@doc doc"""
Find a given conditioning set in the tree of a variable given in
parent notation. If the conditioning set occurs, it will be returned
with the same sorting as it appears in the tree: the first entry is
directly connected to the root node. If the conditioning set is not
found, the function throws an error.

The algorithm first translates the tree in parent notation into a
`Tree`, which might be unnecessary and time consuming.

And alternative would be to search for the conditioning set directly
in parent notation. A conditioning set of length 3 could be found as a
sequence that arrives at the root node in the 4th step, with all steps
including nodes that are part of the conditioning set.
"""->
function sortCondSet(parNot::Array{Int, 1},
                     condSet::Array{Int, 1})
    tP = par2tree(parNot)
    
    nNodes = length(condSet)
    
    nPaths = length(tP)
    for ii=1:nPaths
        if length(tP[ii]) >= nNodes
            if issubset(condSet, tP[ii][1:nNodes])
                return tP[ii][1:nNodes]
            end
        end
    end
    error("Conditional set does not occur.")
end

## @doc doc"""
## First try for conditioning set search directly in parent notation.
## Function does not work!! For improvements, see the documentation of
## `sortCondSet`. 
## """->
## function sortCondSet2(parNot::Array{Int, 1},
##                      condSet::Array{Int, 1})
##     condSetSize = length(condSet)

##     fullPathFound = false
##     ii = 1
##     sequence = zeros(Int, condSetSize)

##     # iterate over variables in condSet
##     while (!fullPathFound) & (ii <= condSetSize)
##         atRoot = false
##         sequence[1] = condSet[ii]

##         # follow path of variable in parent notation
##         jj = 2
##         while (!atRoot) & (jj <= condSetSize)
##             sequence[jj] = parNot[sequence[jj-1]]
##             if sequence[jj] == 0
##                 atRoot = true
##             end
##             jj += 1
##         end
##         ii +=1

##         if !atRoot
##             if parNot[sequence[end]] == 0
##                 fullPathFound = true
##             end
##         end
##     end

##     if !fullPathFound
##         error("Conditioning set not found in given density
##         decomposition.")
##     end
##     return sequence
## end
