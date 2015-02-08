#######################
## sorting utilities ##
#######################

function sortPaths(paths::Array{Array{Int, 1}, 1})
    pathsArr = tree2arr(paths)
    sortedArr = sortcols(pathsArr)
    return paths = arr2tree(sortedArr)
end

## write tree paths as matrix
##---------------------------

## in order to make use of built-in lexicographic sorting functions,
## tree paths are written as a matrix. that is, the paths of type
## Array{Array{Int, 1}, 1} are extended to same lengths by appending
## zeros. this is not a conversion to parent notation!

function tree2arr(paths::Array{Array{Int, 1}, 1})
    ## transform array of array into matrix, filling empty fields with
    ## zero
    nRows = maxDepth(paths)
    vals = zeros(Int, nRows, length(paths))
    for ii=1:length(paths)
        nVals = length(paths[ii])
        vals[1:nVals, ii] = paths[ii]
    end
    return vals
end

function arr2tree(arr::Array{Int, 2})
    ## remove trailing zeros
    maxDepth, nPaths = size(arr)
    paths = Array(Array{Int, 1}, nPaths)
    for ii=1:nPaths
        currPath = arr[:, ii]
        noZeros = (currPath .!= 0)
        if !isa(noZeros, Array)
            paths[ii] = [currPath[noZeros]]
        else
            paths[ii] = currPath[noZeros]
        end
    end
    return paths
end

##########################
## conversion functions ##
##########################

function par2tree(parNot::Array{Int, 1})
    ## transform single parent notation column to tree

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

    return Tree(rootNode, treePaths)
end

function par2tree(parNot::Array{Int, 2})
    ## transform parent notation matrix to array of trees
    nVars = size(parNot, 2)
    trees = Array(Tree, nVars)
    for ii=1:nVars
        trees[ii] = par2tree(parNot[:, ii])
    end
    return trees
end

function tree2par(tP::Tree, nVars::Int)
    ## transform single tree to parent notation vector
    parNot = -1*ones(Int, nVars)
    parNot[tP.root] = 0

    nPaths = length(tP.paths)
    
    for ii=1:nPaths
        currPath = tP.paths[ii]
        nNodes = length(currPath)
        parNot[currPath[1]] = tP.root
        
        for jj=1:(nNodes-1)
            ## get parent for each node
            parNot[currPath[end+1-jj]] = currPath[end-jj]
        end
    end
    return parNot
end

function tree2par(tPs::Array{Tree, 1}, nVars::Int)
    ## transform array of trees to parent notation matrix
    parNot = Array(Int, nVars, nVars)
    for ii=1:nVars
        parNot[:, ii] = tree2par(tPs[ii], nVars)
    end
    return parNot
end

function vine2trees(vn::Vine)
    return par2tree(vn.trees)
end

function trees2vine(trs::Array{Tree, 1}, nVars::Int)
    return Vine(tree2par(trs, nVars))
end
#########################
## unit test utilities ##
#########################

