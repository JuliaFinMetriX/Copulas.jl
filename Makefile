PIC_SRCES = pics_src
PICS_DIR = pics

PICS = pics/cop_type_hierarchy.svg


pics/cop_type_hierarchy.svg: $(PIC_SRCES)/cop_type_hierarchy.dot
	dot -Tsvg -o $@ $<
