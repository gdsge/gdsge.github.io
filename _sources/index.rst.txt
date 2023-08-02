.. GDSGE documentation master file, created by
   sphinx-quickstart on Thu Feb  6 16:44:37 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

============================================================
GDSGE: A Toolbox for Solving DSGE Models with Global Methods
============================================================

Welcome to GDSGE's documentation! 

GDSGE is a toolbox that solves nonlinear Dynamic Stochastic General Equilibrium (DSGE) models with a global method based on the Simultaneous Transition and Policy
Function Iteration (STPFI) algorithm
introduced in |paper_link|.
It allows users to define economic models in compact and intuitive scripts, called gmod files (gmod stands for global model).
It parses the script into dynamic libraries which implement the actual computations (policy function iterations and Monte Carlo simulations) efficiently in C++, and provides a convenient MATLAB interface to researchers.

The toolbox can be used to solve models in macroeconomics, international finance, asset pricing, and related fields.

GDSGE can now run on MATLAB Online! Log into the `MATLAB Online <https://matlab.mathworks.com>`_. And run in the MATLAB command window

.. code-block:: MATLAB

   websave('gdsge.zip','https://github.com/gdsge/gdsge/archive/refs/tags/v0.1.3.zip')
   unzip gdsge.zip
   mex -setup c++
   cd gdsge-0.1.3/tests
   runtests

These commands download the latest version of the toolbox, setup the mex compiler, and run the test examples.
These produce all results in the companion paper |paper_link|.

With MATLAB on a local machine, try running the leading example, :ref:`Heaton and Lucas (1996) <HL1996>`, 
by downloading the toolbox source code :download:`gdsge_master.zip <https://cloud.tsinghua.edu.cn/f/2b648dea73b647a8a9e7/?dl=1>`
and compiling the gmod file :download:`HL1996 <example/HL1996/HL1996.gmod>` by running in MATLAB

.. code-block:: MATLAB

   gdsge_codegen('HL1996')

.. |paper_link| raw:: html

   <a href="https://www.sciencedirect.com/science/article/pii/S1094202523000017" target="_blank">Cao, Luo, and Nie (2023)</a>

The toolbox source code can be found at: https://github.com/gdsge/gdsge, where you can download the latest version of the toolbox, find detailed instructions for setting up the compiler, and submit issues.

Examples and documentation of the toolbox are provided below.

Lectures on the toolbox can be found at :ref:`Lectures <GDSGE_Lectures>`.

If you have comments, suggestions or coding questions for us, or would like to contribute GDSGE examples, please reach out to us at: gdsge.cln2020@gmail.com

=================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   
   Home <self>
   lectures
   example/rbc/rbc
   example/simple_zlb/simple_zlb
   example/rbc/rbcIrr
   example/HL1996/HL1996
   example/Guvenen2009/Guvenen2009
   example/Bianchi2011/Bianchi2011
   example/safe_assets/safe_assets
   example/pandemic/GLSW2020
   example/multi_country_rbc/multi_country_rbc
   example/ZLB/zlb
   usage/functions
   example/AdditionalExamples
   example/ContributedExamples


Indices and tables
==================

* :ref:`genindex`
