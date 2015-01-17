

#######################
## VineCPP interface ##
#######################

## copula ID lookup tables
##########################

# order determines copula IDs!
const vineCPP_cops = [:Indep,
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

const vineCPP_IDs = [vineCPP_cops[ii] => ii-1
                     for ii=1:length(vineCPP_cops)]

function getVineCPPId(nam::Symbol)
    return vineCPP_IDs[nam]
end

#######################################
## create parametric VineCPP copulas ##
#######################################

copTypeNames =
    [symbol(string(vineCPP_cops[ii], "PC_MAT"))
     for ii=1:length(vineCPP_cops)]

## define copula types through macro
##----------------------------------

macro defineParamCop(nam)
    esc(quote
        type $(nam) <: Copulas.ParamPC_MAT
            params::FloatVec
        end
    end)
end
        
for cop in copTypeNames
    eval(macroexpand(:(@defineParamCop $cop)))
end

###########################
## VineCPP ID interfaces ##
###########################

## get VineCPP Id for copula object
##---------------------------------

const type2idDict = [copTypeNames[ii] => (ii-1)::Int for ii=1:length(copTypeNames)]

function getVineCPPId(cop::ParamPC_MAT)
    return type2idDict[symbol(string(typeof(cop)))]
end

## get copula name for ID
##-----------------------

function getCopNam(ii::Int)
    return vineCPP_cops[ii+1]
end

## get copula type for ID
##-----------------------

function getCopType(ii::Int)
    return copTypeNames[ii+1]
end

#######################
## VineCPP functions ##
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
