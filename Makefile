PIC_SRCES = pics_src
PICS_DIR = pics

PICS = pics/cop_type_hierarchy.svg pics/cop_modifications.svg

all: $(PICS)

pics/cop_type_hierarchy.svg: $(PIC_SRCES)/cop_type_hierarchy.dot
	dot -Tsvg -o $@ $<

pics/cop_modifications.svg: $(PIC_SRCES)/cop_modifications.dot
	dot -Tsvg -o $@ $<
