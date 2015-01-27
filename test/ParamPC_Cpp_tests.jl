module TestCopulas

using Copulas
using Base.Test

epsTol = 1e-8

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

testName = tName("pdf", "clay", 1, ii)
val = Copulas.pdf(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("cdf", "clay", 1, ii)
val = Copulas.cdf(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("hfun", "clay", 1, ii)
val = Copulas.hfun(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("vfun", "clay", 1, ii)
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

cops = [Copulas.GaussianPC_Cpp([0.5]),
        Copulas.GaussianPC_Cpp([-0.5]),
        Copulas.tPC_Cpp([0.5, 4.0]),
        Copulas.tPC_Cpp([-0.5, 5.0]),
        Copulas.ClaytonPC_Cpp([4.1]),
        Copulas.ClaytonPC_Cpp([6.3]),
        Copulas.GumbelPC_Cpp([4.3]),
        Copulas.GumbelPC_Cpp([1.2]),
        Copulas.FrankPC_Cpp([4.3]),
        Copulas.FrankPC_Cpp([1.2]),
        Copulas.JoePC_Cpp([4.3]),
        Copulas.JoePC_Cpp([1.2]),
        Copulas.BB1PC_Cpp([0.3, 2.2]),
        Copulas.BB1PC_Cpp([1.2, 2.8]),
        Copulas.BB6PC_Cpp([4.3, 2.2]),
        Copulas.BB6PC_Cpp([1.2, 1.1]),
        Copulas.BB7PC_Cpp([1.9, 0.3]),
        Copulas.BB7PC_Cpp([1.2, 8.2]),
        Copulas.BB8PC_Cpp([4.3, 0.2]),
        Copulas.BB8PC_Cpp([1.2, 0.4])]
        



cop = Copulas.GumbelPC_Cpp([4.2])
Copulas.pdf(cop, 0.3, 0.4)

testPoints = [(0.3, 0.4),
              (0.2, 0.8)]

u1, u2 = testPoints[ii]

cop = Copulas.GumbelPC_Cpp([4.3])

testName = tName("pdf", "gumb", 1, ii)
val = Copulas.pdf(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol

testName = tName("cdf", "gumb", 1, ii)
val = Copulas.cdf(cop, u1, u2)
expOut = resDict[testName]
@test_approx_eq_eps val expOut epsTol


cop = Copulas.BB7PC_Cpp([1.9, 0.3])
vals = Copulas.pdf(cop, u1, u2)

cop = Copulas.FrankPC_Cpp([4.3])
vals = Copulas.pdf(cop, u1, u2)

end
