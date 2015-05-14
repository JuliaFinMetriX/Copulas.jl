LIBRARY_DIR := src/VineCopulaCPP

all:
	make -C $(LIBRARY_DIR)

clean:
	make clean -C $(LIBRARY_DIR)
