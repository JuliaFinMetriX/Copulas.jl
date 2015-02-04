LIBRARY_DIR := src/VineCopulaCPP

all:
	git submodule init
	git submodule update
	make -C $(LIBRARY_DIR)
	julia -e 'Pkg.clone("https://github.com/one-more-minute/Requires.jl.git")'

clean:
	make clean -C $(LIBRARY_DIR)
