module TestCopulas

using Copulas
using Base.Test

epsTol = 1e-12

###############################
## CDVine consistency checks ##
###############################

## load CDVine test results
##-------------------------

dataPath = joinpath(Pkg.dir("Copulas"),
                    "test/data/r_cop_funcs_results.csv")

testResults = readcsv(dataPath, header = true)[1]
resDict = [testResults[ii, 1] => testResults[ii, 2]
           for ii=1:size(testResults, 1)]

function tName(func, cop, copInd, ptInd)
    return string(func, "_", cop, "_", copInd, "_", ptInd)
end

## tests using metaprogramming
##----------------------------

testPoints = [(0.3, 0.4),
              (0.2, 0.8)]

funcs = [:pdf,
         :cdf,
         :hfun]

cops = []
        

for ptInd=1:length(testPoints)
    for copInd=1:size(cops, 1)
        for f in funcs
            copName = cops[copInd, 1]
            cop = cops[copInd, 2]
            u1, u2 = testPoints[ptInd]
            mod(copInd, 2) == 0 ? ind = 2 : ind = 1
            testName = tName(string(f), copName, ind, ptInd)
#            display(testName)
            eval(:(val = (Copulas.$f)(cop, u1, u2)))
            expOut = resDict[testName]
            @test_approx_eq_eps val expOut epsTol
        end
    end
end

## v functions
for ptInd=1:length(testPoints)
    for copInd=1:size(cops, 1)
        copName = cops[copInd, 1]
        cop = cops[copInd, 2]
        u1, u2 = testPoints[ptInd]
        mod(copInd, 2) == 0 ? ind = 2 : ind = 1
        testName = tName("vfun", copName, ind, ptInd)
        #            display(testName)
        val = Copulas.vfun(cop, u2, u1)
        expOut = resDict[testName]
        @test_approx_eq_eps val expOut epsTol
    end
end


########################
## consistency checks ##
########################

epsTol = 1e-7

uLow = 0.001
uHigh = 0.999
testGrid = [uLow, 0.1:0.1:0.9, uHigh]

cops = [
        Copulas.AsymFGMPC(0.2),
        Copulas.AsymFGMPC(0.9)
        ]


## pdf, cdf, h- and v-functions
##-----------------------------

for cop in cops
    show(cop)
    println("")
    println(" *  cdf tests:")
    Copulas.testCdf(cop, epsTol, testGrid)
    println(" *  h/v tests:")
    Copulas.testHandV(cop, epsTol, testGrid)
    println(" *  pdf tests:")
    Copulas.testPdf(cop, testGrid)
end

## inverse h- and v-functions
##---------------------------

cops = []


testPoints = [(0.3, 0.7),
              (0.00002, 0.00098),
              (0.1, 0.998),
              ## (0.8, 0.2132323543),
              (0.8, 0.2132),
              ## (0.2349248, 0.983475),
              (0.999, 0.999),
              (0.0001, 0.0001)]

println("-------------------------------")
println("inverse h- and v-function tests")
println("-------------------------------")

for pts in testPoints
    u1, u2 = pts
    for cop in cops
        copShown = false

        q = Copulas.hfun(cop, u1, u2)
        u1_hat = Copulas.hinv(cop, q, [u2])
        if abs(u1 - u1_hat)[1] > epsTol
            # show copula
            if !copShown
                show(cop)
                println("")
                copShown = true
            end
            
            # at least both values should be mapped to same hfun value
            println("u2=$u2: $u1 -> $u1_hat")
            if !(q == Copulas.hfun(cop, u1_hat, u2))
                println("different h-function values")
                h1 = Copulas.hfun(cop, u1, u2)
                h2 = Copulas.hfun(cop, u1_hat, u2)
                println("  h($u1) = $h1")
                println("  h($u1_hat) = $h2")
            end
        end

        q = Copulas.vfun(cop, u1, u2)
        u1_hat = Copulas.vinv(cop, q, [u2])
        if abs(u1 - u1_hat)[1] > epsTol
            # show copula
            if !copShown
                show(cop)
                println("")
                copShown = true
            end
            
            # at least both values should be mapped to same hfun value
            println("u2=$u2: $u1 -> $u1_hat")
            if !(q == Copulas.vfun(cop, u1_hat, u2))
                println("different v-function values")
                h1 = Copulas.vfun(cop, u1, u2)
                h2 = Copulas.vfun(cop, u1_hat, u2)
                println("  v($u1) = $h1")
                println("  v($u1_hat) = $h2")
            end
        end

        ## q = Copulas.hinv(cop, u1, u2)
        ## u1_hat = Copulas.hfun(cop, q, [u2])
        ## hdiff2 = u1 - u1_hat
        ## ## @test_approx_eq_eps u1 u1_hat epsTol
        ## q = Copulas.vfun(cop, u2, u1)
        ## u2_hat = Copulas.vinv(cop, q, [u1])
        ## vdiff1 = u2 - u2_hat
        ## q = Copulas.vfun(cop, u2, u1)
        ## u2_hat = Copulas.vinv(cop, q, [u1])
        ## vdiff2 = u2 - u2_hat
        ## ## @test_approx_eq_eps u2 u2_hat epsTol
        ## maxDiff = max(abs(hdiff1[1]),
        ##               abs(hdiff2[1]),
        ##               abs(vdiff1[1]),
        ##               abs(vdiff2[1]))
        ## if abs(maxDiff) > 1e-10
        ##     show(cop)
        ##     println("")
        ##     println("diffh1: $hdiff1")
        ##     println("diffh2: $hdiff2")
        ##     println("diffv1: $vdiff1")
        ##     println("diffv2: $vdiff2")
        ## end
    end
end

######################
## parameter bounds ##
######################

@test_throws Exception Copulas.AsymFGMPC(4.3)
@test_throws Exception Copulas.ClaytonPC(-4.)


## params function
##----------------

@test (0.8,) == Copulas.params(Copulas.AsymFGMPC(0.8))
@test (4.3,) == Copulas.params(Copulas.ClaytonPC(4.3))

end

