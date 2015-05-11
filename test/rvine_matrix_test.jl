module TestRVineMatrix

using Copulas
using Base.Test

include("/home/chris/research/julia/Copulas/src/Copulas.jl")

#######################
## constructor tests ##
#######################


kk = [1 0 0; 2 3 0; 3 1 2]
@test_throws Exception Copulas.RVMatrix(kk)

kk = [2 0 0; 2 3 0; 3 2 2]
@test_throws Exception Copulas.RVMatrix(kk)

kk = [2 0 4; 2 3 0; 3 2 2]
@test_throws Exception Copulas.RVMatrix(kk)

kk = [1 0 0; 2 3 0; 3 2 2]
RVMatrix(kk)

#########################
## columnSubsets tests ##
#########################

kk = [1 0 0; 2 3 0; 3 1 2]
@test_throws Exception Copulas.chkColumnSubsets(kk)

kk = [2 0 0; 2 3 0; 3 2 2]
@test_throws Exception Copulas.chkColumnSubsets(kk)

kk = [1 0 0; 2 3 0; 3 2 2]
@test Copulas.chkColumnSubsets(kk)

###############
## allExcept ##
###############

vn = Copulas.testvine(2)
paths = convert(Copulas.CTreePaths, vn)

actOut = Copulas.allExcept(paths, 4)
expOut = [paths[1], paths[2], paths[3], paths[5], paths[6]]

@test actOut == expOut

##################
## findMaxDepth ##
##################

vn = Copulas.testvine(2)
paths = convert(Copulas.CTreePaths, vn)

expOut = 1
@test expOut == Copulas.findMaxDepth(paths)

## next example
vn = Copulas.testvine(6)
paths = convert(Copulas.CTreePaths, vn)

expOut = 10
@test expOut == Copulas.findMaxDepth(paths)

####################
## getLongestPath ##
####################

expOut = [5,6,3,1,4,2,14,13,12,11]
actOut = Copulas.getLongestPath(paths[7])
@test expOut == actOut

expOut = [6,4,2]
actOut = Copulas.getLongestPath(paths[5])
@test expOut == actOut

#############
## convert ##
#############

for ii=1:6
    vn = Copulas.testvine(ii)
    rmatr = convert(Copulas.RVMatrix, vn)
    vn2 = convert(Copulas.Vine, rmatr)
    @test vn.trees == vn2.trees
end
