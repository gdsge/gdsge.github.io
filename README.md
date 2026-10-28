# GDSGE: A Toolbox for Solving DSGE Models with Global Methods

GDSGE is a toolbox that solves nonlinear Dynamic Stochastic General Equilibrium (DSGE) models with a global method based on the Simultaneous Transition and Policy Function Iteration (STPFI) algorithm introduced in [Cao, Luo and Nie (2023)](https://www.sciencedirect.com/science/article/pii/S1094202523000017).
It allows users to define economic models in compact and intuitive scripts, called gmod files (gmod stands for global model). It parses the script into dynamic libraries which implement the actual computations (policy function iterations and Monte Carlo simulations) efficiently in C++, and provides a convenient MATLAB interface to researchers.

The toolbox can be used to solve models in macroeconomics, international finance, asset pricing, and related fields.

Examples and detailed instructions on developing gmod files using the toolbox are provided on the website [www.gdsge.com](http://www.gdsge.com/)

Toolbox source code can be found at [github.com/gdsge/gdsge](http://github.com/gdsge/gdsge)

## Building this website

The site is built with Sphinx; [uv](https://docs.astral.sh/uv/) manages the Python environment
(`pyproject.toml` + `uv.lock`, no conda needed). Sources live in `source/`; the built HTML is
copied to the repo root, which GitHub Pages serves.

```powershell
uv sync                          # once: create .venv from uv.lock
powershell -File publish.ps1     # clean build into build/html, then copy it to the repo root
```

For a quick preview without publishing: `uv run sphinx-build -M html source build`, then open
`build/html/index.html`.
