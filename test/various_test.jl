module TestVarious

using Copulas
using Base.Test

## undefined testpcc
##------------------

@test_throws Exception Copulas.testpcc(187)

end
