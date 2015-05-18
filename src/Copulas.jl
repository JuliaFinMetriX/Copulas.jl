module Copulas

using Base.Test
## using Plotly
using Requires
using JFinM_Charts

VERSION < v"0.4-" && using Docile

typealias FloatVec Array{Float64, 1}
typealias IntArrays Array{Array{Int, 1}, 1}

####################
## type hierarchy ##
####################

abstract Copula
abstract PairCop <: Copula

# parametric pair copulas
abstract AbstractParamPC <: PairCop
abstract ParamPC <: AbstractParamPC # native Julia
abstract ParamPC_Cpp <: AbstractParamPC # VineCopulaCPP


# package code goes here
export # copula types
AbstractCTree,
AbstractParamPC,
Copula,
CTreeParRef,
CTreePaths,
MixPC,
ModPC,
PairCop,
ParamPC,
ParamPC_Cpp,
PCC,
PITMatrix,
Raw_html,
Vine,
# parametric copula types
IndepPC,
AMHPC,
AsymFGMPC,
BB1PC,
BB6PC,
BB7PC,
BB8PC,
ClaytonPC,
FGMPC,
FrankPC,
GaussianPC,
GumbelPC,
IteratedFGMPC,
JoePC,
PartialFrankPC,
PlackettPC,
Tawn1PC,
Tawn2PC,
TawnPC,
tPC,
# parametric copula types, Cpp implementation
IndepPC_Cpp,
AMHPC_Cpp,
AsymFGMPC_Cpp,
BB1PC_Cpp,
BB6PC_Cpp,
BB7PC_Cpp,
BB8PC_Cpp,
ClaytonPC_Cpp,
FGMPC_Cpp,
FrankPC_Cpp,
GaussianPC_Cpp,
GumbelPC_Cpp,
IteratedFGMPC_Cpp,
JoePC_Cpp,
PartialFrankPC_Cpp,
PlackettPC_Cpp,
Tawn1PC_Cpp,
Tawn2PC_Cpp,
TawnPC_Cpp,
tPC_Cpp,
# functions
allPathVals,
allVals,
condSetChk,
initCanvas,
par2tree,
tree2par,
trees2vine,
vine2trees,
cdf,
checkSameLength,
dg,
getVineCPPId,
getCopNam,
getCopType,
hfun,
hinv,
params,
pdf,
vfun,
vis,
pvinv

include("PairCop.jl")
include("utils.jl")
include("ParamPCs/clayton.jl")
include("ParamPCs/asym_fgm.jl")
include("ParamPCs_Cpp/ParamPC_Cpp.jl")
include("ModPCs/Modifyer.jl")
include("ModPCs/ModPC.jl")
include("ModPCs/rotations.jl")
include("ModPCs/ccwRotations.jl")
include("MixPCs/MixPC.jl")
include("PCC/Vines/edge.jl")
include("PCC/Vines/condTree.jl")
include("PCC/Vines/vine.jl")
include("PCC/Vines/rvine_matrix.jl")
## include("PCC/Vines/graphviz.jl")
include("Plotting/graphviz.jl")
include("Plotting/CTreeChart.jl")
include("Plotting/VineTreesChart.jl")
include("PCC/Vines/utils.jl")
include("PCC/Vines/vineConstruction.jl")
include("PCC/Vines/pitmatrix.jl")
include("PCC/PCC.jl")
include("testFuncs.jl")
include("testcases.jl")
include("rand.jl")
include("display.jl")
## include("d3_export.jl")

@require Winston begin
    filePath = joinpath(Pkg.dir("Copulas"), "src", "wstPlotting.jl")
    include(filePath)
    println("\n-------------------")
    println("Winston copula plots loaded as well")
    println("-------------------")
end

end # module
