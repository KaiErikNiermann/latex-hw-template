CLEAN_EXTENSIONS = aux log out toc synctex.gz fdb_latexmk fls

clean:
	@echo "Cleaning LaTeX build artifacts..."
	@find . -type f \( $(foreach ext,$(CLEAN_EXTENSIONS), -name '*.$(ext)' -o) -false \) -exec rm -f {} +
	@echo "Clean complete."