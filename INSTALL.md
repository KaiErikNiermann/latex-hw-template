# Tools

## [Tex format](https://github.com/WGUNDERWOOD/tex-fmt)

### Cargo

1. Install the stable release with:

    ```sh
    cargo install tex-fmt
    ```

    if you don't have cargo, install Rust (and cargo) with:

    ```sh
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```

    Make sure to restart your terminal or source your profile to have cargo in your PATH.

2. Verify installation with:

    ```sh
    tex-fmt --version
    ```

3. (Optional) If the extension doesnt seem to find `tex-fmt`, you can find its path with:

    ```sh
    which tex-fmt
    ```

    and then set it in your VSCode settings under `latex-workshop.formatting.tex-fmt.path`. See `.vscode/settings.json` for an example.

## Minted

For code highlighting using the `minted` package, you need to have Python and Pygments installed. The two main packages are:

- `texlive-latex-extra` (for TeX Live users)
- `python3-pygments` (or `python-pygments` on some systems)
