############################################
## default convention: clockwise rotation ##
############################################

## type declarations
##------------------

immutable Rot0 <: CWRotation
    description::String
    degrees::Int

    function Rot0(descr::String, degr::Int)
        if degr != 0
            error("Wrong degrees for zero rotation!")
        end
        new(descr, degr)
    end

    Rot0() = Rot0("No rotation", 0)
end

immutable Rot90 <: CWRotation
    description::String
    degrees::Int

    function Rot90(descr::String, degr::Int)
        if (degr != 90) 
            error("Wrong degrees for 90 degrees rotation!")
        end
        new(descr, degr)
    end

    Rot90() = Rot90("Clockwise rotation of 90 degrees", 90)
end

immutable Rot180 <: CWRotation
    description::String
    degrees::Int

    function Rot180(descr::String, degr::Int)
        if (degr != 180) 
            error("Wrong degrees for 180 degrees rotation!")
        end
        new(descr, degr)
    end

    Rot180() = Rot180("Clockwise rotation of 180 degrees", 180)
end

immutable Rot270 <: CWRotation
    description::String
    degrees::Int

    function Rot270(descr::String, degr::Int)
        if (degr != 270) 
            error("Wrong degrees for 270 degrees rotation!")
        end
        new(descr, degr)
    end

    Rot270() = Rot270("Clockwise rotation of 270 degrees", 270)
end


#######################################################
## resolving pdf and cdf arguments for modifications ##
#######################################################

## clockwise rotation, array of points
##------------------------------------

function resolve_args(rot::Rot0,
                      u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return (u1, u2)
end

function resolve_args(rot::Rot90,
                      u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return (1-u2, u1)
end

function resolve_args(rot::Rot180,
                     u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return (1-u1, 1-u2)
end

function resolve_args(rot::Rot270,
                     u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return (u2, 1-u1)
end

##############################################
## resolving cdf p values for modifications ##
##############################################

## clockwise rotation, array of points
##------------------------------------

function resolve_pval(rot::Rot0, pVal::Array{Float64, 1},
                      u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return pVal
end

function resolve_pval(rot::Rot90, pVal::Array{Float64, 1},
                      u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return u1 - pVal
end

function resolve_pval(rot::Rot180, pVal::Array{Float64, 1},
                      u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return u1 + u2 + pVal - 1
end

function resolve_pval(rot::Rot270, pVal::Array{Float64, 1},
                      u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return u2 - pVal
end

################################
## Extensions to single point ##
################################

function resolve_args(rot::CWRotation,
                      u1::Float64, u2::Float64)
    return resolve_pval(rot, [u1], [u2])
end

function resolve_pval(rot::CWRotation, pVal::Float64,
                      u1::Float64, u2::Float64)
    return resolve_pval(rot, [pVal], [u1], [u2])
end

##########################
## function evaluations ##
##########################

## pdf
##----

function pdf(cop::PairCop, rot::CWRotation,
             u1::Array{Float64, 1}, u2::Array{Float64, 1})
    v1, v2 = resolve_args(rot, u1, u2)
    return pdf(cop, v1, v2)
end

## cdf
##----

function cdf(cop::PairCop, rot::CWRotation,
             u1::Array{Float64, 1}, u2::Array{Float64, 1})
    v1, v2 = resolve_args(rot, u1, u2)
    p = cdf(cop, u1, u2)
    return resolve_pval(rot, p, u1, u2)
end

## h-functions
##------------

function hfun(cop::PairCop, rot::Rot0,
              u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return hfun(cop, u1, u2)
end

function hfun(cop::PairCop, rot::Rot90,
              u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return vfun(cop, u1, 1-u2)
end

function hfun(cop::PairCop, rot::Rot180,
              u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return 1 - hfun(cop, 1-u1, 1-u2)
end

function hfun(cop::PairCop, rot::Rot270,
              u1::Array{Float64, 1}, u2::Array{Float64, 1})
    return 1 - vfun(cop, 1-u1, u2)
end

## v-functions
##------------

function vfun(cop::PairCop, rot::Rot0,
              u2::Array{Float64, 1}, u1::Array{Float64, 1})
    return vfun(cop, u2, u1)
end

function vfun(cop::PairCop, rot::Rot90,
              u2::Array{Float64, 1}, u1::Array{Float64, 1})
    return 1 - hfun(cop, 1-u2, u1)
end

function vfun(cop::PairCop, rot::Rot180,
              u2::Array{Float64, 1}, u1::Array{Float64, 1})
    return 1 - vfun(cop, 1-u2, 1-u1)
end

function vfun(cop::PairCop, rot::Rot270,
              u2::Array{Float64, 1}, u1::Array{Float64, 1})
    return hfun(cop, u2, 1-u1)
end

