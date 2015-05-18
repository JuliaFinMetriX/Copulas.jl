type VineTreesChart <: JFinM_Charts.AbstractChart
    chartType::String
    cmd::String
    shape::String
    arrowhead::String
    emph1::Array{Int, 1}
    emphFillColor1::String
    emphFontColor1::String
    emphShape1::String
    emph2::Array{Int, 1}
    emphFillColor2::String
    emphFontColor2::String
    emphShape2::String
    rootEmph::Array{Int, 1}
    rootEmphFillColor1::String
    rootEmphFontColor1::String
    rootEmphShape1::String
end

VineTreesChart() = VineTreesChart("VineTreesChart",
                                  "dot",
                                  "circle",
                                  "none",
                                  [], "lawngreen",
                                  "black", "circle",
                                  [], "lawngreen",
                                  "black", "circle",
                                  [], "lawngreen",
                                  "black", "circle"
                                  )

function GViz(vn::Copulas.Vine, chrt::VineTreesChart)
    dotCode = ""
    nVars = size(vn.trees, 1)
    dotCode = string(dotCode, "digraph {\n")
    dotCode = string(dotCode, "node [shape=$(chrt.shape)];\n")
    dotCode = string(dotCode, "edge [arrowhead=$(chrt.arrowhead)];\n")
    for rootVar=1:nVars
        if rootVar in chrt.emph1
            dotCode = string(dotCode, "\"$rootVar in $rootVar\"
[label=\"$rootVar\"; color=$(chrt.emphFillColor1); fontcolor=$(chrt.emphFontColor1); style=filled; fillcolor=$(chrt.emphFillColor1); shape=$(chrt.emphShape1)];\n")
        elseif rootVar in chrt.emph2
            dotCode = string(dotCode, "\"$rootVar in $rootVar\"
[label=\"$rootVar\"; color=$(chrt.emphFillColor2); fontcolor=$(chrt.emphFontColor2);
style=filled; fillcolor=$(chrt.emphFillColor2); shape=$(chrt.emphShape2)];\n")
        elseif rootVar in chrt.rootEmph
            dotCode = string(dotCode, "\"$rootVar in $rootVar\"
[label=\"$rootVar\"; color=$(chrt.rootEmphFillColor1); fontcolor=$(chrt.rootEmphFontColor1);
style=filled; fillcolor=$(chrt.rootEmphFillColor1); shape=$(chrt.rootEmphShape1)];\n")
        else
            dotCode = string(dotCode, "\"$rootVar in $rootVar\" [label=\"$rootVar\"];\n")
        end
        for ii=1:nVars
            parNode = vn.trees[ii, rootVar]
            if parNode > 0
                if ii in chrt.emph1
                    dotCode = string(dotCode, "\"$ii in $rootVar\"
[label=\"$ii\"; color=$(chrt.emphFillColor1); fontcolor=$(chrt.emphFontColor1);
style=filled; fillcolor=$(chrt.emphFillColor1); shape=$(chrt.emphShape1)];\n")
                elseif ii in chrt.emph2
                    dotCode = string(dotCode, "\"$ii in $rootVar\"
[label=\"$ii\"; color=$(chrt.emphFillColor2); fontcolor=$(chrt.emphFontColor2); style=filled; fillcolor=$(chrt.emphFillColor2); shape=$(chrt.emphShape2)];\n")
                else
                    dotCode = string(dotCode, "\"$ii in $rootVar\" [label=\"$ii\"];\n")
                end
                dotCode = string(dotCode, "\"$parNode in $rootVar\" -> \"$ii in $rootVar\";\n")
            end
        end
    end
    dotCode = string(dotCode,  "}")
    return GViz("VineTreesChart", "dot", dotCode)
end

