module TestCopulas

using Copulas
using Base.Test


## load CDVine test results
dataPath = joinpath(Pkg.dir("Copulas"),
                    "test/data/r_cop_funcs_results.csv")

testResults = readcsv(dataPath, header = true)[1]
resDict = [testResults[ii, 1] => testResults[ii, 2]
           for ii=1:size(testResults, 1)]

cop = Copulas.GumbelPC_Cpp([4.2])
Copulas.pdf(cop, 0.3, 0.4)

testPoints = [(0.3, 0.4),
              (0.2, 0.8)]

u1, u2 = testPoints[ii]
cop = Copulas.GumbelPC_Cpp([4.3])
vals = Copulas.pdf(cop, u1, u2)

testName = string("pdf_", "gumb_", 1, "_", ind)
expOut = resDict[testName]

cop = Copulas.BB7PC_Cpp([1.9, 0.3])
vals = Copulas.pdf(cop, u1, u2)

cop = Copulas.FrankPC_Cpp([4.3])
vals = Copulas.pdf(cop, u1, u2)

end
