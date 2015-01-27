##############################
## determine function names ##
##############################


const VineCppPath = joinpath(Pkg.dir("Copulas"),
                             "src/VineCopulaCPP/libVineCPP.so.1.0")
                             
## u1 = [0.3; 0.2]
## u2 = [0.4; 0.8]
## fam = 11
## param = 5.3
## n = 2
## val = [4.4; 4.1]

## val2 = ccall((:_Z13PairCopulaPDFiPKdPdS1_S1_j, libPath),
##              Void,
##              (Int, Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
##               Ptr{Float64}, Int),
##              fam, &param, u1, u2, val, n)

pdfName = :_Z13PairCopulaPDFiPKdPdS1_S1_j
cdfName = :_Z13PairCopulaCDFiPKdPdS1_S1_j
hfunName = :_Z14PairCopulaHfuniPKdPdS1_S1_j
vfunName = :_Z14PairCopulaVfuniPKdPdS1_S1_j
hvinName = :_Z17PairCopulaInvHfuniPKdPdS1_S1_j
vinvName = :_Z17PairCopulaInvVfuniPKdPdS1_S1_j

#######################
## VineCpp interface ##
#######################

## copula ID lookup tables
##########################

## list of copula families - order determines copula IDs!
const vineCpp_cops = [:Indep,
                      :AMH,
                      :AsymFGM,
                      :BB1,
                      :BB6,
                      :BB7,
                      :BB8,
                      :Clayton,
                      :FGM,
                      :Frank,
                      :Gaussian,
                      :Gumbel,
                      :IteratedFGM,
                      :Joe,
                      :PartialFrank,
                      :Plackett,
                      :Tawn1,
                      :Tawn2,
                      :Tawn,
                      :t]

## transform to dictionary with families as keys
const vineCpp_IDs = [vineCpp_cops[ii] => ii-1
                     for ii=1:length(vineCpp_cops)]

function getVineCppId(nam::Symbol)
    return vineCpp_IDs[nam]
end

#######################################
## create parametric VineCpp copulas ##
#######################################

copTypeNames_Cpp =
    [symbol(string(vineCpp_cops[ii], "PC_Cpp"))
     for ii=1:length(vineCpp_cops)]

## define copula types through macro
##----------------------------------

macro defineParamCopCpp(nam)
    esc(quote
        type $(nam) <: Copulas.ParamPC_Cpp
            params::FloatVec
        end
    end)
end
        
for cop in copTypeNames_Cpp
    eval(macroexpand(:(@defineParamCopCpp $cop)))
end

###########################
## VineCpp ID interfaces ##
###########################

## get VineCpp Id for copula object
##---------------------------------

## dict with copula type names as keys
const type2idDictCpp = [copTypeNames_Cpp[ii] => (ii-1)::Int for ii=1:length(copTypeNames_Cpp)]

function getVineCppId(cop::ParamPC_Cpp)
    return type2idDictCpp[symbol(string(typeof(cop)))]
end

## get family name for ID
##-----------------------

function getCopNam(ii::Int)
    return vineCpp_cops[ii+1]
end

## get copula type for ID
##-----------------------

function getCopType_Cpp(ii::Int)
    return copTypeNames_Cpp[ii+1]
end

#######################
## VineCpp functions ##
#######################

## pdf function
##-------------

function pdf(cop::ParamPC_Cpp, u1::FloatVec, u2::FloatVec)
    fam, params = getFamAndParams(cop)

    nObs = length(u1)
    param = 5.3
    retVals = zeros(Float64, nObs)

    ccall((:_Z13PairCopulaPDFiPKdPdS1_S1_j, VineCppPath),
          Void,
          (Int, Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
           Ptr{Float64}, Int),
          fam, &param, u1, u2, retVals, nObs)

    return retVals
end

## ## cdf function
## ##-------------

## function cdf(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
##     fam, params = getFamAndParams(cop)

##     val = []
##     try
##         val = mxcall(:PairCopulaCDF, 1, fam, u1, u2, params)
##     catch
##         error("Call of Matlab cdf did not return a value!")
##     end
##     return val
## end

## ## h-function
## ##-----------

## function hfun(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
##     fam, params = getFamAndParams(cop)

##     val = []
##     try
##         val = mxcall(:PairCopulaHfun, 1, fam, u1, u2, params)
##     catch
##         error("Call of Matlab h-function did not return a value!")
##     end
##     return val
## end

## ## v-function
## ##-----------

## function vfun(cop::ParamPC_MAT, u2::FloatVec, u1::FloatVec)
##     fam, params = getFamAndParams(cop)

##     val = []
##     try
##         val = mxcall(:PairCopulaVfun, 1, fam, u2, u1, params)
##     catch
##         error("Call of Matlab v-function did not return a value!")
##     end
##     return val
## end

## ## hinv-function
## ##-----------

## function hinv(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
##     fam, params = getFamAndParams(cop)

##     val = []
##     try
##         val = mxcall(:PairCopulaInvHfun, 1, fam, u1, u2, params)
##     catch
##         error("Call of Matlab inverse h-fun did not return a value!")
##     end
##     return val
## end

## ## vinv-function
## ##-----------

## function vinv(cop::ParamPC_MAT, u2::FloatVec, u1::FloatVec)
##     fam, params = getFamAndParams(cop)

##     val = []
##     try
##         val = mxcall(:PairCopulaInvVfun, 1, fam, u2, u1, params)
##     catch
##         error("Call of Matlab inverse v-fun did not return a value!")
##     end
##     return val
## end

