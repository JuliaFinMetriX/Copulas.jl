abstract AbstractCTree
typealias IntArrays Array{Array{Int, 1}, 1}

################
## CTreePaths ##
################

@doc doc"""
CTree representation as array of individual paths to leaf nodes. Each
possible path to a final node is stored as an individual `Array{Int,
1}`, while the root node is stored separately in `root`. Paths
generally have different lengths, so that they are not stored as
`Array{Int, 2}`.

- `root`::Int

- `paths`::Array{Array{Int, 1}, 1}

Paths will be stored in lexicographical order.

## Constructor

````julia
CTreePaths(3, [1, 2], [1, 4], [5], [6, 7])
````
"""->
type CTreePaths
    root::Int
    paths::IntArrays
    
    function CTreePaths(rt::Int, paths::IntArrays)
        ## constraints: paths need to be sorted lexicographically
        pathsSorted = sortPaths(paths)
        return new(rt, pathsSorted)
    end
end

## only temporary
typealias Tree CTreePaths

##################
## constructors ##
##################

## construction with individual paths as variable arguments
function CTreePaths(rt::Int, paths...)
    ## paths need to be Array{Int, 1} or Array{Int, 2}
    nPaths = length(paths)
    ps = Array(Array{Int, 1}, nPaths)
    for ii=1:nPaths
        ps[ii] = paths[ii][:]
    end
    return CTreePaths(rt, ps)
end


####################
## CondTreeParRef ##
####################
@doc doc"""
CTree representation in parent reference notation. `tree` is an
`Array{Int, 1}`, where entry ii denotes the single parent of node ii.
The root node is indicated with parent 0, while not yet connected
nodes have parent -1.
"""->
type CTreeParRef
    tree::Array{Int, 1}
end





#################
## conversions ##
#################

import Base.convert

@doc doc"""
Convert parent referencing notation to tree paths notation.

The algorithm starts by finding all final nodes as those that are
listed as parent node for any other variable. For the case of
incomplete trees, nodes not yet connected are encoded with a value of
-1. 
"""->
function convert(::Type{CTreePaths}, tr::CTreeParRef)
    parNot = tr.trees
    
    nVars = length(parNot)
    
    ## find notes without children
    childlessNodes = setdiff([1:nVars], parNot)
    
    ## exclude nodes that do not appear at all
    notAppearingNodes = find(parNot .== -1)
    
    endNodes = setdiff(childlessNodes, notAppearingNodes)
    
    nPaths = length(endNodes)
    
    ## preallocate array of arrays
    treePaths = Array(Array{Int, 1}, nPaths)
    
    rootNode = -1
    for ii=1:nPaths
        currPath = Array(Int, 1)
        currPath[1] = endNodes[ii]
        belowRoot = true
        
        ## walk along path
        while belowRoot
            parentNode = parNot[currPath[end]]
            if parentNode == 0
                belowRoot = false
            else
                append!(currPath, [parentNode])
            end
        end
        rootNode = currPath[end]
        treePaths[ii] = flipud(currPath)[2:end]
    end
    
    return CTreePaths(rootNode, treePaths)
end

@doc doc"""
Transform CTree given as list of paths to final nodes to parent
referencing notation. For parent referencing, generally all variables
from 1 to N should occur in the tree. However, even unfinished trees
are supported, and missing variables are denoted with a parent of -1.
To determine the last variable `convert` simply takes the maximum
value of occurring nodes in all paths.
"""->
function convert(::type{CTreeParRef}, tr::CTreePaths, nVars::Int)
    ## transform single tree to parent notation vector
    parNot = -1*ones(Int, nVars)
    parNot[tr.root] = 0

    nPaths = length(tr.paths)
    
    for ii=1:nPaths
        currPath = tr.paths[ii]
        nNodes = length(currPath)
        parNot[currPath[1]] = tr.root
        
        for jj=1:(nNodes-1)
            ## get parent for each node
            parNot[currPath[end+1-jj]] = currPath[end-jj]
        end
    end
    return CTreeParRef(parNot)
end


function convert(::type{CTreeParRef}, tr::CTreePaths)
    nPaths = length(tr.paths)
    nVars = maximum(Int[maximum(tr.paths[ii]) for ii=1:nPaths])
    return convert(CTreeParRef, tr, nVars)
