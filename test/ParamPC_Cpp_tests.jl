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

## single function tests
##----------------------

cop = Copulas.ClaytonPC_Cpp([4.1])

u1, u2 = (0.3, 0.4)

testName = tName("pdf", "clay", 1, 1)
val = Copulas.pdf(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("cdf", "clay", 1, 1)
val = Copulas.cdf(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("hfun", "clay", 1, 1)
val = Copulas.hfun(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("vfun", "clay", 1, 1)
val = Copulas.vfun(cop, u2, u1)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

## tests using metaprogramming
##----------------------------

testPoints = [(0.3, 0.4),
              (0.2, 0.8)]

funcs = [:pdf,
         :cdf,
         :hfun]

cops = ["gauss" Copulas.GaussianPC_Cpp([0.5]);
        "gauss" Copulas.GaussianPC_Cpp([-0.5]);
        "stud" Copulas.tPC_Cpp([0.5, 4.0]);
        "stud" Copulas.tPC_Cpp([-0.5, 5.0]);
        "clay" Copulas.ClaytonPC_Cpp([4.1]);
        "clay" Copulas.ClaytonPC_Cpp([6.3]);
        "gumb" Copulas.GumbelPC_Cpp([4.3]);
        "gumb" Copulas.GumbelPC_Cpp([1.2]);
        "frank" Copulas.FrankPC_Cpp([4.3]);
        "frank" Copulas.FrankPC_Cpp([1.2]);
        "joe" Copulas.JoePC_Cpp([4.3]);
        "joe" Copulas.JoePC_Cpp([1.2]);
        "bb1" Copulas.BB1PC_Cpp([0.3, 2.2]);
        "bb1" Copulas.BB1PC_Cpp([1.2, 2.8]);
        "bb6" Copulas.BB6PC_Cpp([4.3, 2.2]);
        "bb6" Copulas.BB6PC_Cpp([1.2, 1.1]);
        "bb7" Copulas.BB7PC_Cpp([1.9, 0.3]);
        "bb7" Copulas.BB7PC_Cpp([1.2, 8.2]);
        "bb8" Copulas.BB8PC_Cpp([4.3, 0.2]);
        "bb8" Copulas.BB8PC_Cpp([1.2, 0.4])]
        

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
        Copulas.IndepPC_Cpp([0.3]),
        Copulas.IndepPC_Cpp([0.3]),
        Copulas.AMHPC_Cpp([0.4]),
        Copulas.AMHPC_Cpp([-0.4]),
        Copulas.AsymFGMPC_Cpp([0.2]),
        Copulas.AsymFGMPC_Cpp([0.9]),
        Copulas.BB1PC_Cpp([0.2, 5.4]),
        Copulas.BB1PC_Cpp([5.4, 1.2]),
        Copulas.BB6PC_Cpp([1.3, 4.3]),
        ## Copulas.BB6PC_Cpp([5.4, 0.2]),
        Copulas.BB7PC_Cpp([4.5, 4.4]),
        Copulas.BB7PC_Cpp([1.5, 4.2]),
        Copulas.BB8PC_Cpp([1.2, 0.2]),
        Copulas.BB8PC_Cpp([4.5, 0.8]),
        Copulas.ClaytonPC_Cpp([4.3]),
        Copulas.ClaytonPC_Cpp([2]),
        Copulas.FGMPC_Cpp([0.4]),
        Copulas.FGMPC_Cpp([-0.7]),
        Copulas.FrankPC_Cpp([-20]),
        Copulas.FrankPC_Cpp([22]),
        Copulas.GaussianPC_Cpp([0.6]),
        Copulas.GaussianPC_Cpp([-0.2]),
        Copulas.GumbelPC_Cpp([1.2]),
        Copulas.GumbelPC_Cpp([4.3]),
        Copulas.IteratedFGMPC_Cpp([0.5, 0.5]),
        Copulas.IteratedFGMPC_Cpp([-0.5, -0.4]),
        Copulas.JoePC_Cpp([4.2]),
        Copulas.JoePC_Cpp([8]),
        Copulas.PartialFrankPC_Cpp([1.2]),
        Copulas.PartialFrankPC_Cpp([12.5]),
        Copulas.PlackettPC_Cpp([1.2]),
        Copulas.PlackettPC_Cpp([18]),
        Copulas.Tawn1PC_Cpp([1.2, 0.2]),
        Copulas.Tawn1PC_Cpp([4.3, 0.4]),
        Copulas.Tawn2PC_Cpp([5.2, 0.8]),
        Copulas.Tawn2PC_Cpp([1.2, 0.4 ]),
        Copulas.TawnPC_Cpp([4.4, 0.3, 0.8]),
        Copulas.TawnPC_Cpp([12.8, 0.4, 0.5]),
        Copulas.tPC_Cpp([0.5, 4.0]),
        Copulas.tPC_Cpp([-0.3, 8.0])
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

## ID functions
##-------------

cop = Copulas.GaussianPC_Cpp([0.5])
@test 10 == Copulas.getVineCppId(cop)
@test 2 == Copulas.getVineCppId(:AsymFGM)
@test 0 == Copulas.getVineCppId(:Indep)

@test :Gumbel == Copulas.getCopNam(11)

@test :IteratedFGMPC_Cpp == Copulas.getCopType_Cpp(12)

## display functions
##------------------

cop = Copulas.GaussianPC_Cpp([0.5])
@test "GaussianPC_Cpp: 0.5" == Copulas.displayShortString(cop)

cop = Copulas.tPC_Cpp([0.5, 12.])
@test "tPC_Cpp: 0.5, 12.0" == Copulas.displayShortString(cop)

display(cop)

## equality
##---------

cop1 = Copulas.GaussianPC_Cpp([0.5])
cop2 = Copulas.GaussianPC_Cpp([0.5])
@test cop1 == cop2

end
