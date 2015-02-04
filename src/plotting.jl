## function addAuth(name::String, key::String)
##     # write authentication settings to file

##     dirPath = joinpath(Pkg.dir("Copulas"), "NO_GIT")
##     run(`mkdir -p $dirPath`)

##     filePath = string(dirPath, "/plotly.auth")

##     f = open(filePath, "w")
##     write(f, name)
##     write(f, "\n")
##     write(f, key)
##     close(f)
    
## end

## function getAuth()
##     dirPath = joinpath(Pkg.dir("Copulas"), "NO_GIT")
##     filePath = string(dirPath, "/plotly.auth")

##     f = open(filePath)
##     kk = readlines(f)
##     close(f)

##     name = strip(kk[1])
##     key = strip(kk[2])
##     return name, key
## end

## function signIn()
##     name, key = getAuth()
##     Plotly.signin(name, key)
## end


## function plot(cop::PairCop, n::Int64)
##     grid = linspace(0, 1, n)
##     grid[1] = 0.001
##     grid[end] = 0.999

##     pdfVals = Float64[Copulas.pdf(cop, u1, u2)[1] for u1 in grid,
##                       u2 in grid]
##     data = [
##             [
##              "z" => pdfVals, 
##              "x" => grid, 
##              "y" => grid, 
##              "type" => "surface"
##              ]
##             ]
##     layout = [
##   "xaxis" => [
##     "range" => [0, 1], 
##     "type" => "linear", 
##     "autorange" => false, 
##     "autotick" => false, 
##     "ticks" => "outside", 
##     "tick0" => 0, 
##     "dtick" => 0.1, 
##     "ticklen" => 8, 
##     "tickwidth" => 4
##   ], 
##   "yaxis" => [
##     "range" => [0, 1], 
##     "type" => "linear", 
##     "autorange" => false, 
##     "autotick" => false, 
##     "dtick" => 0.1
##   ]
## ]
##     response = Plotly.plot(data, ["layout" => layout, "filename" => "cop-pdf-contour", "fileopt" => "overwrite"])
##     plot_url = response["url"]
##     return plot_url
## end
    
