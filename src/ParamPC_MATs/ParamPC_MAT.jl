#################################
## Matlab VineCopula interface ##
#################################

#######################################
## create parametric VineCpp copulas ##
#######################################

copTypeNames_MAT =
    [symbol(string(vineCpp_cops[ii], "PC_MAT"))
     for ii=1:length(vineCpp_cops)]

## define copula types through macro
##----------------------------------

macro defineParamCopMAT(nam)
    esc(quote
        type $(nam) <: Copulas.ParamPC_MAT
            params::FloatVec
        end
    end)
end
        
for cop in copTypeNames_MAT
    eval(macroexpand(:(@defineParamCopMAT $cop)))
end

###########################
## VineCpp ID interfaces ##
###########################

## get VineCpp Id for copula object
##---------------------------------

const type2idDictMAT = [copTypeNames_MAT[ii] => (ii-1)::Int for ii=1:length(copTypeNames_MAT)]
                        
function getVineCppId(cop::ParamPC_MAT)
    return type2idDictMAT[symbol(string(typeof(cop)))]
end


## get copula type for ID
##-----------------------

function getCopType_MAT(ii::Int)
    return copTypeNames_MAT[ii+1]
end

#######################
## VineCpp functions ##
#######################

## pdf function
##-------------

function pdf(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
    fam, params = getFamAndParams(cop)

    val = []
    try
        val = mxcall(:PairCopulaPDF, 1, fam, u1, u2, params)
    catch
        error("Call of Matlab pdf did not return a value!")
    end
    return val
end

## cdf function
##-------------

function cdf(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
    fam, params = getFamAndParams(cop)

    val = []
    try
        val = mxcall(:PairCopulaCDF, 1, fam, u1, u2, params)
    catch
        error("Call of Matlab cdf did not return a value!")
    end
    return val
end

## h-function
##-----------

function hfun(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
    fam, params = getFamAndParams(cop)

    val = []
    try
        val = mxcall(:PairCopulaHfun, 1, fam, u1, u2, params)
    catch
        error("Call of Matlab h-function did not return a value!")
    end
    return val
end

## v-function
##-----------

function vfun(cop::ParamPC_MAT, u2::FloatVec, u1::FloatVec)
    fam, params = getFamAndParams(cop)

    val = []
    try
        val = mxcall(:PairCopulaVfun, 1, fam, u2, u1, params)
    catch
        error("Call of Matlab v-function did not return a value!")
    end
    return val
end

## hinv-function
##-----------

function hinv(cop::ParamPC_MAT, u1::FloatVec, u2::FloatVec)
    fam, params = getFamAndParams(cop)

    val = []
    try
        val = mxcall(:PairCopulaInvHfun, 1, fam, u1, u2, params)
    catch
        error("Call of Matlab inverse h-fun did not return a value!")
    end
    return val
end

## vinv-function
##-----------

function vinv(cop::ParamPC_MAT, u2::FloatVec, u1::FloatVec)
    fam, params = getFamAndParams(cop)

    val = []
    try
        val = mxcall(:PairCopulaInvVfun, 1, fam, u2, u1, params)
    catch
        error("Call of Matlab inverse v-fun did not return a value!")
    end
    return val
end

