# latex-hw-template

## Package docs resources

- [Algpseudocode](https://ctan.math.washington.edu/tex-archive/macros/latex/contrib/algpseudocodex/algpseudocodex.pdf)
- [Tikz (general)](https://tikz.dev/)
- [Simplebnf](https://mirrors.mit.edu/CTAN/macros/latex/contrib/simplebnf/simplebnf-doc.pdf)

## Snippets

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
