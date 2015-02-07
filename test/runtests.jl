using Copulas
using Base.Test

tests = ["utils_test.jl",
         "paircop_test.jl",
         "ParamPC_tests.jl",
         "ParamPC_Cpp_tests.jl"
         ## "ParamPC_test.jl"
         ]

println("Running copula tests:")

for t in tests
    println(" * $(t)")
    include(string(Pkg.dir("Copulas"), "/test/", t))
end
