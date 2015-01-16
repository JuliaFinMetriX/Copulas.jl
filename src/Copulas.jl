module Copulas

using MATLAB

typealias FloatVec Array{Float64, 1}

# package code goes here
export # copula types
PairCop,
ParamPC,
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
# functions
getCopId,
getFamId,
getIdNam,
getIdCop,
pdf

include("PairCop.jl")
include("ParamPC.jl")
include("Modifyer.jl")
include("ModPC.jl")
include("MixPC.jl")
include("utils.jl")
include("pdf.jl")
include("rand.jl")


end # module
