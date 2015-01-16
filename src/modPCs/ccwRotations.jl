## alternative rotation: counter clockwise
##----------------------------------------

immutable Rot0CCW <: counterCWRotation
    description::String
    degrees::Float64
end

immutable Rot90CCW <: counterCWRotation
    description::String
    degrees::Float64
end

immutable Rot180CCW <: counterCWRotation
    description::String
    degrees::Float64
end

immutable Rot270CCW <: counterCWRotation
    description::String
    degrees::Float64
end

## counter clockwise rotations
##----------------------------

function Rot0CCW()
    return Rot0CW("No rotation", 0.0)
end

function Rot90CCW()
    return Rot90CCW("Counter clockwise rotation of 90 degrees",
                    90.0)
end

function Rot180CCW()
    return Rot180CCW("Counter clockwise rotation of 180 degrees",
                     180.0)
end

function Rot270CCW()
    return Rot270CCW("Counter clockwise rotation of 270 degrees",
                     270.0)
end












## counter clockwise rotation, single point
##-----------------------------------------

function resolve_args(rot::Rot0, u1::Float64, u2::Float64)
    return (u1, u2)
end

function resolve_args(rot::Rot90, u1::Float64, u2::Float64)
    return (u2, 1-u1)
end

function resolve_args(rot::Rot180, u1::Float64, u2::Float64)
    return (1-u1, 1-u2)
end

function resolve_args(rot::Rot270, u1::Float64, u2::Float64)
    return (1-u2, u1)
end

## counter clockwise rotation, array of points
##--------------------------------------------

function resolve_args(rot::Rot0,
                     u1::FloatVec, u2::FloatVec)
    return (u1, u2)
end

function resolve_args(rot::Rot90,
                     u1::FloatVec, u2::FloatVec)
    return (u2, 1-u1)
end

function resolve_args(rot::Rot180,
                     u1::FloatVec, u2::FloatVec)
    return (1-u1, 1-u2)
end

function resolve_args(rot::Rot270,
                     u1::FloatVec, u2::FloatVec)
    return (1-u2, u1)
end

##############################################
## resolving cdf p values for modifications ##
##############################################


## counter clockwise rotation, array of points
##--------------------------------------------

function resolve_pval(rot::Rot0, pVal::FloatVec,
                     u1::FloatVec, u2::FloatVec)
    return pVal
end

function resolve_pval(rot::Rot90, pVal::FloatVec,
                     u1::FloatVec, u2::FloatVec)
    return u2 - pVal
end

function resolve_pval(rot::Rot180, pVal::FloatVec,
                     u1::FloatVec, u2::FloatVec)
    return u1 + u2 + pVal - 1
end

function resolve_pval(rot::Rot270, pVal::FloatVec,
                     u1::FloatVec, u2::FloatVec)
    return u1 - pVal
end

