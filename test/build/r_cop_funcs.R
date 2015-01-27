library(CDVine)

#########
## pdf ##
#########

testCopFam1 <- function(ind, nam, u1, u2, fam, param1){
    
    vals <- rbind(BiCopPDF(u1, u2, fam, param1),
                  BiCopCDF(u1, u2, fam, param1),
                  BiCopHfunc(u1, u2, fam, param1)$hfunc2,
                  BiCopHfunc(u1, u2, fam, param1)$hfunc1
                  )
    
    nams <- rbind(paste("pdf", nam, ind, sep = "_"),
                  paste("cdf", nam, ind, sep = "_"),
                  paste("hfun", nam, ind, sep = "_"),
                  paste("vfun", nam, ind, sep = "_")
                  )
    df <- data.frame(tests = nams, values = vals)
    return(df)
}

testCopFam2 <- function(ind, nam, u1, u2, fam, param1, param2){
    
    vals <- rbind(BiCopPDF(u1, u2, fam, param1, param2),
                  BiCopCDF(u1, u2, fam, param1, param2),
                  BiCopHfunc(u1, u2, fam, param1, param2)$hfunc2,
                  BiCopHfunc(u1, u2, fam, param1, param2)$hfunc1
                  )
    
    nams <- rbind(paste("pdf", nam, ind, sep = "_"),
                  paste("cdf", nam, ind, sep = "_"),
                  paste("hfun", nam, ind, sep = "_"),
                  paste("vfun", nam, ind, sep = "_")
                  )
    df <- data.frame(tests = nams, values = vals)
    return(df)
}

pdfTest <- function(u1, u2, ind) {

    ## Gaussian copula
    df <- testCopFam1(ind, "gauss_1", u1, u2, 1, 0.5)
    df2 <- testCopFam1(ind, "gauss_2", u1, u2, 1, -0.5)
    df <- rbind(df, df2)

    ## Student's t copula
    df1 <- testCopFam2(ind, "stud_1", u1, u2, 2, 0.5, 4)
    df2 <- testCopFam2(ind, "stud_2", u1, u2, 2, -0.5, 5)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## Clayton copula
    df1 <- testCopFam1(ind, "clay_1", u1, u2, 3, 4.1)
    df2 <- testCopFam1(ind, "clay_2", u1, u2, 3, 6.3)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## Gumbel copula
    df1 <- testCopFam1(ind, "gumb_1", u1, u2, 4, 4.3)
    df2 <- testCopFam1(ind, "gumb_2", u1, u2, 4, 1.2)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## Frank
    df1 <- testCopFam1(ind, "frank_1", u1, u2, 5, 4.3)
    df2 <- testCopFam1(ind, "frank_2", u1, u2, 5, 1.2)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## Joe
    df1 <- testCopFam1(ind, "joe_1", u1, u2, 6, 4.3)
    df2 <- testCopFam1(ind, "joe_2", u1, u2, 6, 1.2)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## BB1
    df1 <- testCopFam2(ind, "bb1_1", u1, u2, 7, 0.3, 2.2)
    df2 <- testCopFam2(ind, "bb1_2", u1, u2, 7, 1.2, 2.8)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## BB6
    df1 <- testCopFam2(ind, "bb6_1", u1, u2, 8, 4.3, 2.2)
    df2 <- testCopFam2(ind, "bb6_2", u1, u2, 8, 1.2, 1.1)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## BB7
    df1 <- testCopFam2(ind, "bb7_1", u1, u2, 9, 1.9, 0.3)
    df2 <- testCopFam2(ind, "bb7_2", u1, u2, 9, 1.2, 8.2)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    ## BB8
    df1 <- testCopFam2(ind, "bb8_1", u1, u2, 10, 4.3, 0.2)
    df2 <- testCopFam2(ind, "bb8_2", u1, u2, 10, 1.2, 0.4)
    df <- rbind(df, df1)
    df <- rbind(df, df2)

    return(df)
}

## evaluate tests
u1 <- 0.3
u2 <- 0.4
df1 <- pdfTest(u1, u2, 1)

u1 <- 0.2
u2 <- 0.8
df2 <- pdfTest(u1, u2, 2)

df <- rbind(df1, df2)

write.table(df, "data/r_cop_funcs_results.csv", row.names = FALSE,
            sep = ",")