function testvine(number::Int)
    if number == 1
        ## dvine
        kk = [0 2 2 2 2 2;
              1 0 3 3 3 3;
              2 2 0 4 4 4;
              3 3 3 0 5 5;
              4 4 4 4 0 6;
              5 5 5 5 5 0]
        vn = Copulas.Vine(kk)
    elseif number == 2
        kk = [0 3 3 3 3 3;
              3 0 3 5 5 5;
              1 2 0 2 2 2;
              5 5 5 0 5 6;
              2 2 2 4 0 4;
              4 4 4 4 4 0]
        vn = Copulas.Vine(kk)
    elseif number == 3
        kk = [0 2 5 4 2 5;
              1 0 3 1 5 3;
              5 2 0 5 2 6;
              1 1 1 0 1 1;
              2 2 2 2 0 2;
              3 3 3 3 3 0]
        vn = Copulas.Vine(kk)
    elseif number == 4
        p1 = Copulas.Tree(1, [2 3 4], [2 3 6 7], [2 3 5])
        p2 = Copulas.Tree(2, [1], [3 6 7], [3 4], [5])
        p3 = Copulas.Tree(3, [2 1], [2 5], [4], [6 7])
        p4 = Copulas.Tree(4, [3 2 1 5 6 7])
        p5 = Copulas.Tree(5, [2 3 1 4], [2 3 1 6 7])
        p6 = Copulas.Tree(6, [3 2 1 5 4], [7])
        p7 = Copulas.Tree(7, [6 3 2 1 5 4])
        parNot = Copulas.tree2par([p1, p2, p3, p4, p5, p6, p7], 7)
        vn = Copulas.Vine(parNot)
    elseif number == 5
        ## factors 5 and 6 with 2 lags (5 with 1 and 3)
        ## 7, 8, 9 and 10 linked to factor 5
        ## 11, 12, 13 and 14 linked to factor 6
        ## no simulation with 1, 2, 3 and 4 given
        trs = [Copulas.Tree(1, [3,5,6,4,2,14,13,12,11],
                          [3,5,6,7,8,9,10]); 
               Copulas.Tree(2, [4,6,5,3,1,7,8,9,10],
                          [4,6,5,14,13,12,11]); 
               Copulas.Tree(3, [1], [5,6,4,2,14,13,12,11], [5,6,7],
                          [5,6,8], [5,6,9], [5,6,10]);
               Copulas.Tree(4, [2], [6,5,3,1,7,8,9,10], [6,5,11],
                          [6,5,12], [6,5,13], [6,5,14]);
               Copulas.Tree(5, [3,1], [6,4,2], [6,11], [6,12],
                          [6,13], [6,14], [7], [8], [9], [10]);
               Copulas.Tree(6, [4,2], [5,3,1], [5,7], [5,8], [5,9],
                          [5,10], 
                          [11], [12], [13], [14]);
               Copulas.Tree(7, [5,6,3,1,4,2,14,13,12,11],
                          [5,6,3,8,9,10]); 
               Copulas.Tree(8, [5,6,3,7,1,4,2,14,13,12,11],
                          [5,6,3,9,10]); 
               Copulas.Tree(9, [5,6,3,8,7,1,4,2,14,13,12,11],
                          [5,6,3,10]); 
               Copulas.Tree(10, [5,6,3,9,8,7,1,4,2,14,13,12,11]);
               Copulas.Tree(11, [6,5,4,12,13,14,2,3,1,7,8,9,10]);
               Copulas.Tree(12, [6,5,4,11],
                          [6,5,4,13,14,2,3,1,7,8,9,10]); 
               Copulas.Tree(13, [6,5,4,12,11],
                          [6,5,4,14,2,3,1,7,8,9,10]); 
               Copulas.Tree(14, [6,5,4,2,3,1,7,8,9,10],
                          [6,5,4,13,12,11])] 

        vn = Copulas.trees2vine(trs, 14)
    elseif number == 6
        ## factors 5 and 6 with 2 lags (5 with 1 and 3)
        ## 7, 8, 9 and 10 linked to factor 5
        ## 11, 12, 13 and 14 linked to factor 6
        ## no simulation with 1, 2, 3 and 4 given
        ## faster DVine structure than testvine number 5

        trs = [Copulas.Tree(1, [3,5,6,4,2,14,13,12,11],
                          [3,5,6,7,8,9,10]); 
               Copulas.Tree(2, [4,6,5,3,1,7,8,9,10],
                          [4,6,5,14,13,12,11]); 
               Copulas.Tree(3, [1], [5,6,4,2,14,13,12,11],
                          [5,6,7,8,9,10]); 
               Copulas.Tree(4, [2], [6,5,3,1,7,8,9,10],
                          [6,5,14,13,12,11]); 
               Copulas.Tree(5, [3,1], [6,4,2], [6,11], [6,12], [6,13],
                          [6,14], 
                          [7], [8], [9], [10]);
               Copulas.Tree(6, [4,2], [5,3,1], [5,7], [5,8], [5,9],
                          [5,10], 
                          [11], [12], [13], [14]);
               Copulas.Tree(7, [5,6,3,1,4,2,14,13,12,11], [5,6,8,9,10]); 
               Copulas.Tree(8, [5,6,7,3,1,4,2,14,13,12,11], [5,6,9,10]);
               Copulas.Tree(9, [5,6,8,7,3,1,4,2,14,13,12,11], [5,6,10]);
               Copulas.Tree(10, [5,6,9,8,7,3,1,4,2,14,13,12,11]);
               Copulas.Tree(11, [6,5,12,13,14,4,2,3,1,7,8,9,10]);
               Copulas.Tree(12, [6,5,11], [6,5,13,14,4,2,3,1,7,8,9,10]);
               Copulas.Tree(13, [6,5,12,11], [6,5,14,4,2,3,1,7,8,9,10]);
               Copulas.Tree(14, [6,5,4,2,3,1,7,8,9,10], [6,5,13,12,11])]

        vn = Copulas.trees2vine(trs, 14)
    end
    return vn
end
