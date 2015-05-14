module TestPITMatrix

using Copulas
using Base.Test

## single observation
kk = PITMatrix([0.1, 0.3])

kk2 = [0.1 NaN;
       NaN 0.3]
expOut = PITMatrix(reshape(kk2, 2, 2, 1))

@test isequal(kk, expOut)

## multiple observations
kk = PITMatrix([0.1 0.3;
                0.4 0.7;
                0.6 0.4])

@test size(dg(kk)) == (2, 2, 3)
@test kk[1, 1] == [0.1, 0.4, 0.6]
@test isnan(dg(kk)[1, 2])

## throw error during construction
@test_throws Exception PITMatrix([0.1 0.3;
                                  0.4 1.2;
                                  0.6 0.4])

@test_throws Exception PITMatrix([0.1 0.3;
                                  0.4 -0.2;
                                  0.6 0.4])

@test_throws Exception PITMatrix([0.1 0.3;
                                  0.4 -0.2;
                                  0.6 0.4])

kk = reshape([0.1 0.2;
              0.4 0.3;
              0.5 0.1], 3, 2, 1)
       
@test_throws Exception PITMatrix(kk)

end
