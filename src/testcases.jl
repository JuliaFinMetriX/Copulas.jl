####################
## vine testcases ##
####################

@doc doc"""
Create `Vine` testcases.

1. D-Vine, 6 dimensional

2. 6 dimensional

3. 6 dimensional

4. 7 dimensional

5. 14 dimensional
"""->
function testvine(number::Int)
    if number == 1
        ## dvine
        kk = [0 2 2 2 2 2;
              1 0 3 3 3 3;
              2 2 0 4 4 4;
              3 3 3 0 5 5;
              4 4 4 4 0 6;
              5 5 5 5 5 0]
        vn = Copulas.Vine(kk)
    elseif number == 2
        kk = [0 3 3 3 3 3;
              3 0 3 5 5 5;
              1 2 0 2 2 2;
              5 5 5 0 5 6;
              2 2 2 4 0 4;
              4 4 4 4 4 0]
        vn = Copulas.Vine(kk)
    elseif number == 3
        kk = [0 2 5 4 2 5;
              1 0 3 1 5 3;
              5 2 0 5 2 6;
              1 1 1 0 1 1;
              2 2 2 2 0 2;
              3 3 3 3 3 0]
        vn = Copulas.Vine(kk)
    elseif number == 4
        p1 = Copulas.Tree(1, [2 3 4], [2 3 6 7], [2 3 5])
        p2 = Copulas.Tree(2, [1], [3 6 7], [3 4], [5])
        p3 = Copulas.Tree(3, [2 1], [2 5], [4], [6 7])
        p4 = Copulas.Tree(4, [3 2 1 5 6 7])
        p5 = Copulas.Tree(5, [2 3 1 4], [2 3 1 6 7])
        p6 = Copulas.Tree(6, [3 2 1 5 4], [7])
        p7 = Copulas.Tree(7, [6 3 2 1 5 4])
        parNot = Copulas.tree2par([p1, p2, p3, p4, p5, p6, p7], 7)
        vn = Copulas.Vine(parNot)
    elseif number == 5
        ## factors 5 and 6 with 2 lags (5 with 1 and 3)
        ## 7, 8, 9 and 10 linked to factor 5
        ## 11, 12, 13 and 14 linked to factor 6
        ## no simulation with 1, 2, 3 and 4 given
        trs = [Copulas.Tree(1, [3,5,6,4,2,14,13,12,11],
                          [3,5,6,7,8,9,10]); 
               Copulas.Tree(2, [4,6,5,3,1,7,8,9,10],
                          [4,6,5,14,13,12,11]); 
               Copulas.Tree(3, [1], [5,6,4,2,14,13,12,11], [5,6,7],
                          [5,6,8], [5,6,9], [5,6,10]);
               Copulas.Tree(4, [2], [6,5,3,1,7,8,9,10], [6,5,11],
                          [6,5,12], [6,5,13], [6,5,14]);
               Copulas.Tree(5, [3,1], [6,4,2], [6,11], [6,12],
                          [6,13], [6,14], [7], [8], [9], [10]);
               Copulas.Tree(6, [4,2], [5,3,1], [5,7], [5,8], [5,9],
                          [5,10], 
                          [11], [12], [13], [14]);
               Copulas.Tree(7, [5,6,3,1,4,2,14,13,12,11],
                          [5,6,3,8,9,10]); 
               Copulas.Tree(8, [5,6,3,7,1,4,2,14,13,12,11],
                          [5,6,3,9,10]); 
               Copulas.Tree(9, [5,6,3,8,7,1,4,2,14,13,12,11],
                          [5,6,3,10]); 
               Copulas.Tree(10, [5,6,3,9,8,7,1,4,2,14,13,12,11]);
               Copulas.Tree(11, [6,5,4,12,13,14,2,3,1,7,8,9,10]);
               Copulas.Tree(12, [6,5,4,11],
                          [6,5,4,13,14,2,3,1,7,8,9,10]); 
               Copulas.Tree(13, [6,5,4,12,11],
                          [6,5,4,14,2,3,1,7,8,9,10]); 
               Copulas.Tree(14, [6,5,4,2,3,1,7,8,9,10],
                          [6,5,4,13,12,11])] 

        vn = Copulas.trees2vine(trs, 14)
    elseif number == 6
        ## factors 5 and 6 with 2 lags (5 with 1 and 3)
        ## 7, 8, 9 and 10 linked to factor 5
        ## 11, 12, 13 and 14 linked to factor 6
        ## no simulation with 1, 2, 3 and 4 given
        ## faster DVine structure than testvine number 5

        trs = [Copulas.Tree(1, [3,5,6,4,2,14,13,12,11],
                          [3,5,6,7,8,9,10]); 
               Copulas.Tree(2, [4,6,5,3,1,7,8,9,10],
                          [4,6,5,14,13,12,11]); 
               Copulas.Tree(3, [1], [5,6,4,2,14,13,12,11],
                          [5,6,7,8,9,10]); 
               Copulas.Tree(4, [2], [6,5,3,1,7,8,9,10],
                          [6,5,14,13,12,11]); 
               Copulas.Tree(5, [3,1], [6,4,2], [6,11], [6,12], [6,13],
                          [6,14], 
                          [7], [8], [9], [10]);
               Copulas.Tree(6, [4,2], [5,3,1], [5,7], [5,8], [5,9],
                          [5,10], 
                          [11], [12], [13], [14]);
               Copulas.Tree(7, [5,6,3,1,4,2,14,13,12,11], [5,6,8,9,10]); 
               Copulas.Tree(8, [5,6,7,3,1,4,2,14,13,12,11], [5,6,9,10]);
               Copulas.Tree(9, [5,6,8,7,3,1,4,2,14,13,12,11], [5,6,10]);
               Copulas.Tree(10, [5,6,9,8,7,3,1,4,2,14,13,12,11]);
               Copulas.Tree(11, [6,5,12,13,14,4,2,3,1,7,8,9,10]);
               Copulas.Tree(12, [6,5,11], [6,5,13,14,4,2,3,1,7,8,9,10]);
               Copulas.Tree(13, [6,5,12,11], [6,5,14,4,2,3,1,7,8,9,10]);
               Copulas.Tree(14, [6,5,4,2,3,1,7,8,9,10], [6,5,13,12,11])]

        vn = Copulas.trees2vine(trs, 14)
    end
    return vn
end

function testpcc(number::Int)
    if number == 1
        vn = Copulas.setFirstLayer([1 2; 2 3; 3 4])
        vnFinal = Copulas.vineFrom2(vn)
        cops = [Copulas.GaussianPC_Cpp([0.5]),
                Copulas.GaussianPC_Cpp([0.2]),
                Copulas.GaussianPC_Cpp([-0.6]),
                Copulas.ClaytonPC_Cpp([3.5]),
                Copulas.ClaytonPC_Cpp([2.5]),
                Copulas.tPC_Cpp([0.5, 4.2])
                ]
        pcc = Copulas.PCC(cops, vnFinal)

    elseif number == 2
        vn = Copulas.setFirstLayer([1 2; 2 3; 3 4])
        vnFinal = Copulas.vineFrom2(vn)
        pcc = Copulas.PCC(vn)
        pcc[1, 2] = Copulas.GaussianPC_Cpp([0.5])
        pcc[3, 2] = Copulas.GaussianPC_Cpp([0.2])
        pcc[3, 4] = Copulas.ClaytonPC_Cpp([3.2])
    else
        error("No pair copula test case defined for number $number.")
    end
    return pcc
end
