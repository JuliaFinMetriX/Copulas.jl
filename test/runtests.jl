using Copulas
using Base.Test

tests = [
         "utils_test.jl",
         "paircop_test.jl",
         "condTree_test.jl",
         ## "graphviz_test.jl",
         "vine_test.jl",
         "rvine_matrix_test.jl",
         ## "pcc_test.jl",
         ## "vineConstruction_test.jl",
         "ParamPC_tests.jl",
         "ParamPC_Cpp_tests.jl",
         "pitmatrix_test.jl"
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
