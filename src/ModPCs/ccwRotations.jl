########################################################
## alternative convention: counter clockwise rotation ##
########################################################

## type declarations
##------------------

immutable Rot0CCW <: counterCWRotation
    description::String
    degrees::Int

    function Rot0CCW(descr::String, degr::Int)
        if degr != 0
            error("Wrong degrees for zero rotation!")
        end
        new(descr, degr)
    end

    Rot0CCW() = Rot0CW("No rotation", 0)    
end

immutable Rot90CCW <: counterCWRotation
    description::String
    degrees::Int

    function Rot90CCW(descr::String, degr::Int)
        if degr != 90
            error("Wrong degrees for 90 degrees rotation!")
        end
        new(descr, degr)
    end

    Rot90CCW() = Rot90CCW("Counter clockwise rotation of 90 degrees",
                          90)
end

immutable Rot180CCW <: counterCWRotation
    description::String
    degrees::Int

    function Rot180CCW(descr::String, degr::Int)
        if (degr != 180) 
            error("Wrong degrees for 180 degrees rotation!")
        end
        new(descr, degr)
    end

    errMsg = "Counter clockwise rotation of 180 degrees"
    Rot180CCW() =  Rot180CCW(errMsg, 180)

end

immutable Rot270CCW <: counterCWRotation
    description::String
    degrees::Int

    function Rot270CCW(descr::String, degr::Int)
        if (degr != 270) 
            error("Wrong degrees for 270 degrees rotation!")
        end
        new(descr, degr)
    end

    errMsg = "Clockwise rotation of 270 degrees"
    Rot270CCW() = Rot270CCW(errMsg, 270)
end


#######################################################
## resolving pdf and cdf arguments for modifications ##
#######################################################

## counter clockwise rotation, array of points
##--------------------------------------------

function resolve_args(rot::Rot0CCW,
                      u1::FloatVec, u2::FloatVec)
    return (u1, u2)
end

function resolve_args(rot::Rot90CCW,
                      u1::FloatVec, u2::FloatVec)
    return (u2, 1-u1)
end

function resolve_args(rot::Rot180CCW,
                      u1::FloatVec, u2::FloatVec)
    return (1-u1, 1-u2)
end

function resolve_args(rot::Rot270CCW,
                      u1::FloatVec, u2::FloatVec)
    return (1-u2, u1)
end

##########################
## function evaluations ##
##########################

## pdf
##----

function pdf(cop::PairCop, rot::counterCWRotation,
             u1::FloatVec, u2::FloatVec)
    v1, v2 = resolve_args(rot, u1, u2)
    return pdf(cop, v1, v2)
end

## cdf
##----

function cdf(cop::PairCop, rot::Rot0CCW,
             u1::FloatVec, u2::FloatVec)
    return cdf(cop, u1, u2)
end

function cdf(cop::PairCop, rot::Rot90CCW,
             u1::FloatVec, u2::FloatVec)
    return u2 - cdf(cop, u2, 1-u1)
end

function cdf(cop::PairCop, rot::Rot180CCW,
             u1::FloatVec, u2::FloatVec)
    return u1 + u2 + cdf(cop, 1-u1, 1-u2) - 1
end

function cdf(cop::PairCop, rot::Rot270CCW,
             u1::FloatVec, u2::FloatVec)
    return u1 - cdf(cop, 1-u2, u1)
end

## h-functions
##------------

function hfun(cop::PairCop, rot::Rot0CCW,
              u1::FloatVec, u2::FloatVec)
    return hfun(cop, u1, u2)
end

function hfun(cop::PairCop, rot::Rot90CCW,
              u1::FloatVec, u2::FloatVec)
    return 1 - vfun(cop, 1-u1, u2)
end

function hfun(cop::PairCop, rot::Rot180CCW,
              u1::FloatVec, u2::FloatVec)
    return 1 - hfun(cop, 1-u1, 1-u2)
end

function hfun(cop::PairCop, rot::Rot270CCW,
              u1::FloatVec, u2::FloatVec)
    return vfun(cop, u1, 1-u2)
end

## v-functions
##------------

function vfun(cop::PairCop, rot::Rot0CCW,
              u2::FloatVec, u1::FloatVec)
    return vfun(cop, u2, u1)
end

function vfun(cop::PairCop, rot::Rot90CCW,
              u2::FloatVec, u1::FloatVec)
    return hfun(cop, u2, 1-u1)
end

function vfun(cop::PairCop, rot::Rot180CCW,
              u2::FloatVec, u1::FloatVec)
    return 1 - vfun(cop, 1-u2, 1-u1)
end

function vfun(cop::PairCop, rot::Rot270CCW,
              u2::FloatVec, u1::FloatVec)
    return 1 - hfun(cop, 1-u2, u1)
end

