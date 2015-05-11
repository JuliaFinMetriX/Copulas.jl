@doc doc"""
Representation of a specific conditional density decomposition. A
`Vine` basically stores an `Array` of `Tree` instances, where each
`Tree` represents all univariate conditional information sets of a
given variable. For reasons of memory efficiency, individual trees are
not stored as `Array{Tree, 1}`, but each tree is stored as a single
column in a `Array{Int, 2}` matrix as what I call parent notation.
That is, entry [ii, jj] denotes the parent of variable ii in the
conditional information set tree of variable jj.

For future extension a `Vine` instance also comprises field `names`. 

- trees::Array{Int, 2}

- names::Array{T, 1}

Matrix `trees` must be square.
"""->
type Vine{T}
    trees::Array{Int, 2}
    names::Array{T, 1}

    function Vine(tr::Array{Int, 2}, names::Array{T, 1})
        ## test symmetry
        if !(size(tr,1) == size(tr,2) == length(names))
            error("tree matrix columns and rows and names must be of
same size")
        end
        return new(tr, names)
    end
end

##################
## constructors ##
##################

function Vine{T}(tr::Array{Int, 2}, names::Array{T, 1})
    return Vine{T}(tr, names)
end

function Vine(tr::Array{Int, 2})
    nVars = size(tr, 1)
    return Vine(tr, [1:nVars])
end

function Vine(trs::Array{AbstractCTree, 1})
    nTrees = length(trs)
    parNot = Array(Int, nTrees, nTrees)
    for ii=1:nTrees
        currTree = convert(CTreeParRef, trs[ii])
        parNot[:, ii] = currTree.tree
    end
    return Vine(parNot, [1:nTrees])
end

function Vine(trs::Array{CTreePaths, 1})
    nTrees = length(trs)
    parNot = Array(Int, nTrees, nTrees)
    for ii=1:nTrees
        currTree = convert(CTreeParRef, trs[ii], nTrees)
        parNot[:, ii] = currTree.tree
    end
    return Vine(parNot, [1:nTrees])
end

function Vine(trs::Array{CTreeParRef, 1})
    nTrees = length(trs)
    parNot = Array(Int, nTrees, nTrees)
    for ii=1:nTrees
        currTree = convert(CTreeParRef, trs[ii])
        parNot[:, ii] = currTree.tree
    end
    return Vine(parNot, [1:nTrees])
end

## dg function
##------------

function dg(vn::Vine)
    return dg.trees
end

#############
## display ##
#############

import Base.Multimedia.display
@doc doc"""
Transform columns of parent notation matrix to tree instances and
display individual conditioning trees.
"""->
function display(vn::Vine)
    ## transform to Tree array

    nVars = size(vn.trees, 1)
    
    vineTrees = Array(CTreePaths, nVars)
    for ii=1:nVars
        trPar = CTreeParRef(vn.trees[:, ii])
        vineTrees[ii] = convert(CTreePaths, trPar)
    end
    println("VINE of $nVars variables:")
    println("")
    display(vn.trees)
    println("In TREE notation:")
    display(vineTrees)
end

##############
## equality ##
##############

function ==(vn1::Vine, vn2::Vine)
    return vn1.trees == vn2.trees
end

################
## conversion ##
################

import Base.convert
function convert(::Type{CTreePaths}, vn::Vine)
    nVars = size(vn.trees, 1)
    trees = Array(CTreePaths, nVars)
    for ii=1:nVars
        trees[ii] = convert(CTreePaths, vn.trees[:, ii])
    end
    return trees
end

function convert(::Type{Vine}, trArr::Array{CTreePaths, 1})
    nVars = length(trArr)
    vnTrees = Array(Int, nVars, nVars)
    for ii=1:nVars
        trPar = convert(CTreeParRef, trArr[ii])
        vnTrees[:, ii] = trPar.tree
    end
    return Vine(vnTrees)
end

##############
## analysis ##
##############

@doc doc"""
Array{Array{Int, 1}, 1} of all possible simulation sequences given
that the variables of `condSet` are already known.

WARNING: no unit tests.
"""->
function getSimSequences(vn::Vine, condSet::Array{Int, 1})
    ## find possible simulation variable sequences

    ## transform vine to array of trees
    trees = vine2trees(vn)

    ## get remaining variables to be simulated
    nVars = size(vn.trees, 1)

    ## preallocation
    condSetList = Array(Array{Int, 1}, 1)
    condSetList[1] = condSet
    
    ## partialSequences = Array(Array{Int, 1}, 0)
    simSequences = Array(Array{Int, 1}, 0)

    ## algorithm:
    ## - take last element of list
    ## - get missing variables
    ## - run through missing variables
    ## - add matching variables to condList
    ## - finished?

    while !isempty(condSetList)
        currentCondSet = pop!(condSetList)
        println("Current condition set: $currentCondSet")
        
        toSim = setdiff([1:nVars], currentCondSet)
        nRemaining = length(toSim)

        for ii=1:nRemaining
            missingVar = toSim[nRemaining+1-ii]
            if condSetChk(currentCondSet, trees[missingVar])
                ## add to list
                newCondSet = [currentCondSet, missingVar]
                println("New condition set: $newCondSet")
                if length(newCondSet) == nVars
                    push!(simSequences, [newCondSet])
                    println("New simulation sequence found!")
                else
                    push!(condSetList, [newCondSet])
                    ## display(condSetList)
                end
            end
        end
    end
    return simSequences
end

@doc doc"""
`Array{Array{Int, 1}, 1}` of all possible simulation sequences for a
given vine.

WARNING: no unit tests.
"""->
function getSimSequences(vn::Vine)
    ## get all variable sequences for simulation
    nVars = size(vn.trees, 1)
    simSequences = Array(Array{Int, 1}, 0)
    for ii=1:nVars
        newSequ = getSimSequences(vn, [ii])
        simSequences = [simSequences, newSequ]
    end
    return simSequences
end

@doc doc"""
Evaluating the result of `getSimSequences`: for each variable find its
average position in the sequences of simulation. This could be an
indicator of how central a given variable is, and where it should be
plotted in a visualization of vines. Also, variables that can be
observed earlier should probably get an earlier average position in
the simulation sequences.

WARNING: no unit tests.
"""->
function avgSimSequPosition(simSequ::IntArrays)
    ## whats the average position of a variable during simulation? 
    nVars = length(simSequ[1])
    nSequ = length(simSequ)
    avgPos = Array(Float64, nVars)
    println("")
    for ii=1:nVars
        val = 0
        for jj=1:nSequ
            val = val + find(ii .== simSequ[jj])[1]
        end
        avgVal = val/nSequ
        avgPos[ii] = avgVal
        println("$ii: $avgVal")
    end
    println("")
    return avgPos
end

@doc doc"""
`Array{Int, 2}` square matrix with level of layers where each pairs of
variables are connected. A number of 1 denotes pairs that are
connected unconditionally, while a number of 3 denotes pairs that are
connected with a conditioning set of size 2.

WARNING: no unit tests.
"""->
function linkLayers(vn::Vine)
    ## at which layer are links between variables modelled? 
    nVars = size(vn.trees, 1)
    links = zeros(Int, nVars, nVars)
    for ii=1:(nVars-1)
        root = ii
        for jj=(ii+1):nVars
            # follow jj in column ii to root
            notAtRoot = true
            steps = 0
            currNode = jj
            while notAtRoot
                steps = steps + 1
                currNode = vn.trees[currNode, ii]
                if currNode == root
                    notAtRoot = false
                end
            end
            links[jj, ii] = steps
            links[ii, jj] = steps
        end
    end
    return links
end

@doc doc"""
Get the conditioning sets for all pairs of variables. Conditioning
sets are given in the order of linear triangular indexing. Each
conditioning set is sorted such that it represents the conditioning
set for the variable with smaller index.
"""->
function getAllCopCondSets(vn::Vine)
    nVars = size(vn.trees, 1)
    nSets = sum((nVars-1):-1:1)

    condSets = Array(Array{Int, 1}, nSets)
    ind = 1
    for ii=1:(nVars-1)
        root = ii
        for jj=(ii+1):nVars
            path = getPathToRoot(CTreeParRef(vn.trees[:, ii]), jj)
            currCondSet = flipud(path)
            condSets[ind] = currCondSet
            ind += 1
        end
    end
    return condSets
end

@doc doc"""
Get both conditioning sets for all pairs of variables. That is, the
first output returns the conditioning sets in correct order for the
smaller variable, while the second output has them ordered for the
larger variable.
"""->
function getAllVarCondSets(vn::Vine)
    nVars = size(vn.trees, 1)
    nSets = sum((nVars-1):-1:1)

    condSets1 = Array(Array{Int, 1}, nSets)
    condSets2 = Array(Array{Int, 1}, nSets)
    ind = 1
    for ii=1:(nVars-1)
        root = ii
        for jj=(ii+1):nVars
            path = getPathToRoot(CTreeParRef(vn.trees[:, ii]), jj)
            condSets1[ind] = flipud(path)
            path = getPathToRoot(CTreeParRef(vn.trees[:, jj]), ii)
            condSets2[ind] = flipud(path)
            ind += 1
        end
    end
    return (condSets1, condSets2)
end

@doc doc"""
Get the conditioning set for variables `var1` and `var2`. More
specific, if var1, var2|k, l, m, then return conditioning set {k,l,m}
such that the order matches the requirement to calculate var1|k,l,m.
"""->
function getCondSet(vn::Vine, var1::Int, var2::Int)
    parNot = vn.trees[:, var1]
    trPar = CTreeParRef(parNot)
    pathToVar1 = getPathToRoot(trPar, var2)
    return flipud(pathToVar1)
end

@doc doc"""
For tree given in parent notation, get full path from variable `var`
to root node. Path does neither include `var` nor `root`. The first
element is connected to `var`, the last one to `root`.
"""->
function getPathToRoot(tr::CTreeParRef, var::Int)
    parNot = tr.tree
    rootNode = find(parNot .== 0)[1]
    notAtRoot = true
    path = Int[]
    currVar = var
    while notAtRoot
        currVar = parNot[currVar]
        if currVar == rootNode
            notAtRoot = false
        else
            push!(path, currVar)
        end
    end
    return path
end

function getPathToRoot(tr::AbstractCTree, var::Int)
    trPar = convert(CTreeParRef, tr)
    return getPathToRoot(trPar, var)
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
function findAndSortCondSet(tr::CTreeParRef,
                     condSet::Array{Int, 1})
    trPar = convert(CTreePaths, tr)
    
    nNodes = length(condSet)
    
    nPaths = width(trPar)
    for ii=1:nPaths
        if length(trPar[ii]) >= nNodes
            if issubset(condSet, trPar[ii][1:nNodes])
                return trPar[ii][1:nNodes]
            end
        end
    end
    error("Conditional set does not occur.")
end

## @doc doc"""
## First try for conditioning set search directly in parent notation.
## Function does not work!! For improvements, see the documentation of
## `findAndSortCondSet`. 
## """->
## function findAndSortCondSet2(parNot::Array{Int, 1},
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
