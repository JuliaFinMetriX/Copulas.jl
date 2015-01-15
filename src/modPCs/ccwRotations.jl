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

function resolve_args(rot::Rot0, u::Float64, v::Float64)
    return (u, v)
end

function resolve_args(rot::Rot90, u::Float64, v::Float64)
    return (v, 1-u)
end

function resolve_args(rot::Rot180, u::Float64, v::Float64)
    return (1-u, 1-v)
end

function resolve_args(rot::Rot270, u::Float64, v::Float64)
    return (1-v, u)
end

## counter clockwise rotation, array of points
##--------------------------------------------

function resolve_args(rot::Rot0,
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return (u, v)
end

function resolve_args(rot::Rot90,
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return (v, 1-u)
end

function resolve_args(rot::Rot180,
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return (1-u, 1-v)
end

function resolve_args(rot::Rot270,
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return (1-v, u)
end

##############################################
## resolving cdf p values for modifications ##
##############################################


## counter clockwise rotation, array of points
##--------------------------------------------

function resolve_pval(rot::Rot0, pVal::Array{Float64, 1},
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return pVal
end

function resolve_pval(rot::Rot90, pVal::Array{Float64, 1},
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return v - pVal
end

function resolve_pval(rot::Rot180, pVal::Array{Float64, 1},
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return u + v + pVal - 1
end

function resolve_pval(rot::Rot270, pVal::Array{Float64, 1},
                     u::Array{Float64, 1}, v::Array{Float64, 1})
    return u - pVal
end

