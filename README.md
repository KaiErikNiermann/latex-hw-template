# latex-hw-template

## Package docs resources

- [Algpseudocode](https://ctan.math.washington.edu/tex-archive/macros/latex/contrib/algpseudocodex/algpseudocodex.pdf)
- [Tikz (general)](https://tikz.dev/)
- [Simplebnf](https://mirrors.mit.edu/CTAN/macros/latex/contrib/simplebnf/simplebnf-doc.pdf)

## Snippets

The snippets are defined in `.vscode/tex.code-snippets`.

| Name                   | Prefix       | Purpose                      | Notes                                             |
| ---------------------- | ------------ | ---------------------------- | ------------------------------------------------- |
| Lean code              | `leancode`   | Lean code block              | Requires `minted` + `-shell-escape`.              |
| Math escape block      | `cmath`      | Display math (minted escape) | -                                                 |
| Inline math escape     | `imath`      | Inline math                  | Standard inline math.                             |
| Definition             | `defn`       | Definition environment       | Assumes a `definition` env (e.g., via `amsthm`).  |
| Code                   | `code`       | Generic minted code block    | Choose language via placeholder.                  |
| Graphic                | `fig`        | Figure with caption/label    | Escape underscores in filenames.                  |
| List                   | `list`       | Itemize list                 | -                                                 |
| Enumerate              | `enum`       | Numbered list                | -                                                 |
| Item                   | `item`       | List item                    | Useful inside list environments.                  |
| Env                    | `env`        | Generic environment wrapper  | Fill environment name and body.                   |
| Formal Algorithm       | `formalalgo` | Algorithm + algorithmic      | Needs `algorithm` + `algorithmicx`.               |
| Equation               | `eqn`        | Numbered equation (with tag) | Optional custom tag placeholder.                  |
| Cases                  | `cases`      | Piecewise cases structure    | Use inside math mode (`equation`, `align`, etc.). |
| Aligned Env            | `aligned`    | Multi-line aligned math      | Use inside math mode.                             |
| Aligned Line           | `aline`      | One aligned line             | Provides placeholder for next line.               |
| Theorem                | `thm`        | Theorem environment          | Assumes `theorem` env defined (`amsthm`).         |
| Lemma                  | `lem`        | Lemma environment            | Assumes `lemma` env defined.                      |
| Footnote               | `fn`         | Footnote                     | -                                                 |
| For each tikz          | `tikzfor`    | TikZ `\foreach` loop         | Requires `tikz`.                                  |
| Standalone tikzpicture | `stktz`      | Standalone TikZ document     | Useful for compiling figures separately.          |

Note: If you are new to vscode snippets, see [this guide](https://code.visualstudio.com/docs/editor/userdefinedsnippets). But the tldr is to just type the prefix and hit tab. Some snippets have placeholders you can fill out then hit tab to go to the next placeholder. Within the snippet definition `$1`, `$2`, etc. denote placeholders, and `${1:default}` denotes a placeholder with a default value.

## Project structure

General info about the project structure, i.e. purpose of files and folders.

- `main.tex`: Main LaTeX document.
- `figures/`: Directory for TikZ styles and external figures.
  - `custom_tikz.sty`: Custom TikZ styles for the project.
- `references.bib`: BibTeX bibliography file.
- `.vscode/`: VSCode configuration files for LaTeX development.
  - `settings.json`: Settings for LaTeX Workshop extension.
  - `tex.code-snippets`: Custom LaTeX code snippets for VSCode.
  - `extensions.json`: Recommended VSCode extensions for LaTeX work.
- `assets/`: Directory for additional assets (images, data files, etc.).
- `scripts/`: Directory for install utility scripts (requirement: ubuntu/debian).
- `INSTALL.md`: Installation instructions for required tools and packages.
- `Makefile`: Makefile providing command `make clean` to clean auxiliary files. (hidden by default in VSCode explorer)
- `html/`: Directory containing scripts to build HTML version of the document.
  - `build.sh`: Script to convert LaTeX to HTML using Pandoc.
  - `styles.css`: CSS styles for the HTML output.
  - `header.html`: Header to include MathJax in the HTML output.

## HTML export + inference rules

- Run `make html` (or just `make`) to generate `html/main.html` using Pandoc + MathJax. The script auto-loads the header + stylesheet and works from any working directory.

## Type Settings notes

- `minted` : For some reason only `pdflatex` seems to draw `\texttt{}` using *inconsoloas* font as opposed to the much worse looking alternatives. Both `latexmk` and `lualatex` for some reason fall back to a different font for `\texttt{}`, unsure why. So the default right now is to use `pdflatex` for the document build and use `lualatex` only for standalone TikZ figures as they require it for certian features.
