function checkSameLength(u1::FloatVec, u2::FloatVec)
    if !(size(u1, 1) == size(u2, 1))
        error("u1 and u2 vector must be of same length")
    end
    return true
end

function getFamAndParams(cop::ParamPC_Cpp)
    return (float(getVineCppId(cop)), params(cop))
end

## this functions exists so that copula types at some point can be
## changed to follow the interface of Distributions.jl more closely.
## This means that each copula type will have multiple fields, one for
## each parameter, and function params(cop::ParamCop) will generally
## return a tuple. This allows additional flexibility, since a single
## parameter then can be more than just a single Float value, but it
## could also be a covariance matrix or a PCModification.
function params(cop::ParamPC_Cpp)
    return cop.params
end

###########################
## define test functions ##
###########################

function testPdf(cop::Copulas.PairCop, 
                 testGrid::Array{Float64, 1})
    pdfVals = Float64[Copulas.pdf(cop, u1, u2)[1] for u1 in testGrid,
                      u2 in testGrid]

    @test !any(pdfVals .< 0)
end

## h- and v-functions
##-------------------

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
        @test all(diff(Copulas.hfun(cop, testGrid, u0)) .>= 0)
        @test all(diff(Copulas.vfun(cop, testGrid, u0)) .>= 0)
    end
end

## cdf
##----

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

## inverse h- and v-functions
##---------------------------

function testInvHV(cop::Copulas.PairCop, epsTol::Float64,
                   u1::Float64, u2::Float64)
    
    q = Copulas.hfun(cop, u1, u2)
    u1_hat = Copulas.hinv(cop, q, [u2])
    @test_approx_eq_eps u1 u1_hat epsTol

    q = Copulas.hinv(cop, u1, u2)
    u1_hat = Copulas.hfun(cop, q, [u2])
    @test_approx_eq_eps u1 u1_hat epsTol

    q = Copulas.vfun(cop, u2, u1)
    u2_hat = Copulas.vinv(cop, q, [u1])
    @test_approx_eq_eps u2 u2_hat epsTol

    q = Copulas.vinv(cop, u2, u1)
    u2_hat = Copulas.vfun(cop, q, [u1])
    @test_approx_eq_eps u2 u2_hat epsTol
    
end
