type VineGraphChart <: JFinM_Charts.AbstractChart
    chartType::String
    cmd::String
    shape::String
    maxLayer::Int
    styles::Array{String, 1}
    colors::Array{String, 1}
    lens::Array{String, 1}
    weights::Array{String, 1}
end

## define default values
VineGraphChart() = VineGraphChart("VineGraphChart",
                                  "neato",
                                  "circle",
                                  2,
                                  ["bold", "dotted"],
                                  ["black", "black"],
                                  ["1.0", "1.8"],
                                  ["1", "1"]
                                  )

function GViz(vn::Copulas.Vine,
              chrt::VineGraphChart)
    nVars = size(vn.trees, 1)
    layers = Copulas.linkLayers(vn)
    dotCode = ""
    dotCode = string(dotCode, "graph G {\n")
    dotCode = string(dotCode, "node [shape=$(chrt.shape)];\n")
    for ii=1:nVars
        for jj=ii+1:nVars
            currLayer = layers[ii, jj]
            if currLayer <= chrt.maxLayer
                tmpCode = "$ii -- $jj [style=$(chrt.styles[currLayer]); color=$(chrt.colors[currLayer]); len=$(chrt.lens[currLayer]); weight=$(chrt.weights[currLayer])];\n"
                    dotCode = string(dotCode, tmpCode)
            end
        end
    end
    dotCode = string(dotCode, "}")
    return GViz("VineGraphChart", "neato", dotCode)
end
