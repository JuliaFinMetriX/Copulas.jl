## export data for JFinM_Charts
##-----------------------------


## call data with default js variable name
function writeData(data::Array{Int, 2}, chrt::VineGraph)
    ## create JavaScript data with default name
    return writeData(data, "vineArrayData", chrt)
end

## TODO: allow additional information about data:
## factors / other grouping

## call data with given js variable name
function writeData(data::Array{Int, 2}, dataName::String,
                   chrt::VineGraph)
    ## transform vine tree to graph data Javascript variable
    layers = Copulas.linkLayers(Vine(data))
    
    nVars = size(data, 1)
    nodesCode = "{\n \"nodes\": [\n"
    for ii=1:nVars
        if ii < nVars
            currNode = """
{"name": $ii, "group": 1},
"""
        else
            currNode = """
{"name": $ii, "group": 1}
"""
        end
        nodesCode = [nodesCode, currNode]
    end
    nodesCode = [nodesCode, "],\n"]
    linksCode = "\"links\": [\n"
    nVars = size(data, 1)
    for ii=1:nVars
        for jj=(ii+1):nVars
            if ii == (nVars-1)
                currLink = """
{"source": $(ii-1), "target": $(jj-1), "value": $(layers[ii, jj])}
"""
            else
                currLink = """
{"source": $(ii-1), "target": $(jj-1), "value": $(layers[ii, jj])},
"""
            end
            linksCode = [linksCode, currLink]
        end
    end
    linksCode = [linksCode, "]\n}"]
    dataCode = [nodesCode, linksCode]
    
    dataScript = """
<script>
var $dataName = $(dataCode...)
</script>
"""
    
    return dataScript, dataName
end

