module TestCopulas

using Copulas
using Base.Test

epsTol = 1e-12

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
val = Copulas.vfun(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

############################
## meta programming tests ##
############################

testPoints = [(0.3, 0.4),
              (0.2, 0.8)]

funcs = [:pdf,
         :cdf,
         :hfun,
         :vfun]

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
            display(testName)
            eval(:(val = (Copulas.$f)(cop, u1, u2)))
            expOut = resDict[testName]
            @test_approx_eq_eps val expOut epsTol
        end
    end
end

end
