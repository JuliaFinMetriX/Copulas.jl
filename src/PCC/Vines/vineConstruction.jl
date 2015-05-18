####################
## construct vine ##
####################

## from second layer on
function vineFrom2(vn::Vine)
    ## build vine from given first layer
    ##
    ## Inputs:
    ## 	vn			Vine with only first layer specified
    ## Outputs:
    ## 	finalVn	completely specified Vine

    nVars = size(vn.trees, 2)
    nLayers = nVars-1
    
    for layerNb=2:nLayers
        ## get current vine in tree notation
        trs = convert(CTreePaths, vn)

        ## get new conditional edges
        newEdges = selectLinks(trs, layerNb)

        ## add new edges to vine
        for e in newEdges
            addEdge!(vn, e)
        end
    end
    return vn
end

function addEdge!(vn::Vine, edge::CondEdge)
    v1, v2 = edge.vertices
    p1, p2 = edge.parents
    vn.trees[v1, v2] = p2
    vn.trees[v2, v1] = p1
    return vn
end

##################
## select edges ##
##################

## select edges out of list of possible new edges
function selectLinks(trs::Array{CTreePaths, 1}, nrLayer::Int)
    ## some edges are automatically selected, because they need to be
    ## picked
    ##
    ## some edges may only be selected together
    ##
    ## some edges are selected manually

    nVars = length(trs)
    nToMatch = nVars - nrLayer          # number of required edges
    
    ## find incomplete trees
    verticesToBeLinked = incomplTrees(trs)

    ## get possible matches
    ##---------------------
    possibleEdges = findPairMatch(trs, nrLayer, verticesToBeLinked)
    ## displayAllPossibleEdges(possibleEdges)
    
    nMatches = length(possibleEdges)

    ## validity checks
    if nMatches < nToMatch
        error("Too few matching conditional sets!")
    end

    reachedVs = reachedVertices(possibleEdges)
    if !(reachedVs == verticesToBeLinked)
        error("Not each required vertex can be connected!")
    end
    
    ## automatic selection: single possible edge
    ##------------------------------------------
    chosenEdges, stillToBeLinked = mandatoryEdges(possibleEdges,
                                                  verticesToBeLinked,
                                                  nVars)
    
    ## match remaining links
    ##----------------------

    nRemain = nToMatch - sum(chosenEdges)

    if nRemain > 0
        displayCurrentLayer(nrLayer)
        println("Current tree:")
        display(trs)
        displayAutomChosenEdges(possibleEdges, chosenEdges)
    end
    
    while nRemain > 0
        displayLayerState(possibleEdges, chosenEdges,
                          stillToBeLinked, nRemain)
        selectedInd = getUserInput("Which edge(s) should be chosen?")

        indConversion = find(!chosenEdges)
        indInList = indConversion[selectedInd]
        
        chosenEdges[indInList] = true

        ## rm vertices of chosen edge from stillToBeLinked list
        for eInd in indInList
            strikeOffVs = possibleEdges[eInd].vertices
            stillToBeLinked = setdiff(stillToBeLinked, strikeOffVs)
        end

        ## new remaining
        nRemain = nToMatch - sum(chosenEdges)
    end

    ## backtest: are all required edges connected through set of
    ## chosen edges?
    chosenEdgesList = possibleEdges[chosenEdges]
    return chosenEdgesList
end

function setFirstLayer(vertices::Array{Int, 2})
    nEdges = size(vertices, 1)
    nVars = nEdges + 1
    parNot = -1*ones(Int, nVars, nVars)
    for ii=1:nEdges
        v1, v2 = vertices[ii, :]
        parNot[v2, v1] = v1
        parNot[v1, v2] = v2
    end
    for ii=1:nVars
        parNot[ii, ii] = 0
    end
    return Vine(parNot)
end

## function getUserInput(prompt::String="")
##     print(prompt)
##     return chomp(readline())
## end
function getUserInput(prompt::String="")
    print(prompt)
    inputStr = chomp(readline())
    individualNumbers = split(inputStr, " ")
    inds = Int[int(nbStr) for nbStr in individualNumbers]
    return inds
end

       
function displayLayerState(possibleEdges::Array{CondEdge, 1},
                           chosenEdges::Array{Bool, 1},
                           stillToBeLinked::Array{Int, 1},
                           nRemain::Int)

    println("Variables that still need to be connected:")
    display(stillToBeLinked)
    println("-------------")

    println("$nRemain out of the following edges must be chosen:")
    remainingEdges = possibleEdges[!chosenEdges]
    for ii=1:length(remainingEdges)
        e = remainingEdges[ii]
        condSetString = "$(e.condSet[1])"
        for jj=2:length(e.condSet)
            condSetString =
                join([condSetString, ",", e.condSet[jj]])
        end
        edgeString = "$(e.vertices[1]),$(e.vertices[2]) | $condSetString"
        println("$ii |   $edgeString")
    end
    ## display(remainingEdges)
    println("-------------")
end

function displayCurrentLayer(nrLayer::Int)
    println("\n-------------")
    println("Manually select links at layer $nrLayer:")
    println("-------------")
end

