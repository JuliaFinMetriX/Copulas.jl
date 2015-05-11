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
type CTreePaths <: AbstractCTree
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

## dg function
##------------

@doc doc"""
Delegate functions to single field of composite type.
"""->
function dg(rt::CTreePaths)
    return rt.paths
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
type CTreeParRef <: AbstractCTree
    tree::Array{Int, 1}
end

## dg function
##------------

@doc doc"""
Delegate functions to single field of composite type.
"""->
function dg(rt::CTreeParRef)
    return rt.tree
end


#################
## conversions ##
#################

import Base.convert

## convert to CTreePaths
##----------------------

@doc doc"""
Convert parent referencing notation to tree paths notation.

The algorithm starts by finding all final nodes as those that are not
listed as parent node for any other variable. For the case of
incomplete trees, nodes not yet connected are encoded with a value of
-1. 
"""->
function convert(::Type{CTreePaths}, tr::CTreeParRef)
    parNot = tr.tree
    
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

function convert(::Type{CTreePaths}, tr::CTreePaths)
    return tr
end

function convert(::Type{CTreePaths}, tr::Array{Int, 1})
    trPar = CTreeParRef(tr)
    return convert(CTreePaths, trPar)
end

## convert to CTreeParRef
##-----------------------

@doc doc"""
Transform CTree given as list of paths to final nodes to parent
referencing notation. For parent referencing, generally all variables
from 1 to N should occur in the tree. However, even unfinished trees
are supported, and missing variables are denoted with a parent of -1.
To determine the last variable `convert` simply takes the maximum
value of occurring nodes in all paths.
"""->
function convert(::Type{CTreeParRef}, tr::CTreePaths, nVars::Int)
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


function convert(::Type{CTreeParRef}, tr::CTreePaths)
    nPaths = width(tr)
    nVars = maximum(Int[maximum(tr.paths[ii]) for ii=1:nPaths])
    nVars = maximum([tr.root, nVars])
    return convert(CTreeParRef, tr, nVars)
end

function convert(::Type{CTreeParRef}, tr::CTreeParRef)
    return tr
end


#######################
## display functions ##
#######################

import Base.Multimedia.display
@doc doc"""
All AbstractCTree subtypes will basically display identically, showing
all paths of the tree to the leaf nodes. However, they additionally
show their type first, so that different types still can be
distinguised. 
"""->
function displayInner(trPaths::CTreePaths)
    for ii=1:width(trPaths)
        println(join(["   ", string(trPaths.paths[ii])]))
    end
    return Nothing
end

## display AbstractCTree
function display(tr::AbstractCTree)
    println("type: $(typeof(tr))")
    trPaths = convert(CTreePaths, tr)
    displayInner(trPaths)
end

## CTree arrays
##-------------
function display(trArr::Array{AbstractCTree, 1})
    ## convert to array of CTreePaths and display that
    nTrees = length(trArr)
    for ii=1:nTrees
        println("type: $(typeof(trArr[ii]))")
        currTree = convert(CTreePaths, trArr[ii])
        println("$(currTree.root):")
        displayInner(currTree)
    end
end

function display(trArr::Array{CTreePaths, 1})
    ## convert to array of CTreePaths and display that
    nTrees = length(trArr)
    for ii=1:nTrees
        currTree = trArr[ii]
        println("type: $(typeof(currTree))")
        println("$(currTree.root):")
        displayInner(currTree)
    end
end

function display(trArr::Array{CTreeParRef, 1})
    ## convert to array of CTreePaths and display that
    nTrees = length(trArr)
    for ii=1:nTrees
        println("type: $(typeof(trArr[ii]))")
        currTree = convert(CTreePaths, trArr[ii])
        println("$(currTree.root):")
        displayInner(currTree)
    end
end

