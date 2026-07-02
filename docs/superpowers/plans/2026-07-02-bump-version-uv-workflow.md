# Toolbox Version Bump + uv Build Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Point the website's toolbox download at the `main` branch, unify the getting-started instructions, and replace the manual Sphinx build/copy workflow with a uv-managed one-command publish script.

**Architecture:** This repo is a Sphinx docs site whose *built HTML is committed at the repo root* (GitHub Pages serves the root at www.gdsge.com; `CNAME` and `.nojekyll` live there). Source lives in `source/`. We add a uv-managed Python environment (`pyproject.toml` + `uv.lock` committed, `.venv/` ignored) and a `publish.ps1` that builds into `build/html/` and copies the result over the root.

**Tech Stack:** Sphinx (+ sphinx-rtd-theme, rst2pdf — all three required by `source/conf.py`), uv, PowerShell 5.1, git.

## Global Constraints

- There is no test suite; "tests" for this repo are: the Sphinx build exits 0 and the rendered HTML contains the expected strings. Every task's verification uses those checks.
- The Sphinx source of truth is `source/`; files at the repo root (`index.html`, `_static/`, etc.) are build artifacts — never hand-edit them.
- Do not touch `CNAME` or delete root files; the publish step only overwrites.
- Download URL must be exactly `https://github.com/gdsge/gdsge/archive/refs/heads/main.zip` and the unzipped folder is `gdsge-main`.
- End every git commit message with these two trailer lines:
  `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`
  `Claude-Session: https://claude.ai/code/session_01WFg9BDLmNJk2tturuMaRSz`
- All commands below run from the repo root `D:\gdsge.github.io` in PowerShell 5.1 (no `&&`; use `;` or separate calls).

---

### Task 1: Housekeeping — .gitignore and remove debug.log

**Files:**
- Modify: `.gitignore` (currently contains only `build/`)
- Delete (from git): `debug.log`

**Interfaces:**
- Produces: `.venv/` is ignored before Task 2 runs `uv sync`, so the venv never shows up as untracked noise.

- [ ] **Step 1: Replace `.gitignore` contents**

New full contents of `.gitignore`:

```gitignore
build/
.venv/
task20260702_bump_version.md
debug.log
```

- [ ] **Step 2: Remove the committed debug.log**

Run: `git rm debug.log`
Expected: `rm 'debug.log'`

- [ ] **Step 3: Verify git status is clean of noise**

Run: `git status --short`
Expected output contains `M  .gitignore` (staged after add) and `D  debug.log`, and does NOT list `task20260702_bump_version.md`.

- [ ] **Step 4: Commit**

```powershell
git add .gitignore
git commit -m @'
chore: gitignore venv, task notes, debug.log; remove committed debug.log

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01WFg9BDLmNJk2tturuMaRSz
'@
```

---

### Task 2: uv-managed Sphinx environment

**Files:**
- Create: `pyproject.toml`
- Create (generated): `uv.lock` (via `uv sync`; committed)

**Interfaces:**
- Consumes: `.gitignore` from Task 1 (ignores `.venv/`).
- Produces: a working `uv run sphinx-build` command that Tasks 3 and 4 rely on.

- [ ] **Step 1: Create `pyproject.toml`**

Full contents:

```toml
[project]
name = "gdsge-website"
version = "0.2.0"
description = "Sphinx build environment for the GDSGE toolbox website (www.gdsge.com)"
requires-python = ">=3.11"
dependencies = [
    "sphinx",
    "sphinx-rtd-theme",
    "rst2pdf",
]

[tool.uv]
package = false
```

- [ ] **Step 2: Create the environment**

Run: `uv sync`
Expected: resolves and installs packages, creates `.venv/` and `uv.lock`, exit code 0.

- [ ] **Step 3: Verify the Sphinx build works with the new environment (source is still unmodified — this tests the toolchain only)**

Run: `uv run sphinx-build -M html source build`
Expected: exits 0, final line `The HTML pages are in build\html.` Warnings are acceptable; errors are not.

**If this fails with an error naming `rst2pdf` or `rst2pdf.pdfbuilder`** (version incompatibility with latest Sphinx): edit `pyproject.toml` to replace the `"sphinx"` dependency line with `"sphinx>=7,<8"`, run `uv sync`, and repeat this step. If it still fails, stop and report the full error — do not work around it by editing `source/conf.py`.

- [ ] **Step 4: Verify the theme rendered**

Run: `Select-String -Path build/html/index.html -Pattern 'sphinx_rtd_theme|css/theme.css' | Select-Object -First 1`
Expected: at least one match.

- [ ] **Step 5: Verify git only sees the two config files**

Run: `git status --short`
Expected: `?? pyproject.toml` and `?? uv.lock` (plus nothing from `.venv/` or `build/`).

- [ ] **Step 6: Commit**

```powershell
git add pyproject.toml uv.lock
git commit -m @'
build: manage Sphinx environment with uv

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01WFg9BDLmNJk2tturuMaRSz
'@
```

---

### Task 3: Rewrite index-page getting-started section

**Files:**
- Modify: `source/index.rst:20-38`

**Interfaces:**
- Consumes: `uv run sphinx-build` from Task 2.
- Produces: rebuilt `build/html/index.html` containing the `main.zip` URL (Task 4 publishes it to the root).

- [ ] **Step 1: Replace the getting-started block**

In `source/index.rst`, replace this exact block (currently lines 20–38):

