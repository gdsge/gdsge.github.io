# gdsge.github.io
Welcome to GDSGE’s documentation!

GDSGE is a toolbox that solves nonlinear Dynamic Stochastic General Equilibrium (DSGE) models 
with a global method based on policy iterations introduced in [Cao, Luo, and Nie (2020)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3569013). It allows users to define economic models in compact and intuitive scripts, called gmod files (gmod stands for global model). It parses the script into dynamic libraries which implement the actual computations (policy function iterations and Monte Carlo simulations) efficiently in C++, 
and provides a convenient MATLAB interface to researchers.

The toolbox can be used to solve models in macroeconomics, international finance, asset pricing, and related fields.

Try running your first example, Heaton and Lucas (1996), by uploading the gmod file [HL1996](http://www.gdsge.com/_downloads/791c376360c9be721407d670f16fbf7d/HL1996.gmod)
to an online compiler server deployed at

[[Windows](http://122.112.231.135/)] [[MacOS](http://166.111.98.85:20000/)]

More examples and detailed instructions on gmod files and on how to use the toolbox are provided on the compiled website
[www.gdsge.com](http://www.gdsge.com/)
