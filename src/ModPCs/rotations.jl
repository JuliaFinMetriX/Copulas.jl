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
                      u1::FloatVec, u2::FloatVec)
    return (u1, u2)
end

function resolve_args(rot::Rot90,
                      u1::FloatVec, u2::FloatVec)
    return (1-u2, u1)
end

function resolve_args(rot::Rot180,
                     u1::FloatVec, u2::FloatVec)
    return (1-u1, 1-u2)
end

function resolve_args(rot::Rot270,
                     u1::FloatVec, u2::FloatVec)
    return (u2, 1-u1)
end

##########################
## function evaluations ##
##########################

## pdf
##----

function pdf(cop::PairCop, rot::CWRotation,
             u1::FloatVec, u2::FloatVec)
    v1, v2 = resolve_args(rot, u1, u2)
    return pdf(cop, v1, v2)
end

## cdf
##----

function cdf(cop::PairCop, rot::Rot0,
             u1::FloatVec, u2::FloatVec)
    return cdf(cop, u1, u2)
end

function cdf(cop::PairCop, rot::Rot90,
             u1::FloatVec, u2::FloatVec)
    return u1 - cdf(cop, 1-u2, u1)
end

function cdf(cop::PairCop, rot::Rot180,
             u1::FloatVec, u2::FloatVec)
    return u1 + u2 + cdf(cop, 1-u1, 1-u2) - 1
end

function cdf(cop::PairCop, rot::Rot270,
             u1::FloatVec, u2::FloatVec)
    return u2 - cdf(cop, u2, 1-u1)
end

## h-functions
##------------

function hfun(cop::PairCop, rot::Rot0,
              u1::FloatVec, u2::FloatVec)
    return hfun(cop, u1, u2)
end

function hfun(cop::PairCop, rot::Rot90,
              u1::FloatVec, u2::FloatVec)
    return vfun(cop, u1, 1-u2)
end

function hfun(cop::PairCop, rot::Rot180,
              u1::FloatVec, u2::FloatVec)
    return 1 - hfun(cop, 1-u1, 1-u2)
end

function hfun(cop::PairCop, rot::Rot270,
              u1::FloatVec, u2::FloatVec)
    return 1 - vfun(cop, 1-u1, u2)
end

## v-functions
##------------

function vfun(cop::PairCop, rot::Rot0,
              u2::FloatVec, u1::FloatVec)
    return vfun(cop, u2, u1)
end

function vfun(cop::PairCop, rot::Rot90,
              u2::FloatVec, u1::FloatVec)
    return 1 - hfun(cop, 1-u2, u1)
end

function vfun(cop::PairCop, rot::Rot180,
              u2::FloatVec, u1::FloatVec)
    return 1 - vfun(cop, 1-u2, 1-u1)
end

function vfun(cop::PairCop, rot::Rot270,
              u2::FloatVec, u1::FloatVec)
    return hfun(cop, u2, 1-u1)
end

