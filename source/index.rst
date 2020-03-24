.. GDSGE documentation master file, created by
   sphinx-quickstart on Thu Feb  6 16:44:37 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to GDSGE's documentation! 

GDSGE is a toolbox that solves nonlinear Dynamic Stochastic General Equilibrium (DSGE) models with a global method based on policy iterations
introduced in paper :download:`Cao, Luo, and Nie (2020) <paper/GDSGE_paper.pdf>`.
It allows users to define economic models in a compact and intuitive script.
It parses the script, implements the actual computations with high performance in C++, and provides a convenient MATLAB interface to researchers.

The toolbox can be used to solve models in macroeconomics, international finance, asset pricing, etc.

Try running your first example, :ref:`Heaton and Lucas (1996) <HL1996>`, 
by uploading the gmod file :download:`HL1996 <example/HL1996/HL1996.gmod>` to an online compiler server deployed at

[`Windows 1 <http://122.112.231.135/>`_] [`Windows 2 <http://166.111.98.85:30000/>`_] [`MacOS <http://166.111.98.85:20000/>`_] 


And see more examples below.

=================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   
   example/rbc/rbc
   example/rbc/rbcIrr
   example/HL1996/HL1996
   example/Cao2018/Cao2018
   example/Bianchi2011/Bianchi2011
   example/Mendoza2010/Mendoza2010
   example/safe_assets/safe_assets
   usage/functions



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
