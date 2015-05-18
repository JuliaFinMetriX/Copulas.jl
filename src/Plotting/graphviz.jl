@doc doc"""
GViz type contains all information required to plot or render a chart.
That is, it contains the required cmd type (dot / neato) and the code
with relevant data already included. Additionally, it also stores the
name of the visualization type.

An instance of type GViz then can be visualized with viz or it can be
written to file with render.
"""->
type GViz
    chartType::String
    cmd::String
    code::String
end

#########
## viz ##
#########

@doc doc"""
As a GViz instance already incorporates all information relevant for
plotting, we can call viz directly on an instance.
"""->
function viz(chrt::GViz)
    cmd = chrt.cmd
    stdin, proc = open(`$cmd -Tx11`, "w")
    write(stdin, chrt.code)
    close(stdin)
end

@doc doc"""
A second way to call viz is by calling it with data and chart input
directly. As a side effect, this will return the used GViz instance.
"""->
function viz(data::Any, chrt::JFinM_Charts.AbstractChart)
    gviz = GViz(data, chrt)
    viz(gviz)
    return gviz
end

############
## render ##
############

## render GViz instance
##---------------------

@doc doc"""
Render chart to output file.
"""->
function render(gviz::GViz,
                fmt::String,
                fname::String)
    cmd = gviz.cmd
    stdin, proc = open(`$cmd -T$fmt -o $fname.$fmt`, "w")
    write(stdin, gviz.code)
    close(stdin)
end

@doc doc"""
Render chart to default output file.
"""->
function render(gviz::GViz)
    ## create tmp file
    fname = tempname()
    render(gviz, "svg", fname)
    return string(fname, ".", "svg")
end

## render data and chart
##----------------------

@doc doc"""
Render chart to output file.
"""->
function render(data::Any,
                chrt::JFinM_Charts.AbstractChart,
                fmt::String,
                fname::String)
    gviz = GViz(data, chrt)
    render(gviz, fmt, fname)
end

@doc doc"""
Render chart to default output file.
"""->
function render(data::Any;
                chrt=JFinM_Charts.AbstractChart)
    gviz = GViz(data, chrt)
    render(gviz)
end