function displayAllPossibleEdges(possibleEdges::Array{CondEdge, 1})
    println("Set of all possible new edges:")
    display(possibleEdges)
    println("-------------")
end

function displayAutomChosenEdges(possibleEdges::Array{CondEdge, 1},
                                 chosenEdges::Array{Bool, 1})
    println("Automatically chosen edges are:")
    display(possibleEdges[chosenEdges])
    println("-------------")
end


function mandatoryEdges(possibleEdges::Array{CondEdge, 1},
                        verticesToBeLinked::Array{Int, 1},
                        nVars::Int)

    nMatches = length(possibleEdges)
    chosenEdges = zeros(Bool, nMatches)
    stillToBeLinked = verticesToBeLinked
    
    ## calculate vertex table for given edge list
    vTable = vertexTable(possibleEdges, nVars)
    
    ## find vertices that need to be matched and only have one
    ## possible edge
    lookForUniqueEdge = true
    while lookForUniqueEdge
        eInd = findUniqueEdgeForVertex(vTable, stillToBeLinked)
        if isempty(eInd)
            lookForUniqueEdge = false
        else
            ## mark edge as already selected
            chosenEdges[eInd] = true
            
            ## remove edge vertices from toBeLinked list
            strikeOffVs = possibleEdges[eInd].vertices
            stillToBeLinked = setdiff(stillToBeLinked, strikeOffVs)
        end
    end
    return (chosenEdges, stillToBeLinked)
end

## tests exist
function incomplTrees(trs::Array{CTreeParRef, 1})
    ## only incomplete trees need to be considered
    ## Input:
    ## 	trs			nx1 Array of Trees
    ## Out:
    ## 	incompl		Array{Int, 1} of indices of incomplete trees,
    ## 					chronologically sorted
    
    nTrees = length(trs)
    incompl = Array(Int, 0)
    for ii=1:nTrees
        if !(isempty(unlinkedVars(trs[ii], nTrees)))
            push!(incompl, ii)
        end
    end
    return incompl
end

## tests exist
function equSets(arr1::Array{Int, 1}, arr2::Array{Int, 1})
    ## return unique(sort(arr1)) == unique(sort(arr2))
    return Set(arr1) == Set(arr2)
end

function findUniqueEdgeForVertex(vTable::Array{Array{Int, 1}, 1},
                                toBeMatched::Array{Int, 1})
    edgeNumber = []
    for var in toBeMatched
        if length(vTable[var]) == 1
            edgeNumber = vTable[var][1]
            break
        end
    end
    return edgeNumber
end

#########################
## find possible edges ##
#########################

## for two given trees, find matches
function pairMatch(tr1::CTreeParRef, tr2::CTreeParRef, nrLayer::Int)
    ## check for correct layer?
    ## check whether already matched?
    ## nrLayer > 1
    ## Note:
    ## allows for multiple matching condition sets, but in reality
    ## this probably may not occur!

    if !(nrLayer > 1)
        error("First layer needs to be built elsewhere!")
    end

    condSetLen = nrLayer - 1
    validLen1 = find(getDepths(tr1) .== condSetLen)
    validLen2 = find(getDepths(tr2) .== condSetLen)

    matchingInd1 = Array(Int, 0)
    matchingInd2 = Array(Int, 0)
    for ind1 in validLen1
        for ind2 in validLen2
            if equSets(tr1[ind1], tr2[ind2])
                push!(matchingInd1, ind1)
                push!(matchingInd2, ind2)
            end
        end
    end
    return [matchingInd1 matchingInd2]
end

## for given layer, find all matches in tree array
## tests exist
function findPairMatch(trs::Array{CTreeParRef, 1}, nrLayer::Int,
                       verticesToBeLinked::Array{Int, 1})
    ## constraints:
    ## - individual trees are sorted: tree at index ii has root ii
    ## - if ii is unlinked with jj, so is jj with ii
    ## - nVars == nTrees
    
    nTrees = length(trs)

    ## preallocate list of edges
    matchingEdges = Array(CondEdge, 0)
    
    for ii=1:(nTrees-1)
        for jj=(ii+1):nTrees
            ## exclude already complete trees
            isRequired1 = ii in verticesToBeLinked
            isRequired2 = jj in verticesToBeLinked
            
            if isRequired1 && isRequired2
                matches = pairMatch(trs[ii], trs[jj], nrLayer)
                if !isempty(matches)
                    e = CondEdge(ii, jj,
                                 trs[ii][matches[1]],
                                 trs[jj][matches[2]])
                    push!(matchingEdges, e)
                end
            end
        end
    end
    return matchingEdges
end

function unlinkedVars(tr::CTreeParRef, nVars::Int)
    ## only variables not yet linked need to be tested
    return setdiff([1:nVars], allNodes(tr))
end

function reachedVertices(edges::Array{CondEdge, 1})
    ## get chronological list of all connected vertices
    reachedVs = Array(Int, 0)
    nEdges = length(edges)
    for ii=1:nEdges
        v1, v2 = edges[ii].vertices
        push!(reachedVs, v1)
        push!(reachedVs, v2)
    end
    return sort(unique(reachedVs))
end