#########################
## dimension functions ##
#########################

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
`Int` length of the longest path of a `CTree` object.
"""->
function maxDepth(tr::CTreePaths)
    return maxDepth(tr.paths)
end

function maxDepth(tr::AbstractCTree)
    trPaths = convert(CTreePaths, tr)
    return maxDepth(trPaths)
end

@doc doc"""
`Array{Int, 1}` with depths / lengths to each final node in a tree.
"""->
function getDepths(tr::CTreePaths)
    nPaths = width(tr)
    depths = Array(Int, nPaths)
    for ii=1:nPaths
        depths[ii] = length(tr.paths[ii])
    end
    return depths
end

function getDepths(tr::AbstractCTree)
    trPaths = convert(CTreePaths, tr)
    return getDepths(trPaths)
end

@doc doc"""
`Int` number of different paths / leaf nodes of a given CTree.
"""->
function width(tr::CTreePaths)
    return length(tr.paths)
end

function width(tr::AbstractCTree)
    trPaths = convert(CTreePaths, tr)
    return width(trPaths)
end


########################
## check for equality ##
########################
@doc doc"""
For equality to hold both CTrees must have equal representation
(type). Besides, root node and paths must be identical.
"""->
function ==(tr1::CTreePaths, tr2::CTreePaths)
    return (tr1.root == tr2.root) & (tr1.paths == tr2.paths)
end

function ==(tr1::AbstractCTree, tr2::AbstractCTree)
    if typeof(tr1) != typeof(tr2)
        return false
    else
        trPaths1 = convert(CTreePaths, tr1)
        trPaths2 = convert(CTreePaths, tr2)
        return ==(trPaths1, trPaths2)
    end
end


##############
## getindex ##
##############

import Base.getindex

function getindex(tr::CTreePaths, pathInd::Int, pathNode::Int)
    ## single entry
    return tr.paths[pathInd][pathNode]
end

function getindex(tr::CTreePaths, pathInd::Int)
    ## single path
    return tr.paths[pathInd]
end

function getindex(tr::CTreePaths, pathInds::Array{Int, 1},
                  pathNodes::Array{Int, 1})
    ## multiple values, sorted, only unique entries
    nVals = length(pathInds)
    if nVals != length(pathNodes)
        error("index arrays must be of equal length")
    end
    vals = Array(Int, nVals)
    for ii=1:nVals
        vals[ii] = tr[pathInds[ii], pathNodes[ii]]
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
function allNodes(tr::CTreePaths)
    vals = [tr.root, [tr.paths...]]
    return sort(unique(vals))
end

function allNodes(tr::CTreeParRef)
    return sum(tr.tree >= 0)
end

function allNodes(tr::AbstractCTree)
    trPar = convert(CTreeParRef, tr)
    return allNodes(trPar)
end

@doc doc"""
`Array{Int, 1}` of all occurring values in a tree, excluding the root
node. 
"""->
function allPathNodes(tr::CTreePaths)
    vals = [[tr.paths...]]
    return sort(unique(vals))
end

function allPathNodes(tr::CTreeParRef)
    return sum(tr.tree > 0)
end

function allPathNodes(tr::AbstractCTree)
    trPar = convert(CTreeParRef, tr)
    return allPathNodes(trPar)
end


#############
## condSet ##
#############

@doc doc"""
`Bool` indicating whether a given conditional set `Array{Int, 1}`
occurs at the beginning of any path of a `CTreePaths` instance. Note that
the exact order of numbers within the conditional set does not matter. 

## Example

tr = Copulas.CTreePaths(6, [1 2 3], [1 2 4], [5 3])
@test Copulas.condSetChk([2, 1], tr)
@test !(Copulas.condSetChk([2, 4], tr))

"""->
function condSetChk(arr::Array{Int, 1}, tr::CTreePaths)
    ## does conditional set occur at beginning of some path?
    nNodes = length(arr)
    
    nPaths = length(tr)
    for ii=1:nPaths
        if length(tr[ii]) >= nNodes
            if issubset(arr, tr[ii][1:nNodes])
                return true
            end
        end
    end
    return false
end

function condSetChk(arr::Array{Int, 1}, tr::AbstractCTree)
    trPaths = convert(CTreePaths, tr)
    return condSetChk(trPaths)
end

#############
## attach! ##
#############

@doc doc"""
Attach new node to unfinished conditioning tree of type CTreePaths
with given conditioning set.
"""->
function attach!(tr::CTreePaths, newNode::Int, condSet::Array{Int, 1})
    nPaths = width(tr)
    nNodes = length(condSet)
    for ii=1:nPaths
        path = tr.paths[ii]
        if length(path) >= nNodes
            if issubset(condSet, path[1:nNodes])
                if length(path) == nNodes
                    ## attach to path
                    push!(path, newNode)
                    break
                else
                    ## new path
                    condSetSorted = path[1:nNodes]
                    newPath = [condSetSorted, newNode]
                    push!(tr.paths, newPath)
                    break
                end
            end
        end
    end
    ## resort arrays
    nPaths = length(tr.paths)
    pathsSorted = sortPaths(tr.paths)
    for ii=1:nPaths
        tr.paths[ii] = pathsSorted[ii]
    end
end

function attach!(tr::CTreePaths, newNode::Int, xx::Array{None,1})
    attach!(tr, newNode, Array(Int, 0))
end
