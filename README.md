# GDSGE: A Toolbox for Solving DSGE Models with Global Methods

GDSGE is a toolbox that solves nonlinear Dynamic Stochastic General Equilibrium (DSGE) models with a global method based on the Simultaneous Transition and Policy Function Iteration (STPFI) algorithm introduced in [Cao, Luo and Nie (2023)](https://www.sciencedirect.com/science/article/pii/S1094202523000017).
It allows users to define economic models in compact and intuitive scripts, called gmod files (gmod stands for global model). It parses the script into dynamic libraries which implement the actual computations (policy function iterations and Monte Carlo simulations) efficiently in C++, and provides a convenient MATLAB interface to researchers.

The toolbox can be used to solve models in macroeconomics, international finance, asset pricing, and related fields.

Examples and detailed instructions on developing gmod files using the toolbox are provided on the website [www.gdsge.com](http://www.gdsge.com/)

Toolbox source code can be found at [github.com/gdsge/gdsge](http://github.com/gdsge/gdsge)
