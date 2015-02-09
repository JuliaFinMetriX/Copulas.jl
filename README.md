# Copulas

[![Build
Status](https://travis-ci.org/JuliaFinMetriX/Copulas.jl.svg?branch=master)](https://travis-ci.org/JuliaFinMetriX/Copulas.jl)
[![Coverage
Status](https://coveralls.io/repos/JuliaFinMetriX/Copulas.jl/badge.svg?branch=master)](https://coveralls.io/r/JuliaFinMetriX/Copulas.jl?branch=master) 

This package provides functionality to estimate, analyze and simulate
bivariate and multivariate copula models. At its core most bivariate
functionality currently is built upon the [VineCopulaCPP C++
package](https://github.com/MalteKurz/VineCopulaCPP) of [Malte
Kurz](http://www.finmetrics.statistik.uni-muenchen.de/personen/mitarbeiter/malte_kurz/index.html).
Multivariate extensions to pair copula constructions (vine copulas)
are mostly implemented in native Julia code.

## Documentation

You can access the documentation [here](http://juliafinmetrix.github.io/Copulas.jl/).

## Installation

### Requirements

As the package makes use of the [VineCopulaCPP C++
package](https://github.com/MalteKurz/VineCopulaCPP), it also shares
the same requirements to some further libraries. On Ubuntu 14.04 they
can easily be installed with the following commands:

````
sudo apt-get -y install libboost-all-dev
sudo apt-get -y install libnlopt-dev
sudo apt-get -y install libgomp1
````

For some linux distributions there might be no [nlopt
library](http://ab-initio.mit.edu/wiki/index.php/NLopt) available
through the official package repository. In this case, simply download
the package directly from the nlopt webpage. For additional resources
for the installation of additional requirements take a look at the
`.travis.yml` file in the package's repository.

### Compilation

Once that you have installed all software dependencies, you need to
compile the underlying C++ library. Therefore, the C++ source code is
added to the repository as a git submodule residing in
`/src/VineCopulaCPP`. In order to directly get the source code
together with the repository, you can clone both with command

````
git clone --recursive https://github.com/JuliaFinMetriX/Copulas.jl.git
````

Alternatively, the package also comes with a `Makefile` that does the
job for you. In the package directory, simply type

````
make
````

### Problems

#### Fortran code

Calling `make` will cause `VineCopulaCPP` to download the [MVTDST
Fortran
90](http://www.math.wsu.edu/faculty/genz/software/fort77/mvtdstpack.f)
library of Alan Genz. In order to correctly compile this library you
also need a fortran compiler, e.g. `gfortran`.

#### C++ function names

`Copulas` currently calls C++ code, which is not yet natively
supported by Julia. C++ code can be called through Julia's built-in
functionality for C code, but still needs to take into account some
additional [name
mangling](http://en.wikipedia.org/wiki/Name_mangling). In other words,
calling function `PairCopulaPDF` in C++ requires to adapt the function
name with pre- and suffix which depend on input and output types of
the function, but should also be *system dependent*. For example,
`PairCopulaPDF` must be called as `_Z13PairCopulaPDFiPKdPdS1_S1_j` on
Ubuntu 14.04. 

These modified names are specified in
`/src/ParamPCs_Cpp/ParamPC_Cpp.jl`. If they do not work for you,
simply adapt them to your needs. In order the get the names on your
system, call 

````
nm -D /src/VineCopulaCPP/libVineCPP.so.1.0
````
to list all functions with mangled names and adapt them accordingly in
`/src/ParamPCs_Cpp/ParamPC_Cpp.jl`. 

# Copula theory


For details on the underlying copula theory take a look at my [research
notes](http://cgroll.github.io/copula_theory/index.html).

# Acknowledgements

In its current version, `Copulas.jl` basically is only a wrapper to
the fabulous
[VineCopulaCPP](https://github.com/MalteKurz/VineCopulaCPP) c++
library of [Malte Kurz](https://github.com/MalteKurz). `VineCopulaCPP`
is a well tested library comprising parametric copulas with all
their respective functions (pdf, cdf,...), as well as simulation
routines and optimization algorithms for copula estimation.

