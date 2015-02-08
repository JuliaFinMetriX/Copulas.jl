using Copulas
using Base.Test

tests = ["utils_test.jl",
         "paircop_test.jl",
         "tree_test.jl",
         "vine_test.jl",
         "vineConstruction_test.jl",
         "ParamPC_tests.jl",
         "ParamPC_Cpp_tests.jl"
         ]

println("Running copula tests:")

for t in tests
    println("")
    println("----------------------")
    println(" * $(t)")
    println("----------------------")
    println("")
    include(string(Pkg.dir("Copulas"), "/test/", t))
end
