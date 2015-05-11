######################
## type declaration ##
######################

@doc doc"""
RVMatrix constructor. RVMatrix must be a lower triangular matrix with
certain properties.
"""->
type RVMatrix
    matrix::Array{Int, 2}
    function RVMatrix(x::Array{Int, 2})
        if !istril(x)
            error("matrix must be triangular")
        end
        chkColumnSubsets(x)
        return new(x)
    end
end

## contructor helper function
##---------------------------

function chkColumnSubsets(x::Array{Int, 2})
    nVars = size(x, 1)
    for ii=nVars:-1:2
        if !(Set(x[ii:nVars, ii]) == Set(x[ii:nVars, ii-1]))
            error("column entries must be contained in column to the left")
        end
    end
    for ii=1:nVars-1
        if issubset(x[ii, ii], Set(x[ii+1:end, ii]))
            error("diagonal entries may not occur elsewhere in column")
        end
    end
    return true
end

################
## conversion ##
################

import Base.convert

function convert(::Type{RVMatrix}, vn::Vine)
    ## get number of variables
    nVars = size(vn.trees, 1)
    
    ## init RVMatrix
    rmatr = zeros(Int, nVars, nVars)
    
    ## convert vn to array of CTreePaths
    paths = convert(Copulas.CTreePaths, vn)
    
    ## set current column
    for ii=1:(nVars-1)
        ## find longest conditioning tree
        indMaxDepth = findMaxDepth(paths)
        
        ## current root
        currTree = paths[indMaxDepth]
        rt = currTree.root

        ## write down root
        rmatr[ii, ii] = rt

        ## get longest path of current tree
        longestPath = getLongestPath(currTree)
        rmatr[ii+1:end, ii] = flipud(longestPath)

        ## eliminate current root
        paths = allExcept(paths, indMaxDepth)

        ## eliminate root from each tree
        for jj=1:length(paths)
            for ll=1:length(dg(paths[jj]))
                if !isempty(dg(paths[jj])[ll])
                    if dg(paths[jj])[ll][end] == rt
                        pop!(dg(paths[jj])[ll])
                    end
                end
            end
        end
    end
    rmatr[end, end] = paths[1].root
    return RVMatrix(rmatr)
end

function convert(::Type{Copulas.Vine}, rmat::Copulas.RVMatrix)
    
    rmatr = dg(rmat)
    nVars = size(rmatr, 1)
    ## paths = Array(Array{Array{Int, 1}, 1}, nVars)
    paths = Array(Copulas.CTreePaths, nVars);
    for ii=1:(nVars-1)
        rt = rmatr[ii, ii]
        kk = Array(Array{Int, 1}, 0)
        push!(kk, flipud(rmatr[(ii+1):end, ii]))
        paths[rt] = Copulas.CTreePaths(rt, kk)
    end

    ## already include unconditional link for last node
    kk = Array(Array{Int, 1}, 0)
    push!(kk, [rmatr[nVars-1, nVars-1]])
    paths[rmatr[nVars, nVars]] = Copulas.CTreePaths(rmatr[nVars, nVars], kk)

    ## horizontal values

    ## unconditional links
    for ll=1:(nVars-2)
        rt = rmatr[nVars, ll]
        otherNode = rmatr[ll, ll]
        ## push!(paths[rt], [otherNode])
        Copulas.attach!(paths[rt], otherNode, [])
    end

    for jj=(nVars-1):-1:2
        for ll=1:(jj-1)
            rt = rmatr[jj, ll]
            otherNode = rmatr[ll, ll]
            condSet = rmatr[(jj+1):end, ll]
            Copulas.attach!(paths[rt], otherNode, condSet)
        end
    end

    display(paths)
    
    vnParRef = Array(Int, nVars, nVars)
    for ii=1:nVars
        kk = convert(Copulas.CTreeParRef, paths[ii])
        vnParRef[:, ii] = dg(kk)
    end
    vn = Copulas.Vine(vnParRef)
    return vn
end

@doc doc"""
Eliminate a single entry from an array of CTreePaths instances.
"""->
function allExcept(paths::Array{Copulas.CTreePaths,1}, ind)
    nPaths = length(paths)
    takeElems = trues(nPaths)
    takeElems[ind] = false
    return paths[takeElems]
end

@doc doc"""
For an array of conditioning trees find the first tree which has
maximum depth.
"""->
function findMaxDepth(ctrs::Array{Copulas.CTreePaths,1})
    depths = Int[Copulas.maxDepth(ctrs[ii]) for ii=1:size(ctrs, 1)]
    return indmax(depths)
end

@doc doc"""
For a given conditioning tree get the first path which has the maximum
path length.
"""->
function getLongestPath(ctr::Copulas.CTreePaths)
    maxDep = Copulas.maxDepth(ctr)
    isMaxDep = Bool[length(path) == maxDep for path in dg(ctr)]
    ind = find(isMaxDep)[1]
    return dg(ctr)[ind]
end

@doc doc"""
Delegate functions to single field of composite type.
"""->
function dg(rvm::RVMatrix)
    return rvm.matrix
end
