## install Requires.jl
try
    if isa(Pkg.installed("Requires"), Nothing)
        Pkg.clone("https://github.com/one-more-minute/Requires.jl.git")
    end
catch
    Pkg.clone("https://github.com/one-more-minute/Requires.jl.git")
end

cd(Pkg.dir("Copulas"))
run(`make`)
