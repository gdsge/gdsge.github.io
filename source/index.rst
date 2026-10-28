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

Then try the leading example, :ref:`Heaton and Lucas (1996) <HL1996>`. Its gmod file
:download:`HL1996.gmod <example/HL1996/HL1996.gmod>` ships with the toolbox under ``tests/HeatonLucas1996``.
Continuing from the ``tests`` folder above, run in MATLAB

.. code-block:: MATLAB

   cd HeatonLucas1996
   gdsge_codegen('HL1996')              % parse the gmod file, generate code, compile the mex file
   IterRslt = iter_HL1996;              % policy iterations
   SimuRslt = simulate_HL1996(IterRslt); % Monte Carlo simulations

.. _compiling_a_model:

.. rubric:: Compiling a model

gmod files are compiled locally, on your own machine, by the C++ compiler that ``mex -setup c++`` configured; there is no separate compiler to install or service to upload to.
To compile your own model, add the toolbox's ``src`` folder to the MATLAB search path once per session
(``runtests`` does this for you), change directory to the folder that contains ``<model>.gmod``, and run

.. code-block:: MATLAB

   addpath('path/to/gdsge-main/src')
   gdsge_codegen('model')

This generates ``iter_model.m``, ``simulate_model.m`` and ``mex_model.cpp`` in the current folder and compiles the mex file ``mex_model`` (e.g., ``mex_model.mexw64`` on Windows).
Compiling again is fast if the model's C++ code has not changed, because the mex file is reused.
Then call ``iter_model`` to solve the model and ``simulate_model`` to simulate it (see :ref:`Toolbox API`).
Alternatively, ``gdsge('model')`` compiles, solves and simulates in one call.

Optionally, run ``gdsge_setup_sympy`` once to enable the SymPy backend, which computes analytic Jacobians and requires Python (the command installs it for you through ``uv``).
The default backend needs only MATLAB and a C++ compiler.

.. note::

   Since version 0.2 the toolbox has been rebuilt from the ground up, and all gmod files still run unchanged.
   The old online compiler has been retired. All compilation now happens locally with ``gdsge_codegen``.
   See the `toolbox README <https://github.com/gdsge/gdsge>`_ for what's new.
   The original toolbox is archived on the `legacy-0.1.x <https://github.com/gdsge/gdsge/tree/legacy-0.1.x>`_ branch.

.. |paper_link| raw:: html

   <a href="https://www.sciencedirect.com/science/article/pii/S1094202523000017" target="_blank">Cao, Luo, and Nie (2023)</a>

The toolbox source code is hosted at: https://github.com/gdsge/gdsge, where you can download the latest version of the toolbox, find detailed instructions for setting up the compiler, and submit issues.

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
