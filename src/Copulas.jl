module Copulas

## using MATLAB

typealias FloatVec Array{Float64, 1}

# package code goes here
export # copula types
PairCop,
AbstractParamPC,
ParamPC,
ParamPC_MAT,
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
# parametric copula types, MATLAB implementation
IndepPC_MAT,
AMHPC_MAT,
AsymFGMPC_MAT,
BB1PC_MAT,
BB6PC_MAT,
BB7PC_MAT,
BB8PC_MAT,
ClaytonPC_MAT,
FGMPC_MAT,
FrankPC_MAT,
GaussianPC_MAT,
GumbelPC_MAT,
IteratedFGMPC_MAT,
JoePC_MAT,
PartialFrankPC_MAT,
PlackettPC_MAT,
Tawn1PC_MAT,
Tawn2PC_MAT,
TawnPC_MAT,
tPC_MAT,
# functions
checkSameLength,
getVineCPPId,
getCopNam,
getCopType,
params

include("PairCop.jl")
include("utils.jl")
include("ParamPCs/clayton.jl")
include("ParamPCs_Cpp/ParamPC_Cpp.jl")
## include("ParamPC_MATs/ParamPC_MAT.jl")
include("ModPCs/Modifyer.jl")
include("ModPCs/ModPC.jl")
include("ModPCs/rotations.jl")
include("ModPCs/ccwRotations.jl")
include("MixPCs/MixPC.jl")
include("rand.jl")


end # module
