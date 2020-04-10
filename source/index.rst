.. GDSGE documentation master file, created by
   sphinx-quickstart on Thu Feb  6 16:44:37 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

============================================================
GDSGE: A Toolbox for Solving DSGE Models with Global Methods
============================================================

Welcome to GDSGE's documentation! 

GDSGE is a toolbox that solves nonlinear Dynamic Stochastic General Equilibrium (DSGE) models with a global method based on policy iterations
introduced in |paper_link|.
It allows users to define economic models in compact and intuitive scripts, called gmod files (gmod stands for global model).
It parses the script into dynamic libraries which implement the actual computations (policy function iterations and Monte Carlo simulations) efficiently in C++, and provides a convenient MATLAB interface to researchers.

The toolbox can be used to solve models in macroeconomics, international finance, asset pricing, and related fields.

Try running your first example, :ref:`Heaton and Lucas (1996) <HL1996>`, 
by uploading the gmod file :download:`HL1996 <example/HL1996/HL1996.gmod>` to an online compiler server deployed at

[`Windows <http://122.112.231.135/>`_] [`MacOS <http://166.111.98.85:20000/>`_] 

.. |paper_link| raw:: html

   <a href="https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3569013" target="_blank">Cao, Luo, and Nie (2020)</a>


More examples and detailed instructions on gmod files and on how to use the toolbox are provided below.

=================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   
   Home <self>
   example/rbc/rbc
   example/rbc/rbcIrr
   example/HL1996/HL1996
   example/Guvenen2009/Guvenen2009
   example/Bianchi2011/Bianchi2011
   example/safe_assets/safe_assets
   example/pandemic/GLSW2020
   usage/functions
   example/AdditionalExamples


Indices and tables
==================

* :ref:`genindex`
