LIBRARY_DIR := src/VineCopulaCPP

all:
	git submodule init
	git submodule update
	make -C $(LIBRARY_DIR)

clean:
	make clean -C $(LIBRARY_DIR)
