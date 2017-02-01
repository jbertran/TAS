.PHONY: all clean

all: presentation.pdf

%.pdf: %.tex
	pdflatex $^

clean:
	rm *.log *.aux
