abstract ParamPC <: PairCop

## copula ID lookup tables
##########################

const id2fam = [:Indep,
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

## create copula type names
###########################

copTypeNames =
    [symbol(string(id2fam[ii], "PC")) for ii=1:length(id2fam)]

## define copula types through macro
####################################

macro defineParamCop(nam)
    esc(quote
        type $(nam) <: Copulas.ParamPC
            params::FloatVec
        end
    end)
end
        
for cop in copTypeNames
    eval(macroexpand(:(@defineParamCop $cop)))
end

## create family to ID Dictionary
#################################

const fam2idDict = [id2fam[ii] => ii-1 for ii=1:length(id2fam)]
const type2idDict = [copTypeNames[ii] => (ii-1)::Int for ii=1:length(copTypeNames)]

function getFamId(nam::Symbol)
    return fam2idDict[nam]
end
function getCopId(cop::ParamPC)
    return type2idDict[symbol(string(typeof(cop)))]
end

function getIdNam(ii::Int)
    return id2fam[ii+1]
end

function getIdCop(ii::Int)
    return copTypeNames[ii+1]
end

