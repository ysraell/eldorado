#
# Makefile for use with LaTeX documents and presentations. 
# 13-10-17: Israel Oliveira <israel.olivera@ufrgs.br>
#
# General note: it is necessary use at least one bibliographic 
# reference, to avoid this, comment the macro 'bbl'. You may
# create a new command block to to distinguish the types and
# have the two possibilities.


#### Edit the line bellow:

# Example 4: Beamer presentation (Note: the '.ap' is very important!)
apn: ap_notes.ap.ver
capn: ap_notes.clean
rapn: ap_notes.clean ap_notes.ap.ver



########### Presentation in LaTeX with Beamer format

%.ap.bbl:
	echo $@
	pdflatex `echo $@ |sed -e 's/\.ap.bbl//g'`
	bibtex `echo $@ |sed -e 's/\.ap.bbl//g'`

%.ap.pdf: %.tex %.ap.bbl
	echo $@
	pdflatex `echo $@ |sed -e 's/\.ap.pdf//g'`
	pdflatex `echo $@ |sed -e 's/\.ap.pdf//g'`
	
%.ap.ver: %.ap.pdf
	echo $@
	evince `echo $< |sed -e 's/\.ap.pdf/.pdf/g'` 2>>/dev/null &
	
	

########### Geral

all: 
	echo "All"
	
clean:
	rm -f *.aux *.bbl *.blg *.lof *.log *.lot *.log *.toc *~ *.out *.nav *.snm *.pfg *.dvi *.ps

#OFM