end


#######################
## display functions ##
#######################


import Base.Multimedia.display
@doc doc"""Customized display for `CTreePaths` instances."""->
function display(tP::CTreePaths)
    println("Root node: $(tP.root)")
    for ii=1:length(tP)
        println(join(["   ", string(tP.paths[ii])]))
    end
    return Nothing
end

@doc doc"""Customized display for arrays of `CTreePaths` instances."""->
function display(tPArr::Array{CTreePaths, 1})
    nTrees = length(tPArr)
    for ii=1:nTrees
        println("")
        println("$(tPArr[ii].root):")
        for jj=1:length(tPArr[ii])
            println(join(["   ", string(tPArr[ii].paths[jj])]))
        end
    end
    return Nothing
end

######################
## length functions ##
######################

@doc doc"""
`Int` length of the longest path of an `Array` of paths. 
"""->
function maxDepth(paths::IntArrays)
    maxD = 0
    for ii=1:length(paths)
        currLength = length(paths[ii])
        if currLength > maxD
            maxD = currLength
        end
    end
    return maxD
end

@doc doc"""
`Int` length of the longest path of a `CTreePaths` object.
"""->
function maxDepth(tP::CTreePaths)
    return maxDepth(tP.paths)
end

import Base.length
@doc doc"""
`Int` number of paths for a given `CTreePaths` instance.
"""->
function length(tP::CTreePaths)
    return length(tP.paths)
end

@doc doc"""
`Array{Int, 1}` with depths / lengths to each final node in a tree.
"""->
function getDepths(tP::CTreePaths)
    nPaths = length(tP)
    depths = Array(Int, nPaths)
    for ii=1:nPaths
        depths[ii] = length(tP.paths[ii])
    end
    return depths
end

########################
## check for equality ##
########################
@doc doc"""
`Bool` comparing root node and tree paths for equality.
"""->
function ==(tP1::CTreePaths, tP2::CTreePaths)
    return (tP1.root == tP2.root) & (tP1.paths == tP2.paths)
end

##############
## getindex ##
##############

import Base.getindex

function getindex(tP::CTreePaths, pathInd::Int, pathNode::Int)
    ## single entry
    return tP.paths[pathInd][pathNode]
end

function getindex(tP::CTreePaths, pathInd::Int)
    ## single path
    return tP.paths[pathInd]
end

function getindex(tP::CTreePaths, pathInds::Array{Int, 1},
                  pathNodes::Array{Int, 1})
    ## multiple values, sorted, only unique entries
    nVals = length(pathInds)
    if nVals != length(pathNodes)
        error("index arrays must be of equal length")
    end
    vals = Array(Int, nVals)
    for ii=1:nVals
        vals[ii] = tP[pathInds[ii], pathNodes[ii]]
    end
    return sort(unique(vals))
end

#############
## allVals ##
#############

@doc doc"""
`Array{Int, 1}` of all occurring values in a tree, including the root
node. 
"""->
function allVals(tP::CTreePaths)
    vals = [tP.root, [tP.paths...]]
    return sort(unique(vals))
end

@doc doc"""
`Array{Int, 1}` of all occurring values in a tree, excluding the root
node. 
"""->
function allPathVals(tP::CTreePaths)
    vals = [[tP.paths...]]
    return sort(unique(vals))
end

#############
## condSet ##
#############

@doc doc"""
`Bool` indicating whether a given conditional set `Array{Int, 1}`
occurs at the beginning of any path of a `CTreePaths` instance. Note that
the exact order of numbers within the conditional set does not matter. 

## Example

tP = Copulas.CTreePaths(6, [1 2 3], [1 2 4], [5 3])
@test Copulas.condSetChk([2, 1], tP)
@test !(Copulas.condSetChk([2, 4], tP))

"""->
function condSetChk(arr::Array{Int, 1}, tP::CTreePaths)
    ## does conditional set occur at beginning of some path?
    nNodes = length(arr)
    
    nPaths = length(tP)
    for ii=1:nPaths
        if length(tP[ii]) >= nNodes
            if issubset(arr, tP[ii][1:nNodes])
                return true
            end
        end
    end
    return false
end
