module TestCopulas

using Copulas
using Base.Test

##############
## asym_fgm ##
##############

uLow = 0.001
uHigh = 0.999
testGrid = [uLow, 0.1:0.1:0.9, uHigh]

epsTol = 1e-8

cop = Copulas.AsymFGM(0.4)
        Copulas.IndepPC_Cpp([0.3]),
        Copulas.IndepPC_Cpp([0.3]),
        ## Copulas.ClaytonPC_Cpp([4.3]),
        ## Copulas.ClaytonPC_Cpp([2]),


Copulas.testHandV(cop, epsTol, testGrid)
Copulas.testCdf(cop, epsTol, testGrid)
Copulas.testPdf(cop, testGrid)

end
