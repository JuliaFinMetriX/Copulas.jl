Creating references
===================


Add entry to bibtex file
------------------------

Copy entry to file refs/refs.bib.


Add reference to page
---------------------

All references of a given page need to be listed in a text file that
resides in directory *refs/page_keys/*. The text file lists references
as bibtex keys. The name of the text file determines the name of the
respective html reference file. For example, *gauss.txt* in
*refs/page_keys/* will create files *gauss.html* and *gauss_bib.html*
in directory *refs/html_refs/*.

To embed the html reference on the respective page, simply add it as
``iframe`` object:

    <iframe src="../refs/html_refs/gauss.html" width="600" height="200"></iframe>

In order to enable links to header references, add a linkable name to
the header:

    <a name="refs"></a>

Add the respective place where the citation should appear, add the
following internal link (of course, with the respective citation key):

    [[Joe14]](#refs).

To create all html files, simply type ``make`` in subdirectory refs.

