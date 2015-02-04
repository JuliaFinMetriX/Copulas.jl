LIBRARY_DIR := src/VineCopulaCPP

all:
	git submodule init
	git submodule update
	make -C $(LIBRARY_DIR)
	julia -e 'try Pkg.installed("Requires"); catch; Pkg.clone("https://github.com/one-more-minute/Requires.jl.git") end'

clean:
	make clean -C $(LIBRARY_DIR)
