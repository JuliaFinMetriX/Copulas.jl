# include plot3d of Winston
filePath = joinpath(Pkg.dir("Winston"), "src", "canvas3d.jl")
include(filePath)

function wstPlot(cop::PairCop, n=50::Int64;
                 f=Copulas.pdf::Function,
                 zMax=Inf::Float64)

    cutoff = zMax
    grid = linspace(0, 1, n)
    grid[1] = 0.001
    grid[end] = 0.999

    
    Plot3d.plot3d(
                  Plot3d.surf((u,v)->u,
                              (u,v)->min(f(cop, u, v)[1], cutoff),
                              (u,v)->v,
                              grid, grid))
end
