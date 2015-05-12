
## for each possible vizualization, there exist three different output
## ways:
## - print dot code to Julia console
## - visualize dot code through x11
## - write visualization of dot code to output file
##
## all three output ways make use of the same core: Julia code that
## automatically creates dot code

function toConsole(obj::Any; chrt="default", args...)
    stdin = IOBuffer()
    toGviz(obj, stdin, chrt; args...)
    takebuf_string(stdin)
end

@doc doc"""
Plot tree in x11 window.
"""->
function viz(obj::Any; cmd="dot", chrt="default", args...)
    stdin, proc = open(`$cmd -Tx11`, "w")
    toGviz(obj, stdin, chrt; args...)
    close(stdin)
end

@doc doc"""
Render chart to output file.
"""->
function render(obj::Any,
                fmt::String,
                fname::String;
                cmd="dot",
                chrt="default",
                args...)
    stdin, proc = open(`$cmd -T$fmt -o $fname.$fmt`, "w")
    toGviz(obj, stdin, chrt; args...)
    close(stdin)
end

@doc doc"""
Render chart to default output file.
"""->
function render(obj::Any; chrt="default", cmd="dot", args...)
    ## create tmp file
    fname = tempname()
    render(obj, "svg", fname; chrt=chrt, cmd=cmd, args...)
    return string(fname, ".", "svg")
end


###############
## tree plot ##
###############

@doc doc"""
Core of the graphviz interface: this function determines how a CTree
from Julia is actually translated into graphviz code. To keep it
general, this function will write to a given stream. This way one can
easily replace the stream with for example a file or a process.

Chrt input is irrelevant, as long as there is only one kind of
visualization for this data type.
"""->
function toGviz(tr::CTreeParRef,
                stream::IO,
                chrt::String;
                shape="circle",
                arrowhead="none",
                emph1=[], emphFillColor1="lawngreen",
                emphShape1="circle",
                emph2=[], emphFillColor2="lawngreen",
                emphShape2="circle"
                )
    
    ## emph1 and emph2 sets need to be non-overlapping
    if !isempty(intersect(emph1, emph2))
        error("emphasized sets need to be non-overlapping")
    end

    nVars = size(tr.tree, 1)
    write(stream, "digraph {\n")
    write(stream, "node [shape=$shape];\n")
    write(stream, "edge [arrowhead=$arrowhead];\n")
    for ii=1:nVars
        parNode = tr.tree[ii]
        if parNode != 0
            if ii in emph1
                write(stream, "$ii [style=filled; fillcolor=$emphFillColor1; shape=$emphShape1];")
                
            elseif ii in emph2
                write(stream, "$ii [style=filled; fillcolor=$emphFillColor2; shape=$emphShape2];")
            else
                
                end
            write(stream, "$parNode -> $ii ;\n")
        end
    end
    write(stream, "}")
end

function toGviz(tr::AbstractCTree, stream::IO; args...)
    trPar = convert(CTreeParRef, tr)
    return toGviz(trPar, stream; args...)
end

###############
## vine plot ##
###############

## header function to delegate to distinct vine visualization
## functions 
function toGviz(vn::Copulas.Vine,
                stream::IO,
                chrt::String;
                args...)
    if chrt == "default"
        toGviz_graph(vn, stream; args...)
    else
        toGviz_trees(vn, stream; args...)
    end
end

## graph visualization
##--------------------

function toGviz_graph(vn::Copulas.Vine,
                      stream::IO;
                      maxLayer=2)
    nVars = size(vn.trees, 1)
    layers = Copulas.linkLayers(vn)
    write(stream, "graph G {\n")
    write(stream, "node [shape=circle];\n")
    for ii=1:nVars
        for jj=ii+1:nVars
            currLayer = layers[ii, jj]
            if currLayer <= maxLayer
                if currLayer == 1
                    write(stream, "$ii -- $jj [style=bold];\n")
                elseif currLayer == 2
                    write(stream, "$ii -- $jj [len=1.3];\n")
                elseif currLayer == 3
                    write(stream, "$ii -- $jj;\n")
                end
            end
        end
    end
    write(stream, "}")
end


## conditioning tree visualization
##--------------------------------

function toGviz_trees(vn::Copulas.Vine,
                      stream::IO;
                      shape="circle",
                      arrowhead="none",
                      emph1=[], emphFillColor1="lawngreen",
                      emphFontColor1="black",
                      emphShape1="circle",
                      emph2=[], emphFillColor2="lawngreen",
                      emphShape2="circle")
    nVars = size(vn.trees, 1)
    write(stream, "digraph {\n")
    write(stream, "node [shape=$shape];\n")
    write(stream, "edge [arrowhead=$arrowhead];\n")
    for rootVar=1:nVars
        if rootVar in emph1
            write(stream, "\"$rootVar in $rootVar\"
[label=\"$rootVar\"; color=$emphFillColor1; fontcolor=$emphFontColor1; style=filled; fillcolor=$emphFillColor1; shape=$emphShape1];\n")
        elseif rootVar in emph2
            write(stream, "\"$rootVar in $rootVar\"
[label=\"$rootVar\"; color=$emphFillColor2; fontcolor=$emphFontColor2;
style=filled; fillcolor=$emphFillColor2; shape=$emphShape2];\n")
        else
            write(stream, "\"$rootVar in $rootVar\" [label=\"$rootVar\"];\n")
        end
        for ii=1:nVars
            parNode = vn.trees[ii, rootVar]
            if parNode > 0
                if ii in emph1
                    write(stream, "\"$ii in $rootVar\"
[label=\"$ii\"; color=$emphFillColor1; fontcolor=$emphFontColor1; style=filled; fillcolor=$emphFillColor1; shape=$emphShape1];\n")
                elseif ii in emph2
                    write(stream, "\"$ii in $rootVar\"
[label=\"$ii\"; color=$emphFillColor2; fontcolor=$emphFontColor2;
style=filled; fillcolor=$emphFillColor2; shape=$emphShape2];\n")
                else
                    write(stream, "\"$ii in $rootVar\" [label=\"$ii\"];\n")
                end
                write(stream, "\"$parNode in $rootVar\" -> \"$ii in $rootVar\";\n")
            end
        end
    end
    write(stream, "}")
end

