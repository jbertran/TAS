.PHONY: all clean

all: rapport

rapport: rapport.tex rapport.bib
	pdflatex rapport.tex
	bibtex rapport
	pdflatex rapport.tex
	pdflatex rapport.tex

clean:
	rm *.log *.aux *.bbl *.blg *.out *.toc
