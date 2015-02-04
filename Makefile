LIBRARY_DIR := src/VineCopulaCPP

all:
	julia -e 'try Pkg.installed("Requires"); catch; Pkg.clone("https://github.com/one-more-minute/Requires.jl.git") end'
	git submodule init
	git submodule update
	make -C $(LIBRARY_DIR)

clean:
	make clean -C $(LIBRARY_DIR)
