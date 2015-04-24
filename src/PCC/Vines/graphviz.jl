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
function viz(tr::CTreeParRef)
    stdin, proc = open(`dot -Tx11`, "w")
    toGviz(tr, stdin)
    close(stdin)
end

function viz(tr::AbstractCTree)
    trPar = convert(CTreeParRef, tr)
    viz(trPar)
end

function render(tr::CTreeParRef,
                fmt::String,
                fname::String)
    stdin, proc = open(`dot -T$fmt -o $fname.$fmt`, "w")
    toGviz(tr, stdin)
    close(stdin)
end

function render(tr::CTreeParRef)
    ## create tmp file
    fname = tempname()
    render(tr, "svg", fname)
    return string(fname, ".", "svg")
end

