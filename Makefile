CLEAN_EXTENSIONS = aux log out toc synctex.gz fdb_latexmk fls bcl blg bbl run.xml
HTML_OUTPUT = html/main.html

all: $(HTML_OUTPUT)

$(HTML_OUTPUT): main.tex html/build.sh html/header.html html/style.css
	@echo "Building HTML document..."
	@bash html/build.sh
	@echo "HTML ready at $(HTML_OUTPUT)."

clean:
	@echo "Cleaning LaTeX build artifacts..."
	@find . -type f \( $(foreach ext,$(CLEAN_EXTENSIONS), -name '*.$(ext)' -o) -false \) -exec rm -f {} +
	@echo "Clean complete."

.PHONY: clean html all

html: $(HTML_OUTPUT)