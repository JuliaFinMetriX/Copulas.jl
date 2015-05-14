module TestRVineMatrix

using Copulas
using Base.Test

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
Copulas.RVMatrix(kk)

#########################
## columnSubsets tests ##
#########################

kk = [1 0 0; 2 3 0; 3 1 2]
@test_throws Exception Copulas.chkColumnSubsets(kk)

kk = [2 0 0; 2 3 0; 3 2 2]
@test_throws Exception Copulas.chkColumnSubsets(kk)

kk = [1 0 0; 2 3 0; 3 2 2]
@test Copulas.chkColumnSubsets(kk)

########
## dg ##
########

kk = [1 0 0; 2 3 0; 3 2 2]
rvm = Copulas.RVMatrix(kk)
@test Copulas.dg(rvm) == kk

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

## convert two different RVines representing same vine
rmatr1 = Copulas.RVMatrix([4 0 0 0 0 0 0;
                           7 5 0 0 0 0 0;
                           6 7 1 0 0 0 0;
                           5 6 7 7 0 0 0;
                           1 1 6 2 6 0 0;
                           2 3 3 3 2 2 0;
                           3 2 2 6 3 3 3])

rmatr2 = Copulas.RVMatrix([7 0 0 0 0 0 0;
                           4 4 0 0 0 0 0;
                           5 6 6 0 0 0 0;
                           1 5 5 5 0 0 0;
                           2 1 1 1 1 0 0;
                           3 2 2 3 3 3 0;
                           6 3 3 2 2 2 2])

vn1 = convert(Copulas.Vine, rmatr1)
vn2 = convert(Copulas.Vine, rmatr2)

@test Copulas.dg(vn1) == Copulas.dg(vn2)

end
