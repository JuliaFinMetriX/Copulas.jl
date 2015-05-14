## install Requires.jl
try
    if isa(Pkg.installed("Requires"), Nothing)
        Pkg.clone("https://github.com/one-more-minute/Requires.jl.git")
    end
catch
    Pkg.clone("https://github.com/one-more-minute/Requires.jl.git")
end

## install JFinM_Charts.jl
## Pkg.installed():
## - returns true if package is installed
## - returns false if known package is not installed
## - throws error if package is unknown and not installed
try
    if isa(Pkg.installed("JFinM_Charts"), Nothing)
        Pkg.clone("https://github.com/JuliaFinMetriX/JFinM_Charts.git")
    end
catch
    Pkg.clone("https://github.com/JuliaFinMetriX/JFinM_Charts.git")
end

cd(Pkg.dir("Copulas"))
run(`make`)
