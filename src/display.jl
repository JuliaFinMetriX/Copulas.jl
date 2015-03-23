@doc doc"""
Type to include raw html code into IJulia / IPython / Jupyter notebook
files.
"""->

type Raw_html
    s::String
end

import Base.writemime
function writemime(io::IO, ::MIME"text/html", x::Raw_html)
    print(io, x.s)
end

@doc doc"""
Create canvas for Javascript chart. By default, canvas will be a <div>
element with its name given as class. Element and attribute can be
specified as additional keyword input arguments. Instead of class,
canvas may be given as tag, identifier, attribute and so forth. The
function returns a Jupyter_html type that will directly write to
IJulia / IPython / Jupyter notebook files on display.

The function also loads the d3 library.
"""->
function initCanvas(canvasName::String;
                    elem="div"::String, attr="class"::String)
    
    canvasCode = """
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<$elem $attr="$canvasName"></$elem>
"""
    return Raw_html(canvasCode)
end

function vis(vn::Vine, canvasName::String;
             dataName="treeData"::String,
             attr="class"::String,
             width::Int=200, height::Int=500,
             vSpace::Int=100, nodeRadius::Int=12)

    # link to chart.js file
    # transform data to parent notation
    # write data to notebook
    # call chart

    canvasSelect = []
    if attr == "class"
        canvasSelect = join([".", canvasName], "")
    elseif attr == "id"
        canvasSelect = join(["#", canvasName], "")
    elseif attr == "elem"
        canvasSelect = canvasName
    else
        error("attr needs to be class, id or elem")
    end

    ## get vine given in parent reference notation
    data = vn.trees

    ## transform matrix to flat data Javascript variable
    nVars = size(data, 1)
    dataStr = Array(String, nVars*nVars + 2*nVars + 2)

    ind = 1
    dataStr[ind] = "["
    ind += 1
    for rt=1:nVars
        dataStr[ind] = "["
        ind += 1
        for nd=1:nVars
            p = data[nd, rt]
            dataStr[ind] = """{"name": "$nd", "parent": "$p"},"""
            ind += 1
        end
        dataStr[ind] = "],"
        ind += 1
    end
    dataStr[ind] = "]"
    
    dataCreation = """
<script>
var $dataName = $(dataStr...)
</script>

"""

    ## jsPath = joinpath(Pkg.dir("Copulas"), "src/charts.js")
    ## jsPath = "charts.js"
        
    ## call chart with given options
    chartCmd = """
<script> src="https://rawgithub.com/JuliaFinMetriX/Copulas.jl/master/src/charts.js"</script>
<script>
var actualChart = treeChart()
.width($width)
.height($height)
.vSpace($vSpace)
.nodeRadius($nodeRadius);
</script>

"""

    ## select given canvas with given data and call chart
    callChart = """
<script>
d3.select("$canvasSelect")
.selectAll(".singleTree")
.data($dataName)
.enter()
.append("chart")
.attr("class", "singleTree")
.call(actualChart)
</script>

"""
    jsCode = join([dataCreation, chartCmd, callChart], "")
    return Raw_html(jsCode)
end
