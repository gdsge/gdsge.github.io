# Design: Toolbox version bump + uv-managed build workflow

**Date:** 2026-07-02
**Repo:** gdsge.github.io (website for the GDSGE toolbox, served by GitHub Pages from the repo root at www.gdsge.com)

## Background

The website's getting-started instructions pin the toolbox download to the
`v0.1.5` tag. The toolbox repo (github.com/gdsge/gdsge, local copy at
`D:\gdsge_publish`) is now at v0.2.0 on `main` after a ground-up refactor.
The site build workflow is manual (`make clean`, `make html`, hand-copy
`build/html/*` over the repo root) and the Python environment that built the
site no longer exists locally.

## Goals

1. Point the download instructions at the toolbox's `main` branch so the URL
   never needs bumping again.
2. Simplify the index page: one common install flow for all platforms, no
   separate "download from releases" path.
3. Manage the Sphinx build environment with uv (config committed, binaries
   ignored).
4. Replace the manual build-and-copy workflow with a one-command script.

## Changes

### 1. Index page getting-started rewrite (`source/index.rst`)

Merge the two install paths (MATLAB Online + local-machine-via-releases) into
one common flow:

- Code block becomes:

  ```matlab
  websave('gdsge.zip','https://github.com/gdsge/gdsge/archive/refs/heads/main.zip')
  unzip gdsge.zip
  mex -setup c++
  cd gdsge-main/tests
  runtests
  ```

- Follow-up text states these commands download the latest version of the
  toolbox, set up the mex compiler, and run the test examples; that this works
  on Windows, macOS, and MATLAB Online (Linux, linked to
  https://matlab.mathworks.com); and that these produce all results in the
  companion paper (existing `|paper_link|` substitution).
- Remove the sentence pointing to https://github.com/gdsge/gdsge/releases.
- Keep the Heaton and Lucas (1996) leading-example paragraph, trimmed: no
  separate download instruction (the toolbox is already on disk from the
  websave step); keep the `:download:` link to the gmod file and the
  `gdsge_codegen('HL1996')` code block.
- The later sentence "The toolbox source code is hosted at
  https://github.com/gdsge/gdsge ..." stays as-is.
- No other source page references the old version (verified by grep).

### 2. uv environment

- New `pyproject.toml` at repo root declaring docs dependencies: `sphinx`,
  `sphinx-rtd-theme`, `rst2pdf` (all three required by `source/conf.py`).
- Start with current package versions; pin only if the build breaks. Known
  friction points with modern Sphinx: the custom Pygments GDSGE lexer and the
  `rst2pdf.pdfbuilder` extension in `conf.py`.
- Commit `pyproject.toml` and `uv.lock`. Gitignore `.venv/`.

### 3. Publish script

New `publish.ps1` at repo root replacing the manual workflow:

1. `uv run sphinx-build -M clean source build`
2. `uv run sphinx-build -M html source build`
3. Copy `build/html/*` over the repo root (`CNAME` is untouched; it is not in
   the build output).

Delete the stale `make github` Makefile target and `make_github.bat` — both
copy to a `docs/` folder that never matched how the site is served.

Known limitation (accepted): copying over root does not delete files for pages
removed from source — same as the old workflow. A fully-synced deploy would
require the GitHub Actions route, out of scope here.

### 4. Housekeeping

- `.gitignore` gains: `.venv/`, `task20260702_bump_version.md`, `debug.log`.
- `git rm` the committed `debug.log` at repo root.

### 5. Verification

- Run `publish.ps1`.
- Confirm the rendered root `index.html` contains the new `main.zip` URL and
  the theme/math render correctly (spot-check in a browser or by inspecting
  the HTML).
- Commit source and built output together.

## Out of scope

- GitHub Actions CI deploy (considered, rejected for now: requires Pages
  settings change and repo restructure).
- Any content changes beyond the index-page getting-started section.
