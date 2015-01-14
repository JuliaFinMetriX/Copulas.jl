function pdf(cop::ParamPC, u::Float64, v::Float64)
    ## get family and parameters
    fam = float(getCopId(cop))
    params = cop.params

    @mput fam u v params
    val = @matlab PairCopulaPDF(fam, u, v, params)
    return val
end
