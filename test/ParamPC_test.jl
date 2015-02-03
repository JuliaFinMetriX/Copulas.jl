module TestCopulas

using Copulas
using Base.Test

##############
## asym_fgm ##
##############

cop = Copulas.AsymFGM(0.4)
@test [1.0] == Copulas.cdf(cop, 1.0, 1.0)


uLow = 0.001
uHigh = 0.999
testGrid = [uLow, 0.1:0.1:0.9, uHigh]


## pdf function
##-------------

pdfVals = Float64[Copulas.pdf(cop, u1, u2)[1] for u1 in testGrid,
           u2 in testGrid]

# no pdf value smaller than 0
@test !any(pdfVals .< 0)


########################
## h- and v-functions ##
########################

epsTol = 1e-8
cop = Copulas.ClaytonPC_Cpp([0.4])
cop = Copulas.AsymFGM(0.4)
testHandV(cop, epsTol, testGrid)
testCdf(cop, epsTol, testGrid)

function testHandV(cop::Copulas.PairCop, epsTol::Float64,
                 testGrid::Array{Float64, 1})

    ## values between 0 and 1
    hVals = Float64[Copulas.hfun(cop, u1, u2)[1] for u1 in testGrid,
                    u2 in testGrid]
    @test !any(hVals .< 0)
    @test !any(hVals .> 1)

    vVals = Float64[Copulas.vfun(cop, u1, u2)[1] for u1 in testGrid,
                    u2 in testGrid]
    @test !any(vVals .< 0)
    @test !any(vVals .> 1)

    # borders 0 and 1
    @test all(Copulas.hfun(cop, 0., testGrid) .< epsTol)
    @test all(abs(Copulas.hfun(cop, 1., testGrid) - 1) .< epsTol)
    @test all(Copulas.vfun(cop, 0., testGrid) .< epsTol)
    @test all(abs(Copulas.vfun(cop, 1., testGrid) - 1) .< epsTol)

    # increasing
    for u0 in testGrid
        @test all(diff(Copulas.hfun(cop, testGrid, u0)) .> 0)
        @test all(diff(Copulas.vfun(cop, testGrid, u0)) .> 0)
    end
end

#########
## cdf ##
#########

function testCdf(cop::Copulas.PairCop, epsTol::Float64,
                 testGrid::Array{Float64, 1})
    # borders 0 and 1
    @test all(Copulas.cdf(cop, 0., testGrid) .< epsTol)
    @test all(Copulas.cdf(cop, testGrid, 0.) .< epsTol)
    @test all(abs(Copulas.cdf(cop, 1., testGrid) - testGrid) .< epsTol)
    @test all(abs(Copulas.cdf(cop, testGrid, 1.) - testGrid) .< epsTol)

    # increasing
    cdfVals = Float64[Copulas.cdf(cop, u1, u2)[1] for u1 in testGrid,
                      u2 in testGrid]
    
    for ii=1:size(cdfVals, 1)
        @test all(diff(cdfVals[ii, :]) .> 0)
    end
    for ii=1:size(cdfVals, 2)
        @test all(diff(cdfVals[:, 2]) .> 0)
    end
end

end
