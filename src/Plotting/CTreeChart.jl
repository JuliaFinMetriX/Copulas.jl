type CTreeChart <: JFinM_Charts.AbstractChart
    chartType::String
    cmd::String
    shape::String
    arrowhead::String
    emph1::Array{Int, 1}
    emphFillColor1::String
    emphShape1::String
    emph2::Array{Int, 1}
    emphFillColor2::String
    emphShape2::String
end

## define default values
CTreeChart() = CTreeChart("CTreeChart",
                          "dot",
                          "circle", "none",
                          [], "lawngreen", "circle",
                          [], "lawngreen", "circle")

##########
## GViz ##
##########

@doc doc"""
Transform data and chart into graphviz instance.
"""->
function GViz(tr::CTreeParRef, chrt::CTreeChart)
    dotCode = ""
    
    ## emph1 and emph2 sets need to be non-overlapping
    if !isempty(intersect(chrt.emph1, chrt.emph2))
        error("emphasized sets need to be non-overlapping")
    end

    nVars = size(tr.tree, 1)
    dotCode = string(dotCode, "digraph {\n")
    dotCode = string(dotCode, "node [shape=$(chrt.shape)];\n")
    dotCode = string(dotCode, "edge [arrowhead=$(chrt.arrowhead)];\n")
    for ii=1:nVars
        parNode = tr.tree[ii]
        if parNode != 0
            if ii in chrt.emph1
                dotCode = string(dotCode, "$ii [style=filled; fillcolor=$(chrt.emphFillColor1); shape=$(chrt.emphShape1)];")
            elseif ii in chrt.emph2
                dotCode = string(dotCode, "$ii [style=filled; fillcolor=$(chrt.emphFillColor2); shape=$(chrt.emphShape2)];")
            else
                
                end
            dotCode = string(dotCode, "$parNode -> $ii ;\n")
        end
    end
    dotCode = string(dotCode, "}")
    return GViz("CTreeChart", "dot", dotCode)
end

function GViz(tr::CTreePaths, chrt::CTreeChart)
    return GViz(convert(CTreeParRef, tr), chrt)
end