```rst
GDSGE can now run on MATLAB Online! Log into the `MATLAB Online <https://matlab.mathworks.com>`_. And run in the MATLAB command window

.. code-block:: MATLAB

   websave('gdsge.zip','https://github.com/gdsge/gdsge/archive/refs/tags/v0.1.5.zip')
   unzip gdsge.zip
   mex -setup c++
   cd gdsge-0.1.5/tests
   runtests

These commands download the latest version of the toolbox, setup the mex compiler, and run the test examples.
These produce all results in the companion paper |paper_link|.

With MATLAB on a local machine, try running the leading example, :ref:`Heaton and Lucas (1996) <HL1996>`, 
by downloading the toolbox source code at https://github.com/gdsge/gdsge/releases, and compiling the gmod file :download:`HL1996 <example/HL1996/HL1996.gmod>` by running in MATLAB

.. code-block:: MATLAB

   gdsge_codegen('HL1996')
```

with:

```rst
To get started, run in the MATLAB command window

.. code-block:: MATLAB

   websave('gdsge.zip','https://github.com/gdsge/gdsge/archive/refs/heads/main.zip')
   unzip gdsge.zip
   mex -setup c++
   cd gdsge-main/tests
   runtests

These commands download the latest version of the toolbox, set up the mex compiler, and run the test examples.
This works on Windows, macOS, and `MATLAB Online <https://matlab.mathworks.com>`_ (Linux).
These produce all results in the companion paper |paper_link|.

Then try the leading example, :ref:`Heaton and Lucas (1996) <HL1996>`, by compiling the gmod file :download:`HL1996 <example/HL1996/HL1996.gmod>`: run in MATLAB

.. code-block:: MATLAB

   gdsge_codegen('HL1996')
```

Everything after this block (the `|paper_link|` raw-HTML definition, the "toolbox source code is hosted at" sentence, the toctree) stays untouched.

- [ ] **Step 2: Verify no old-version references remain anywhere in source**

Run: `Get-ChildItem source -Recurse -Filter *.rst | Select-String -Pattern 'v0\.1\.5|gdsge-0\.1|gdsge/releases'`
Expected: no matches at all.

- [ ] **Step 3: Rebuild and verify the rendered page**

Run: `uv run sphinx-build -M html source build`
Expected: exit 0.

Run: `Select-String -Path build/html/index.html -Pattern 'refs/heads/main\.zip'`
Expected: at least one match.

Run: `Select-String -Path build/html/index.html -Pattern 'v0\.1\.5'`
Expected: no matches.

- [ ] **Step 4: Commit (source only — built output is published and committed in Task 4)**

```powershell
git add source/index.rst
git commit -m @'
docs: point download at main branch, unify getting-started for all platforms

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01WFg9BDLmNJk2tturuMaRSz
'@
```

---

### Task 4: Publish script, remove stale targets, publish the site

**Files:**
- Create: `publish.ps1`
- Modify: `Makefile:16-18` (delete the `github` target)
- Delete: `make_github.bat`
- Modify (generated): root build artifacts (`index.html`, `_static/`, `searchindex.js`, etc.)

**Interfaces:**
- Consumes: `uv run sphinx-build` (Task 2), updated `source/index.rst` (Task 3).
- Produces: `publish.ps1` — the one command that rebuilds and republishes the site from now on.

- [ ] **Step 1: Create `publish.ps1`**

Full contents:

```powershell
# Build the Sphinx site and publish it to the repo root (served by GitHub Pages).
# Usage: .\publish.ps1
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

uv run sphinx-build -M clean source build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

uv run sphinx-build -M html source build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Copy-Item -Path build/html/* -Destination . -Recurse -Force
Write-Host 'Published build/html to repo root.'
```

- [ ] **Step 2: Delete the stale `github` target from `Makefile`**

Remove these three lines (16–18) from `Makefile`:

```makefile
github:
	@make html
	@cp -a build/html/. ./docs
```

- [ ] **Step 3: Delete `make_github.bat`**

Run: `git rm make_github.bat`
Expected: `rm 'make_github.bat'`

- [ ] **Step 4: Run the publish script**

Run: `.\publish.ps1`
Expected: clean build output, then HTML build output ending `The HTML pages are in build\html.`, then `Published build/html to repo root.` Exit code 0.

- [ ] **Step 5: Verify the published root**

Run: `Select-String -Path index.html -Pattern 'refs/heads/main\.zip'`
Expected: at least one match.

Run: `Select-String -Path index.html -Pattern 'v0\.1\.5'`
Expected: no matches.

Run: `Get-Content CNAME`
Expected: still prints the custom domain (unchanged by publish).

Run: `Test-Path .nojekyll`
Expected: `True`.

- [ ] **Step 6: Commit everything (script, Makefile, deleted bat, republished site)**

```powershell
git add -A
git status --short
```

Inspect the status output: it must NOT contain `.venv/`, `build/`, `debug.log`, or `task20260702_bump_version.md`. Then:

```powershell
git commit -m @'
build: add publish.ps1, drop stale docs/ targets, republish site

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01WFg9BDLmNJk2tturuMaRSz
'@
```

- [ ] **Step 7: Final sanity check of the whole plan's outcome**

Run: `git log --oneline -5`
Expected: the four commits from Tasks 1–4 on top of `fddef7b` (the spec commit).

Run: `git status --short`
Expected: empty output.
