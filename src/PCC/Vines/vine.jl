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

#############
## display ##
#############

import Base.Multimedia.display
function display(vn::Vine)
    ## transform to Tree array

    nVars = size(vn.trees, 1)
    
    vineTrees = Array(Tree, nVars)
    for ii=1:nVars
        vineTrees[ii] = par2tree(vn.trees[:, ii])
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

##############
## analysis ##
##############

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

function avgSimSequPosition(simSequ::Array{Array{Int, 1}, 1})
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
