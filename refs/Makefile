HTML_OUTPUT := -nodoc -dl
BIB_STYLE := -s alpha
SKIP_FIELDS := -noabstract -nokeywords -noheader
ALL_FLAGS := ${HTML_OUTPUT} ${SKIP_FIELDS} ${BIB_STYLE}

####################################
## get list of all page ref files ##
####################################

KEYS_DIR := page_keys
HTML_DIR := html_refs

PAGE_KEY_FILE_STEMS := $(notdir $(wildcard $(KEYS_DIR)/*.txt))
HTML_FILE_NAMES := $(patsubst %.txt,%.html,$(PAGE_KEY_FILE_STEMS))
HTML_FULL_NAMES := $(addprefix $(HTML_DIR)/,$(HTML_FILE_NAMES)) 

all: ${HTML_FULL_NAMES}

# run bibtex2html from html directory - otherwise links to bib files were wrong 
html_refs/%.html: page_keys/%.txt refs.bib
	cd ./${HTML_DIR} && bibtex2html ${ALL_FLAGS} -o $(*F) -citefile ../$< ../refs.bib
