module Copulas

using Base.Test
## using Plotly
using Requires

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
PairCop,
AbstractParamPC,
ParamPC,
ParamPC_Cpp,
ModPC,
MixPC,
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
Tree,
Vine,
allPathVals,
allVals,
condSetChk,
par2tree,
tree2par,
trees2vine,
vine2trees,
cdf,
checkSameLength,
getVineCPPId,
getCopNam,
getCopType,
hfun,
hinv,
params,
pdf,
vfun,
vinv

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
include("PCC/Vines/tree.jl")
include("PCC/Vines/edge.jl")
include("PCC/Vines/tree.jl")
include("PCC/Vines/vine.jl")
include("PCC/Vines/utils.jl")
include("PCC/Vines/vineConstruction.jl")
include("testFuncs.jl")
include("rand.jl")

@require Winston begin
    filePath = joinpath(Pkg.dir("Copulas"), "src", "wstPlotting.jl")
    include(filePath)
    println("\n-------------------")
    println("Winston copula plots loaded as well")
    println("-------------------")
end

end # module
