####################
## type hierarchy ##
####################

## abstract PairCop
abstract PairCop

## parametric copula types
##------------------------

abstract AbstractParamPC <: PairCop

## native julia implementation
abstract ParamPC <: AbstractParamPC

## based on VineCopulaCPP
abstract ParamPC_Cpp <: AbstractParamPC

##################################
## capture un-implemented cases ##
##################################

function pdf(cop::PairCop,
             u1::FloatVec, u2::FloatVec)
    error("pdf function is not yet implemented for this type of copula")
end

function cdf(cop::PairCop,
             u1::FloatVec, u2::FloatVec)
    error("cdf function is not yet implemented for this type of copula")
end

function hfun(cop::PairCop,
              u1::FloatVec, u2::FloatVec)
    error("h-function is not yet implemented for this type of copula")
end

function vfun(cop::PairCop,
              u2::FloatVec, u1::FloatVec)
    error("v-function is not yet implemented for this type of copula")
end

function hinv(cop::PairCop,
              u1::FloatVec, u2::FloatVec)
    error("inverse h-function is not yet implemented for this type of copula")
end

function vinv(cop::PairCop,
              u2::FloatVec, u1::FloatVec)
    error("inverse v-function is not yet implemented for this type of copula")
end

################################
## handle single observations ##
################################

funcs = [:pdf,
         :cdf,
         :hfun,
         :vfun,
         :hinv,
         :vinv]

macro treatSingleObs(f)
    esc(quote
        function $(f)(cop::PairCop, u1::Float64, u2::Float64)
            return $(f)(cop, [u1], [u2])
        end
        function $(f)(cop::PairCop, u1::Float64, u2::FloatVec)
            return $(f)(cop, u1*ones(length(u2)), u2)
        end
        function $(f)(cop::PairCop, u1::FloatVec, u2::Float64)
            return $(f)(cop, u1, u2*ones(length(u1)))
        end
    end)
end

for f in funcs
        eval(macroexpand(:(@treatSingleObs($f))))
end
