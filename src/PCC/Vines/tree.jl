type Tree
    root::Int
    paths::IntArrays

    function Tree(rt::Int, paths::IntArrays)
        ## constraints: paths need to be sorted lexicographically
        pathsSorted = sortPaths(paths)
        return new(rt, pathsSorted)
    end
end

##################
## constructors ##
##################

## construction with individual paths as variable arguments
function Tree(rt::Int, paths...)
    ## paths need to be Array{Int, 1} or Array{Int, 2}
    nPaths = length(paths)
    ps = Array(Array{Int, 1}, nPaths)
    for ii=1:nPaths
        ps[ii] = paths[ii][:]
    end
    return Tree(rt, ps)
end

#######################
## display functions ##
#######################

import Base.Multimedia.display
function display(tP::Tree)
    println("Root node: $(tP.root)")
    for ii=1:length(tP)
        println(join(["   ", string(tP.paths[ii])]))
    end
    return Nothing
end

function display(tPArr::Array{Tree, 1})
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

function maxDepth(tP::Tree)
    return maxDepth(tP.paths)
end

import Base.length
function length(tP::Tree)
    return length(tP.paths)
end

function getDepths(tP::Tree)
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

function ==(tP1::Tree, tP2::Tree)
    return (tP1.root == tP2.root) & (tP1.paths == tP2.paths)
end

##############
## getindex ##
##############

import Base.getindex

function getindex(tP::Tree, pathInd::Int, pathNode::Int)
    ## single entry
    return tP.paths[pathInd][pathNode]
end

function getindex(tP::Tree, pathInd::Int)
    ## single path
    return tP.paths[pathInd]
end

function getindex(tP::Tree, pathInds::Array{Int, 1},
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

function allVals(tP::Tree)
    vals = [tP.root, [tP.paths...]]
    return sort(unique(vals))
end

function allPathVals(tP::Tree)
    vals = [[tP.paths...]]
    return sort(unique(vals))
end

#############
## condSet ##
#############

function condSetChk(arr::Array{Int, 1}, tP::Tree)
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
