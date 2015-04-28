###############
## tree plot ##
###############

@doc doc"""
Core of the graphviz interface: this function determines how a CTree
from Julia is actually translated into graphviz code. To keep it
general, this function will write to a given stream. This way one can
easily replace the stream with for example a file or a process.
"""->
function toGviz(tr::CTreeParRef, stream::IO)
    nVars = size(tr.tree, 1)
    write(stream, "digraph {\n")
    for ii=1:nVars
        parNode = tr.tree[ii]
        if parNode != 0
            write(stream, "$parNode -> $ii;\n")
        end
    end
    write(stream, "}")
end

function toGviz(tr::CTreeParRef)
    str = IOBuffer()
    toGviz(tr, str)
    takebuf_string(str)
end

function toGviz(tr::AbstractCTree)
    trPar = convert(CTreeParRef, tr)
    return toGviz(trPar)
end

@doc doc"""
Plot tree in x11 window.
"""->
function viz(tr::CTreeParRef; cmd="dot")
    stdin, proc = open(`$cmd -Tx11`, "w")
    toGviz(tr, stdin)
    close(stdin)
end

function viz(tr::AbstractCTree; cmd="dot")
    trPar = convert(CTreeParRef, tr)
    viz(trPar, cmd = cmd)
end

function render(tr::CTreeParRef,
                fmt::String,
                cmd::String,
                fname::String)
    stdin, proc = open(`$cmd -T$fmt -o $fname.$fmt`, "w")
    toGviz(tr, stdin)
    close(stdin)
end

function render(tr::CTreeParRef)
    ## create tmp file
    fname = tempname()
    render(tr, "svg", fname)
    return string(fname, ".", "svg")
end

###############
## vine plot ##
###############

function toGviz(vn::Copulas.Vine, stream::IO, maxLayer::Int)
    nVars = size(vn.trees, 1)
    layers = Copulas.linkLayers(vn)
    write(stream, "graph G {\n")
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

function toGviz(vn::Copulas.Vine, maxLayer::Int)
    str = IOBuffer()
    toGviz(vn, str, maxLayer)
    takebuf_string(str)
end


function viz(vn::Copulas.Vine, maxLayer::Int; cmd="neato")
    stdin, proc = open(`$cmd -Tx11`, "w")
    toGviz(vn, stdin, maxLayer)
    close(stdin)
end
