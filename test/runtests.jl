using Copulas
using Base.Test

tests = ["ParamPC_test.jl"
         ]

println("Running copula tests:")

for t in tests
    println(" * $(t)")
    include(string(Pkg.dir("Copulas"), "/test/", t))
end

## using MATLAB
## ## restart_default_msession()
## @matlab addpath("/home/grollc/research/matlab/VineCPP/")

## include(joinpath(homedir(), "research/julia/Copulas/src/Copulas.jl"))

## cop = Copulas.GaussianPC([0.5])
## Copulas.getCopId(cop)

## Copulas.getIdNam(0)
## Copulas.getIdCop(10)

## val = Copulas.pdf(cop, 0.2, 0.4)

## Copulas.id2fam

## ## rotation types
## ##---------------

## r90 = Copulas.Rot90()
## r180 = Copulas.Rot180()


## val = Copulas.pdf(cop, r180, 0.2, 0.4)

## val = Copulas.pdf(cop, r180, [0.2, 0.2], [0.4, 0.5])

## Copulas.checkSameLength([0.2, 0.2], [0.4, 0.5])

## Copulas.rand(cop, 100)
