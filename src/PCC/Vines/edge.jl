type CondEdge
    vertices::Array{Int, 1}
    condSet::Array{Int, 1}
    paths::Array{Array{Int, 1}}
    parents::Array{Int, 1}
end

function CondEdge(v1::Int, v2::Int, condSet1::Array{Int, 1},
                  condSet2::Array{Int, 1})
    condSet = sort(condSet1)
    if v1 < v2
        parents = [condSet1[end], condSet2[end]]
        paths = Array{Int, 1}[condSet1, condSet2]
        vertices = [v1, v2]
    else
        parents = [condSet2[end], condSet1[end]]
        paths = Array{Int, 1}[condSet2, condSet1]
        vertices = [v2, v1]
    end
    return CondEdge(vertices, condSet, paths, parents)
end

import Base.Multimedia.display
function display(e::CondEdge)
    condSetString = "$(e.condSet[1])"
    for ii=2:length(e.condSet)
        condSetString = join([condSetString, ",", e.condSet[ii]])
    end
    println("     $(e.vertices[1]),$(e.vertices[2]) | $condSetString")
end

function display(e::Array{CondEdge, 1})
    nEdges = length(e)
    for ii=1:nEdges
        display(e[ii])
    end
end

function ==(e1::CondEdge, e2::CondEdge)
    equVertices = (e1.vertices == e2.vertices)
    equCondSets = (e1.paths == e2.paths)
    return  equVertices & equCondSets
end

function vertexTable(edgeArr::Array{CondEdge, 1}, nVars::Int)
    vTable = Array(Array{Int, 1}, nVars)
    nEdges = length(edgeArr)
    for ii=1:nEdges
        v1, v2 = edgeArr[ii].vertices
        if isdefined(vTable, v1)
            push!(vTable[v1], ii)
        else
            vTable[v1] = [ii]
        end
        if isdefined(vTable, v2)
            push!(vTable[v2], ii)
        else
            vTable[v2] = [ii]
        end
    end
    return vTable     
end
