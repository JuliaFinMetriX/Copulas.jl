using Copulas
using Base.Test

tests = ["ParamPC_test.jl"
         ]

println("Running copula tests:")

for t in tests
    println(" * $(t)")
    include(string(Pkg.dir("Copulas"), "/test/", t))
end
