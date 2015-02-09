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

function getCondSets(vn::Vine)
    nVars = size(vn.trees, 1)
    nSets = sum((nVars-1):-1:1)

    condSets = Array(Array{Int, 1}, nSets)
    currCondSet = Int[]
    ind = 1
    for ii=1:(nVars-1)
        root = ii
        for jj=(ii+1):nVars
            currCondSet = Int[]
            # follow jj in column ii to root
            notAtRoot = true
            steps = 0
            currNode = jj
            while notAtRoot
                steps = steps + 1
                currNode = vn.trees[currNode, ii]
                if currNode == root
                    notAtRoot = false
                    condSets[ind] = currCondSet
                    ind += 1
                else
                    push!(currCondSet, currNode)
                end
            end
        end
    end
    return condSets
end
