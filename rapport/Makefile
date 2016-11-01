.PHONY: all clean

all: rapport

rapport: rapport.md
	pandoc rapport.md --variable documentclass=article --variable classoption=titlepage -H preamble.tex -o rapport.pdf --listings --number-sections --toc
