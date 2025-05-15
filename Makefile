# add to PROJECTS variable all the projects to compile, without the .tex suffix
PROJECTS = kowalksi-intro

BUILDDIR = build
OUTPUT_IMAGESDIR = $(BUILDDIR)/images
DOCUMENTS = $(addprefix $(BUILDDIR)/,$(addsuffix .pdf,$(PROJECTS)))
SCREENSHOTS = $(addprefix $(OUTPUT_IMAGESDIR)/, $(patsubst %,%-screenshot,$(PROJECTS)))


all: documents screenshots

documents: $(DOCUMENTS)

$(BUILDDIR)/%.pdf: %.tex | $(BUILDDIR)
	xelatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $<
	echo "# Kowaslki introdution slides" > README.md

screenshots:	$(SCREENSHOTS)

$(OUTPUT_IMAGESDIR)/%-screenshot: $(BUILDDIR)/%.pdf
	rm -fv $(OUTPUT_IMAGESDIR)/*.png
	gs -dBATCH -dNOPAUSE -dSAFER -r600 -sDEVICE=pngalpha -sOutputFile=$(OUTPUT_IMAGESDIR)/$*-%02d.png $<
	touch $@
	@for im in build/images/*.png; do \
		echo "!\[Screenshot\]($$im)" >> README.md; \
	done

$(BUILDDIR):
	mkdir -p $(BUILDDIR) $(OUTPUT_IMAGESDIR)

clean:
	rm -f $(BUILDDIR)/{*.snm,*.out,*.toc,*.pdf,*.aux,*.log,*.nav,*.vrb} $(OUTPUT_IMAGESDIR)/*

.PHONY: all clean screenshots dir test
