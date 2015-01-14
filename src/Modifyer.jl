abstract CopulaModification
abstract Rotation <: CopulaModification
abstract Reflection <: CopulaModification

## rotation type declarations
##---------------------------

immutable Rot0 <: Rotation
    description::String
    degrees::Float64
end

immutable Rot90 <: Rotation
    description::String
    degrees::Float64
end

immutable Rot180 <: Rotation
    description::String
    degrees::Float64
end

immutable Rot270 <: Rotation
    description::String
    degrees::Float64
end

## rotation constructors
##----------------------

function Rot0()
    return Rot0("No rotation", 0.0)
end

function Rot90()
    return Rot90("Clock-wise rotation of 90 degrees", 90.0)
end

function Rot180()
    return Rot180("Clock-wise rotation of 180 degrees", 180.0)
end

function Rot270()
    return Rot270("Clock-wise rotation of 270 degrees", 270.0)
end

